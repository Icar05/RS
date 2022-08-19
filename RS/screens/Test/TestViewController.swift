//
//  TestViewController.swift
//  RS
//
//  Created by ICoon on 18.08.2022.
//

import UIKit
import BLEApi

class TestViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let client = BLEClientImpl()
    
    private var text = ""
    
    private var errorText = ""
    
    @IBOutlet weak var stateSwitch: UISwitch!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "TestViewController", bundle: Bundle.main)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stateSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        
        self.client.delegate = self
        
        self.stateLabel.text = "Api Disabled"
        self.debugLabel.text = "Here will be text"
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        self.stateLabel.text = mySwitch.isOn ?  "Stop servise" : "Start Service"
        mySwitch.isOn ?  client.startBLEApi() : client.stopBLEApi()
    }

}

extension TestViewController: BLEApiListener{
    
    func didStopManager(value: String) {
        self.text += "\n"
        self.text += value
        self.debugLabel.text = text
        self.stateSwitch.setOn(false, animated: true)
        self.stateLabel.text = "Start Service"
    }
    
    func didStartManager(value: String) {
        self.text = ""
        self.errorText = ""
        self.text += "\n"
        self.text += value
        self.errorLabel.text = ""
        self.debugLabel.text = text
    }
    
    func didError(error: String) {
        self.errorText += "\n"
        self.errorText += error
        self.errorLabel.text = errorText
    }
    
    func didBluetoothStateChanged(value: String) {
        self.text += "\n"
        self.text += value
        self.debugLabel.text = text
    }
    
    func didNotified(value: String) {
        self.text += "\n"
        self.text += value
        self.debugLabel.text = text
    }
    
    
}
