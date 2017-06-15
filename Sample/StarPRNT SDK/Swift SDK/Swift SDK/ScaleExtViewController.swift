//
//  ScaleExtViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class ScaleExtViewController: CommonViewController, UIAlertViewDelegate {
    enum ScaleStatus: Int {
        case invalid = 0
        case impossible
        case connect
        case disconnect
    }
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var zeroClearButton:  UIButton!
    @IBOutlet weak var unitChangeButton: UIButton!
    
    var port: SMPort!
    
    var scaleStatus: ScaleStatus!
    
    var lock: NSRecursiveLock!
    
    var dispatchGroup: DispatchGroup!
    
    var terminateTaskSemaphore: DispatchSemaphore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.commentLabel.text = ""
        
        self.commentLabel.adjustsFontSizeToFitWidth = true
        
        self.zeroClearButton.isEnabled           = true
//      self.zeroClearButton.backgroundColor   = UIColor.cyan
        self.zeroClearButton.backgroundColor   = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        self.zeroClearButton.layer.borderColor = UIColor.blue.cgColor
        self.zeroClearButton.layer.borderWidth = 1.0
        
        self.unitChangeButton.isEnabled           = true
        self.unitChangeButton.backgroundColor   = UIColor.cyan
        self.unitChangeButton.layer.borderColor = UIColor.blue.cgColor
        self.unitChangeButton.layer.borderWidth = 1.0
        
        self.appendRefreshButton(#selector(ScaleExtViewController.refreshScale))
        
        self.port = nil
        
        self.scaleStatus = ScaleStatus.invalid
        
        self.lock = NSRecursiveLock()
        
        self.dispatchGroup = DispatchGroup()
        
        self.terminateTaskSemaphore = DispatchSemaphore(value: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScaleExtViewController.applicationWillResignActive), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScaleExtViewController.applicationDidBecomeActive),  name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),  object:nil)
        
        self.refreshScale()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = self.disconnect()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),  object: nil)
    }
    
    func applicationDidBecomeActive() {
        self.beginAnimationCommantLabel()
        
        self.refreshScale()
    }
    
    func applicationWillResignActive() {
        _ = self.disconnect()
    }
    
    @IBAction func touchUpInsideZeroClearButton(_ sender: UIButton) {
        let commands: Data = ScaleFunctions.createZeroClear() as Data
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.lock.lock()
        
        defer {
            self.lock.unlock()
        }
        
        if self.scaleStatus == ScaleStatus.connect {
            _ = ScaleCommunication.passThroughCommands(commands, port: self.port, completionHandler: { (result: Bool, title: String, message: String) in
                if result == false {
                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        else {
            let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Scale Disconnect.", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
    }
    
    @IBAction func touchUpInsideUnitChangeButton(_ sender: UIButton) {
        let commands: Data = ScaleFunctions.createUnitChange() as Data
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.lock.lock()
        
        defer {
            self.lock.unlock()
        }
        
        if self.scaleStatus == ScaleStatus.connect {
            _ = ScaleCommunication.passThroughCommands(commands, port: self.port, completionHandler: { (result: Bool, title: String, message: String) in
                if result == false {
                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        else {
            let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Scale Disconnect.", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
    }
    
    func refreshScale() {
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        _ = self.disconnect()
        
        if self.connect() == false {
            let alertView: UIAlertView = UIAlertView(title: "Fail to Open Port.", message: "", delegate: self, cancelButtonTitle: "OK")
            
            alertView.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.commentLabel.text = "Check the device. (Power and Bluetooth pairing)\nThen touch up the Refresh button."
        
        self.commentLabel.textColor = UIColor.red
        
        self.beginAnimationCommantLabel()
    }
    
    func connect() -> Bool {
        var result: Bool = true
        
        if self.port == nil {
            result = false
            
            while true {
                self.port = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000)     // 10000mS!!!
                
                if self.port == nil {
                    break
                }
                
                var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
                
                var error: NSError?
                
                self.port.getParsedStatus(&printerStatus, 2, &error)
                
                if error != nil {
                    SMPort.release(self.port)
                    
                    self.port = nil
                    break
                }
                
                _ = self.terminateTaskSemaphore.wait(timeout: DispatchTime.distantFuture)
                
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(group: self.dispatchGroup) { () -> Void in
                    self.watchScaleTask()
                }
                
                result = true
                break
            }
        }
        
        return result
    }
    
    func disconnect() -> Bool {
        var result: Bool = true
        
        if self.port != nil {
            result = false
            
            self.terminateTaskSemaphore.signal()
            
            _ = self.dispatchGroup.wait(timeout: DispatchTime.distantFuture)
            
            SMPort.release(self.port)
            
            self.port = nil
            
            self.scaleStatus = ScaleStatus.invalid
            
            result = true
        }
        
        return result
    }
    
    func watchScaleTask() {
        var terminate: Bool = false
        
        while terminate == false {
            autoreleasepool {
//              var portValid = false
                var portValid = true
                
                if self.lock.try() {
                    portValid = false
                    
                    if self.port != nil {
                        if self.port.connected() == true {
                            portValid = true
                        }
                    }
                    
                    if portValid == true {
                        let displayedWeightFunction: IStarIoExtDisplayedWeightFunction = ScaleFunctions.createDisplayedWeightFunction()
                        
                        _ = ScaleCommunication.passThroughFunction(displayedWeightFunction, port: self.port, completionHandler: { (result: Bool, title: String, message: String) in
                            if result == true {
                                DispatchQueue.main.async(execute: {
                                    self.scaleStatus = ScaleStatus.connect
                                    
                                    switch displayedWeightFunction.status.rawValue {
                                    case StarIoExtDisplayedWeightStatus.zero.rawValue :
                                        self.commentLabel.text = displayedWeightFunction.weight
                                        
//                                      self.commentLabel.textColor = UIColor.green
                                        self.commentLabel.textColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
                                        
                                        self.endAnimationCommantLabel()
                                    case StarIoExtDisplayedWeightStatus.notInMotion.rawValue :
                                        self.commentLabel.text = displayedWeightFunction.weight
                                        
                                        self.commentLabel.textColor = UIColor.blue
                                        
                                        self.endAnimationCommantLabel()
//                                  case StarIoExtDisplayedWeightStatus.motion.rawValue :
                                    default                                             :
                                        self.commentLabel.text = displayedWeightFunction.weight
                                        
                                        self.commentLabel.textColor = UIColor.red
                                        
                                        self.endAnimationCommantLabel()
                                    }
                                })
                            }
                            else {
                                _ = ScaleCommunication.requestStatus(self.port, completionHandler: { (result: Bool, title: String, message: String, connect: Bool) in
                                    DispatchQueue.main.async(execute: {
                                        if result == true {
                                            if connect == true {     // Because the scale doesn't sometimes react.
                                            }
                                            else {
                                                if self.scaleStatus != ScaleStatus.disconnect {
                                                    self.scaleStatus = ScaleStatus.disconnect
                                                    
                                                    self.commentLabel.text = "Scale Disconnect."
                                                    
                                                    self.commentLabel.textColor = UIColor.red
                                                    
                                                    self.beginAnimationCommantLabel()
                                                }
                                            }
                                        }
                                        else {
                                            if self.scaleStatus != ScaleStatus.impossible {
                                                self.scaleStatus = ScaleStatus.impossible
                                                
//                                              self.commentLabel.text = "Scale Impossible."
                                                self.commentLabel.text = "Printer Impossible."
                                                
                                                self.commentLabel.textColor = UIColor.red
                                                
                                                self.beginAnimationCommantLabel()
                                            }
                                        }
                                    })
                                })
                            }
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            if self.scaleStatus != ScaleStatus.impossible {
                                self.scaleStatus = ScaleStatus.impossible
                                
//                              self.commentLabel.text = "Scale Impossible."
                                self.commentLabel.text = "Printer Impossible."
                                
                                self.commentLabel.textColor = UIColor.red
                                
                                self.beginAnimationCommantLabel()
                            }
                        })
                    }
                    
                    self.lock.unlock()
                }
                
                let timeout: DispatchTime
                
                if portValid == true {
                    timeout = DispatchTime.now() + Double(Int64(UInt64(0.2) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)     // 200mS!!!
                }
                else {
                    timeout = DispatchTime.now() + Double(Int64(UInt64(1.0) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)     // 1000mS!!!
                }
                
                if self.terminateTaskSemaphore.wait(timeout: timeout) == DispatchTimeoutResult.success {
                    self.terminateTaskSemaphore.signal()
                    
                    terminate = true
                }
            }
        }
    }
    
    func beginAnimationCommantLabel() {
        UIView.beginAnimations(nil, context: nil)
        
        self.commentLabel.alpha = 0.0
        
        UIView.setAnimationDelay             (0.0)                             // 0mS!!!
        UIView.setAnimationDuration          (0.6)                             // 600mS!!!
        UIView.setAnimationRepeatCount       (Float(UINT32_MAX))
        UIView.setAnimationRepeatAutoreverses(true)
        UIView.setAnimationCurve             (UIViewAnimationCurve.easeIn)
        
        self.commentLabel.alpha = 1.0
        
        UIView.commitAnimations()
    }
    
    func endAnimationCommantLabel() {
        self.commentLabel.layer.removeAllAnimations()
    }
}
