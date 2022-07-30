//
//  TimerUtil.swift
//  RS
//
//  Created by ICoon on 27.07.2022.
//

import Foundation
import AVKit

struct TimerUtilState{
    let isStarted: Bool
    let maxTime: Int
    let singleUpdateColor: Bool
}

public protocol TimerUtilDelegate: NSObject{
    func onTimerUpdate(value: Int)
    func onTimerFinished()
    func onTimerStop()
    func needDebug(value: String)
}

let notificationIdentifier = "TimerNotification"

/**
    bad solution:  UIApplication.shared.isIdleTimerDisabled = true
 */
class TimerUtil{
    
    
    
    
    private let elapsedTimeUtil: ElapsedTimeUtil
    
    private let soundUtil: SoundUtil
    
    private let notificationUtil: NotificationUtil
    
    private let showLogs = false
    
    private let log = "TimerUtil"
    
    private var maxTimeInMinutes = DEFAULT_MAX_TIME
    
    private var timerOnlyForeground = false
    
    private var singleUpdateColor = false
    
    private var timer: Timer? = nil
    
    private var timerValue = 0
    
    weak var delegate: TimerUtilDelegate? = nil
    
    
    
    init(notificationUtil: NotificationUtil, soundUtil: SoundUtil, elapsedTimeUtil: ElapsedTimeUtil){
        self.notificationUtil = notificationUtil
        self.soundUtil = soundUtil
        self.elapsedTimeUtil = elapsedTimeUtil
        
        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appGoneToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
   
    func setMaxTime(maxTimeInMinutes: Int){
        self.maxTimeInMinutes = maxTimeInMinutes
    }
    
    func setTimerOnlyForeground(timerOnlyForeground: Bool){
        self.timerOnlyForeground = timerOnlyForeground
    }
    
    func setSingleUpdateColor(value: Bool){
        self.singleUpdateColor = value
    }
    
    func getState() -> TimerUtilState{
        return TimerUtilState(
            isStarted: isTimerStarted(),
            maxTime: maxTimeInMinutes,
            singleUpdateColor: singleUpdateColor)
    }
    
    func startTimer(){
        UIApplication.shared.isIdleTimerDisabled = timerOnlyForeground
        self.notificationUtil.sceduleNotification(maxTimeInMinutes: maxTimeInMinutes)
        self.timerValue = maxTimeInMinutes.toSeconds()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        self.elapsedTimeUtil.saveStartTimerTime()
        
        printLog("startTimer, time: \(elapsedTimeUtil.getCurrentTime())")
    }
    
    func stopTimer(){
        UIApplication.shared.isIdleTimerDisabled = false
        self.notificationUtil.cancelNotification()
        self.timer?.invalidate()
        self.timer = nil
        self.elapsedTimeUtil.clearStartTimerTime()
        self.delegate?.onTimerStop()
        
        printLog("stopTimer, time: \(elapsedTimeUtil.getCurrentTime())")
    }
    
    // as more stick alternative you can use notificationUtil.hasPandingNotification
    // if it' has, timer run. cause after finish it all removed
    func isTimerStarted() -> Bool {
        return self.timer != nil
    }
    
    @objc func timerUpdate() {
        
        self.timerValue -= 1
        self.delegate?.onTimerUpdate(value: timerValue)
        
        printLog("timerUpdate: \(timerValue)")
        
        if(timerValue == 0){
            self.delegate?.onTimerFinished()
            self.stopTimer()
            self.soundUtil.play()
        }
    }
    
    @objc func appGoneToBackground() {
        printLog("app in background!")
    }
    
    @objc func appCameToForeground() {
        printLog("app in foreground!")
        
        self.notificationUtil.hasDeliveredNotification(callback: {itHas in
            
            DispatchQueue.main.async {
                self.delegate?.needDebug(value: "Finished: \(itHas)")
            }
            
          
            
            if(itHas){
                self.timerHasFinishedInBackground()
            } else{
                if(self.isTimerStarted()){
                    self.timerHasUpdatedInBackground()
                }
            }
        })
    }
    
    
    //we don't have any messages
    //timer can be still running, or state can be already handled
    private func timerHasUpdatedInBackground(){
        
        let elapsedTime = elapsedTimeUtil.getElapsedTime()
        self.timerValue = maxTimeInMinutes.toSeconds() - elapsedTime
        
        printLog("timerHasUpdatedInBackground ( has not finished ), elapsed: \(elapsedTime)")
        
        DispatchQueue.main.async { [self] in
            self.delegate?.onTimerUpdate(value: self.timerValue)
        }
    }
    
    //we have delivered message, we have to notify timer about finish
    private func timerHasFinishedInBackground(){
        printLog("timerHasFinishedInBackground ( has finished)")
        DispatchQueue.main.async {
            self.stopTimer()
            self.notificationUtil.clearDeliveredNotifications()
        }
    }

    
    private func printLog(_ value: String){
        if(showLogs){
            print("\(log): \(value)")
        }
    }
}

