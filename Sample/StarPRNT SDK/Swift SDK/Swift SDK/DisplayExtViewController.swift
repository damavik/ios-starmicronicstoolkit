//
//  DisplayExtViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class DisplayExtViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    enum DisplayStatus: Int {
        case invalid = 0
        case impossible
        case connect
        case disconnect
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var port: SMPort!
    
    var displayStatus: DisplayStatus!
    
    var lock: NSRecursiveLock!
    
    var dispatchGroup: DispatchGroup!
    
    var terminateTaskSemaphore: DispatchSemaphore!
    
    var selectedIndexPath: IndexPath!
    
    var internationalType: SCDCBInternationalType!
    var codePageType:      SCDCBCodePageType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.commentLabel.text = ""
        
        self.commentLabel.adjustsFontSizeToFitWidth = true
        
        self.appendRefreshButton(#selector(DisplayExtViewController.refreshDisplay))
        
        self.port = nil
        
        self.displayStatus = DisplayStatus.invalid
        
        self.lock = NSRecursiveLock()
        
        self.dispatchGroup = DispatchGroup()
        
        self.terminateTaskSemaphore = DispatchSemaphore(value: 1)
        
        self.selectedIndexPath = nil
        
        self.internationalType = SCDCBInternationalType.usa
        self.codePageType      = SCDCBCodePageType.cp437
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DisplayExtViewController.applicationWillResignActive), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DisplayExtViewController.applicationDidBecomeActive),  name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),  object:nil)
        
        self.refreshDisplay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = self.disconnect()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"),  object: nil)
    }
    
    func applicationDidBecomeActive() {
        self.beginAnimationCommantLabel()
        
        self.refreshDisplay()
    }
    
    func applicationWillResignActive() {
        _ = self.disconnect()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleValue1"
        
//      var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            switch (indexPath.row) {
            case 0  : cell.textLabel!.text = "Text"
            case 1  : cell.textLabel!.text = "Graphic"
            case 2  : cell.textLabel!.text = "Turn On / Off"
            case 3  : cell.textLabel!.text = "Cursor"
            case 4  : cell.textLabel!.text = "Contrast"
            case 5  : cell.textLabel!.text = "Character Set"
            default : cell.textLabel!.text = "User Defined Character"      // 6
            }
            
            cell.detailTextLabel!.text = ""
            
            cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contents"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndexPath = indexPath
        
        self.pickerView.reloadAllComponents()
        
        let commands: NSMutableData = NSMutableData()
        
        switch indexPath.row {
        case 0 :     // Text
            commands.append(DisplayFunctions.createClearScreen() as Data)
            
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType))
            
            commands.append(DisplayFunctions.createTextPattern(0))
        case 1 :     // Graphic
            commands.append(DisplayFunctions.createClearScreen() as Data)
            
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createGraphicPattern(0))
        case 2 :     // Turn On / Off
//          commands.appendData(DisplayFunctions.createClearScreen())
            
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createTurnOn(true))
        case 3 :     // Cursor
            commands.append(DisplayFunctions.createClearScreen() as Data)
            
            self.pickerView.selectRow(SCDCBCursorMode.on.rawValue, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createCursorMode(SCDCBCursorMode.on))
        case 4 :     // Contrast
//          commands.appendData(DisplayFunctions.createClearScreen())
            
            self.pickerView.selectRow(SCDCBContrastMode.default.rawValue, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createContrastMode(SCDCBContrastMode.default))
        case 5 :     // Character Set
            commands.append(DisplayFunctions.createClearScreen() as Data)
            
            self.pickerView.selectRow(SCDCBInternationalType.usa  .rawValue, inComponent: 0, animated: false)
            self.pickerView.selectRow(SCDCBCodePageType     .cp437.rawValue, inComponent: 1, animated: false)
            
            self.internationalType = SCDCBInternationalType.usa
            self.codePageType      = SCDCBCodePageType.cp437
            
            commands.append(DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType))
//      case 6  :     // User Defined Character
        default :
            commands.append(DisplayFunctions.createClearScreen() as Data)
            
            self.pickerView.selectRow(0, inComponent: 0, animated: false)
            
            commands.append(DisplayFunctions.createUserDefinedCharacter(true))
        }
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.lock.lock()
        
        defer {
            self.lock.unlock()
        }
        
        if self.displayStatus == DisplayStatus.connect {
            _ = DisplayCommunication.passThroughCommands(commands as Data, port: self.port, completionHandler: { (result: Bool, title: String, message: String) in
                if result == false {
                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        else {
            let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Display Disconnect.", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let number: Int
        
        if self.selectedIndexPath == nil {
            number = 0
        }
        else {
            switch self.selectedIndexPath.row {
            case 0  : number = 1     // Text
            case 1  : number = 1     // Graphic
            case 2  : number = 1     // Turn On / Off
            case 3  : number = 1     // Cursor
            case 4  : number = 1     // Contrast
            case 5  : number = 2     // Character Set
            default : number = 1     // User Defined Character
            }
        }
        
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let number: Int
        
        if self.selectedIndexPath == nil {
            number = 0
        }
        else {
            switch self.selectedIndexPath.row {
            case 0  : number = 6      // Text
            case 1  : number = 4      // Graphic
            case 2  : number = 2      // Turn On / Off
            case 3  : number = 3      // Cursor
            case 4  : number = 7      // Contrast
            case 5  : number = 14     // Character Set
            default : number = 2      // User Defined Character
            }
        }
        
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if view == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: component).width, height: pickerView.rowSize(forComponent: component).height))
        }
        else {
            label = view as! UILabel
        }
     
        if self.selectedIndexPath == nil {
            label.text = ""
        }
        else {
            switch self.selectedIndexPath.row {
            case 0  :     // Text
                switch row {
                case 0  : label.text = "Pattern 1"
                case 1  : label.text = "Pattern 2"
                case 2  : label.text = "Pattern 3"
                case 3  : label.text = "Pattern 4"
                case 4  : label.text = "Pattern 5"
                default : label.text = "Pattern 6"     // 5
                }
            case 1 :     // Graphic
                switch row {
                case 0  : label.text = "Pattern 1"
                case 1  : label.text = "Pattern 2"
                case 2  : label.text = "Pattern 3"
                default : label.text = "Pattern 4"     // 3
                }
            case 2 :     // Turn On / Off
                switch row {
                case 0  : label.text = "Turn On"
                default : label.text = "Turn Off"     // 1
                }
            case 3 :     // Cursor
                switch row {
                case 0  : label.text = "Off"
                case 1  : label.text = "Blink"
                default : label.text = "On"        // 2
                }
            case 4 :     // Contrast
                switch row {
                case 0  : label.text = "Contrast -3"
                case 1  : label.text = "Contrast -2"
                case 2  : label.text = "Contrast -1"
//              case 3  : label.text = "Default"
                case 4  : label.text = "Contrast +1"
                case 5  : label.text = "Contrast +2"
                case 6  : label.text = "Contrast +3"
                default : label.text = "Default"         // 3
                }
            case 5 :     // Character Set
                switch component {
                case 0 :
                    switch row {
//                  case 0  : label.text = "USA"
                    case 1  : label.text = "France"
                    case 2  : label.text = "Germany"
                    case 3  : label.text = "UK"
                    case 4  : label.text = "Denmark"
                    case 5  : label.text = "Sweden"
                    case 6  : label.text = "Italy"
                    case 7  : label.text = "Spain"
                    case 8  : label.text = "Japan"
                    case 9  : label.text = "Norway"
                    case 10 : label.text = "Denmark 2"
                    case 11 : label.text = "Spain 2"
                    case 12 : label.text = "Latin America"
                    case 13 : label.text = "Korea"
                    default : label.text = "USA"               // 0
                    }
//              case 1  :
                default :
                    switch row {
//                  case 0  : label.text = "Code Page 437"
                    case 1  : label.text = "Katakana"
                    case 2  : label.text = "Code Page 850"
                    case 3  : label.text = "Code Page 860"
                    case 4  : label.text = "Code Page 863"
                    case 5  : label.text = "Code Page 865"
                    case 6  : label.text = "Code Page 1252"
                    case 7  : label.text = "Code Page 866"
                    case 8  : label.text = "Code Page 852"
                    case 9  : label.text = "Code Page 858"
                    case 10 : label.text = "Japanese"
                    case 11 : label.text = "Simplified Chinese"
                    case 12 : label.text = "Traditional Chinese"
                    case 13 : label.text = "Hangul"
                    default : label.text = "Code Page 437"           // 0
                    }
                }
//          case 6  :     // User Defined Character
            default :
                switch (row) {
                case 0  : label.text = "Set"
                default : label.text = "Reset"     // 1
                }
            }
        }
        
        label.font                      = UIFont.systemFont(ofSize: 22.0)
        label.textAlignment             = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let commands: Data
        
        switch self.selectedIndexPath.row {
        case 0 :     // Text
            commands = DisplayFunctions.createTextPattern(row)
        case 1 :     // Graphic
            commands = DisplayFunctions.createGraphicPattern(row)
        case 2 :     // Turn On / Off
            switch row {
            case 0  : commands = DisplayFunctions.createTurnOn(true)
            default : commands = DisplayFunctions.createTurnOn(false)     // 1
            }
        case 3 :     // Cursor
            commands = DisplayFunctions.createCursorMode(SCDCBCursorMode(rawValue: row)!)
        case 4 :     // Contrast
            commands = DisplayFunctions.createContrastMode(SCDCBContrastMode(rawValue: row)!)
        case 5 :     // Character Set
            self.internationalType = SCDCBInternationalType(rawValue: self.pickerView.selectedRow(inComponent: 0))
            self.codePageType      = SCDCBCodePageType     (rawValue: self.pickerView.selectedRow(inComponent: 1))
            
            commands = DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType)
//      case 6  :     // User Defined Character
        default :
            switch (row) {
            case 0  : commands = DisplayFunctions.createUserDefinedCharacter(true)
            default : commands = DisplayFunctions.createUserDefinedCharacter(false)     // case 1
            }
        }
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.lock.lock()
        
        defer {
            self.lock.unlock()
        }
        
        if self.displayStatus == DisplayStatus.connect {
            _ = DisplayCommunication.passThroughCommands(commands, port: self.port, completionHandler: { (result: Bool, title: String, message: String) in
                if result == false {
                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        else {
            let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Display Disconnect.", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 160
    }
    
    func refreshDisplay() {
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
        
        self.commentLabel.isHidden = false
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
                    self.watchDisplayTask()
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
            
            self.displayStatus = DisplayStatus.invalid
            
            result = true
        }
        
        return result
    }
    
    func watchDisplayTask() {
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
                        _ = DisplayCommunication.requestStatus(self.port, completionHandler: { (result: Bool, title: String, message: String, connect: Bool) in
                            DispatchQueue.main.async(execute: {
                                if result == true {
                                    if connect == true {
                                        if self.displayStatus != DisplayStatus.connect {
                                            self.displayStatus = DisplayStatus.connect
                                            
//                                          self.commentLabel.text = "Accessory Connect Success."
//
//                                          self.commentLabel.textColor = UIColor.blue
//
//                                          self.beginAnimationCommantLabel()
                                            
                                            self.commentLabel.isHidden = true
                                        }
                                    }
                                    else {
                                        if self.displayStatus != DisplayStatus.disconnect {
                                            self.displayStatus = DisplayStatus.disconnect
                                            
                                            self.commentLabel.text = "Display Disconnect."
                                            
                                            self.commentLabel.textColor = UIColor.red
                                            
                                            self.beginAnimationCommantLabel()
                                            
                                            self.commentLabel.isHidden = false
                                        }
                                    }
                                }
                                else {
                                    if self.displayStatus != DisplayStatus.impossible {
                                        self.displayStatus = DisplayStatus.impossible
                                        
//                                      self.commentLabel.text = "Display Impossible."
                                        self.commentLabel.text = "Printer Impossible."
                                        
                                        self.commentLabel.textColor = UIColor.red
                                        
                                        self.beginAnimationCommantLabel()
                                        
                                        self.commentLabel.isHidden = false
                                    }
                                }
                            })
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            if self.displayStatus != DisplayStatus.impossible {
                                self.displayStatus = DisplayStatus.impossible
                                
//                              self.commentLabel.text = "Display Impossible."
                                self.commentLabel.text = "Printer Impossible."
                                
                                self.commentLabel.textColor = UIColor.red
                                
                                self.beginAnimationCommantLabel()
                                
                                self.commentLabel.isHidden = false
                            }
                        })
                    }
                    
                    self.lock.unlock()
                }
                
                let timeout: DispatchTime
                
                timeout = DispatchTime.now() + Double(Int64(UInt64(1.0) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)     // 1000mS!!!
                
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
