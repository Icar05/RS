//
//  TimerUtil.swift
//  RS
//
//  Created by ICoon on 27.07.2022.
//

import Foundation
import AVKit

struct TimerUtilState{
    let state: TimerState
    let maxTime: Int
    let singleUpdateColor: Bool
}

public protocol TimerUtilDelegate: NSObject{
    func onTimerStart()
    func onTimerUpdate(current: Int, max: Int)
    func onTimerFinished(maxValue: Int)
    func onTimerStop(maxValue: Int)
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
    
    private var maxTimeInMinutes = 30
    
    private var timerOnlyForeground = false
    
    private var singleUpdateColor = false
    
    private var timer: Timer? = nil
    
    private var timerValue = 0
    
    private var state: TimerState = .CLEAR
    
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
            state: state,
            maxTime: maxTimeInMinutes,
            singleUpdateColor: singleUpdateColor)
    }
    
    func startTimer(){
        UIApplication.shared.isIdleTimerDisabled = timerOnlyForeground
        
        self.state = .STARTED
        self.notificationUtil.sceduleNotification(maxTimeInMinutes: maxTimeInMinutes)
        self.timerValue = maxTimeInMinutes.toSeconds()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        self.elapsedTimeUtil.saveStartTimerTime(maxTime: maxTimeInMinutes)
        self.delegate?.onTimerStart()
        
        printLog("startTimer, time: \(elapsedTimeUtil.getCurrentTime())")
    }
    
    func finishTimer(){
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.state = .FINISHED
        self.notificationUtil.cancelNotification()
        self.timer?.invalidate()
        self.timer = nil
        self.elapsedTimeUtil.clearStartTimerTime()
        self.delegate?.onTimerFinished(maxValue: maxTimeInMinutes.toSeconds())
        
        printLog("finishTimer, time: \(elapsedTimeUtil.getCurrentTime())")
    }
    
    func stopTimer(){
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.state = .CLEAR
        self.notificationUtil.cancelNotification()
        self.timer?.invalidate()
        self.timer = nil
        self.elapsedTimeUtil.clearStartTimerTime()
        self.delegate?.onTimerStop(maxValue: maxTimeInMinutes.toSeconds())
        
        printLog("stopTimer, time: \(elapsedTimeUtil.getCurrentTime())")
    }
    
    func refreshTimer(){
        self.soundUtil.stop()
        self.delegate?.onTimerStop(maxValue: maxTimeInMinutes.toSeconds())
    }
    
    // as more stick alternative you can use notificationUtil.hasPandingNotification
    // if it' has, timer run. cause after finish it all removed
    func isTimerStarted() -> Bool {
        return self.timer != nil
    }
    
    @objc func timerUpdate() {
        
        self.timerValue -= 1
        self.delegate?.onTimerUpdate(current: timerValue, max: maxTimeInMinutes.toSeconds())
        
        printLog("timerUpdate: \(timerValue)")
        
        if(timerValue == 0){
            self.finishTimer()
            self.soundUtil.play()
        }
    }
    
    @objc func appGoneToBackground() {
        printLog("app in background!")
    }
    
    @objc func appCameToForeground() {
        printLog("app in foreground!")
        
        
        let state = self.elapsedTimeUtil.getTimeState()
        
        printLog("results: \(state)")
        
//        self.delegate?.needDebug(value: "expired: \(state.0)")
        
        if(state.0){
            self.timerHasFinishedInBackground()
        }else{
            self.timerHasUpdatedInBackground(elapsedTime: state.1, left: state.2)
        }

    }
    
    
    //we don't have any messages
    //timer can be still running, or state can be already handled
    private func timerHasUpdatedInBackground(elapsedTime: Int, left: Int){
        printLog("timer has not finished: \(elapsedTime) / \(maxTimeInMinutes.toSeconds())")
        self.timerValue = left
        self.delegate?.onTimerUpdate(current: timerValue, max: maxTimeInMinutes.toSeconds())
    }
    
    //we have delivered message, we have to notify timer about finish
    private func timerHasFinishedInBackground(){
        printLog("timer has finished !")
        self.finishTimer()
        self.notificationUtil.clearDeliveredNotifications()
    }

    
    private func printLog(_ value: String){
        if(showLogs){
            print("\(log): \(value)")
        }
    }
}

