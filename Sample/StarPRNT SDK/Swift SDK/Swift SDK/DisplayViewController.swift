//
//  DisplayViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import UIKit

class DisplayViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexPath: IndexPath!
    
    var internationalType: SCDCBInternationalType!
    var codePageType:      SCDCBCodePageType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.selectedIndexPath = nil
        
        self.internationalType = SCDCBInternationalType.usa
        self.codePageType      = SCDCBCodePageType.cp437
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleValue1"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0  : cell.textLabel!.text = "Check Status"
                case 1  : cell.textLabel!.text = "Text"
                case 2  : cell.textLabel!.text = "Graphic"
                case 3  : cell.textLabel!.text = "Turn On / Off"
                case 4  : cell.textLabel!.text = "Cursor"
                case 5  : cell.textLabel!.text = "Contrast"
                case 6  : cell.textLabel!.text = "Character Set (International)"
                case 7  : cell.textLabel!.text = "Character Set (Code Page)"
                default : cell.textLabel!.text = "User Defined Character"            // 8
                }
            }
            else {
                cell.textLabel!.text = "Sample"
            }
            
            cell.detailTextLabel!.text = ""
            
            cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String
        
        if section == 0 {
            title = "Contents"
        }
        else {
            title = "Like a StarIoExtManager Sample"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndexPath = indexPath
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.blind = true
                
                defer {
                    self.blind = false
                }
                
                guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                    let alertView: UIAlertView = UIAlertView(title: "Fail to Open Port", message: "", delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                    return
                }
                
                defer {
                    SMPort.release(port)
                }
                
                _ = DisplayCommunication.requestStatus(port, completionHandler: { (result: Bool, title: String, message: String, connect: Bool) in
                    if result == true {
                        if connect == true {
                            let alertView: UIAlertView = UIAlertView(title: "Check Status", message: "Display Connect.", delegate: nil, cancelButtonTitle: "OK")
                            
                            alertView.show()
                        }
                        else {
                            let alertView: UIAlertView = UIAlertView(title: "Check Status", message: "Display Disconnect.", delegate: nil, cancelButtonTitle: "OK")
                            
                            alertView.show()
                        }
                    }
                    else {
//                      let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Display Impossible.", delegate: nil, cancelButtonTitle: "OK")
                        let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Printer Impossible.", delegate: nil, cancelButtonTitle: "OK")
                        
                        alertView.show()
                    }
                })
            }
            else {
                let alertView: UIAlertView
                
                switch indexPath.row {
                case 1 :
                    alertView = UIAlertView(title: "Select Text",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Pattern 1", "Pattern 2", "Pattern 3", "Pattern 4", "Pattern 5", "Pattern 6")
                case 2 :
                    alertView = UIAlertView(title: "Select Graphic",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Pattern 1", "Pattern 2", "Pattern 3", "Pattern 4")
                case 3 :
                    alertView = UIAlertView(title: "Select Turn On / Off",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Turn On", "Turn Off")
                case 4 :
                    alertView = UIAlertView(title: "Select Cursor",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Off", "Blink", "On")
                case 5 :
                    alertView = UIAlertView(title: "Select Contrast",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Contrast -3", "Contrast -2", "Contrast -1", "Default", "Contrast +1", "Contrast +2", "Contrast +3")
                case 6 :
                    alertView = UIAlertView(title: "Select Character Set (International)",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "USA",   "France", "Germany", "UK",        "Denmark", "Sweden",        "Italy",
                                                   "Spain", "Japan",  "Norway",  "Denmark 2", "Spain 2", "Latin America", "Korea")
                case 7 :
                    alertView = UIAlertView(title: "Select Character Set (Code Page)",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Code Page 437",       "Katakana",      "Code Page 850", "Code Page 860", "Code Page 863", "Code Page 865",
                                                   "Code Page 1252",      "Code Page 866", "Code Page 852", "Code Page 858", "Japanese",      "Simplified Chinese",
                                                   "Traditional Chinese", "Hangul")
//              case 8  :
                default :
                    alertView = UIAlertView(title: "Select User Defined Character",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "Set", "Reset")
                }
                
                alertView.show()
            }
        }
        else {
            AppDelegate.setSelectedIndex(indexPath.row)
            
            self.performSegue(withIdentifier: "PushDisplayExtViewController", sender: nil)
        }
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let commands: NSMutableData = NSMutableData()
            
            switch self.selectedIndexPath.row {
            case 1 :     // Text
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                commands.append(DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType))
                
                commands.append(DisplayFunctions.createTextPattern(buttonIndex - 1))
            case 2 :     // Graphic
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                commands.append(DisplayFunctions.createGraphicPattern(buttonIndex - 1))
            case 3 :     // Turn On / Off
//              commands.appendData(DisplayFunctions.createClearScreen())
                
                switch buttonIndex - 1 {
                case 0  : commands.append(DisplayFunctions.createTurnOn(true))
                default : commands.append(DisplayFunctions.createTurnOn(false))     // 1
                }
            case 4 :     // Cursor
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                commands.append(DisplayFunctions.createCursorMode(SCDCBCursorMode(rawValue: buttonIndex - 1)!))
            case 5 :     // Contrast
//              commands.appendData(DisplayFunctions.createClearScreen())
                
                commands.append(DisplayFunctions.createContrastMode(SCDCBContrastMode(rawValue: buttonIndex - 1)!))
            case 6 :     // Character Set (International)
                self.internationalType = SCDCBInternationalType(rawValue: buttonIndex - 1)!
                
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                commands.append(DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType))
            case 7 :     // Character Set (Code Page)
                self.codePageType = SCDCBCodePageType(rawValue: buttonIndex - 1)!
                
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                commands.append(DisplayFunctions.createCharacterSet(self.internationalType, codePageType: self.codePageType))
//          case 8  :     // User Defined Character
            default :
                commands.append(DisplayFunctions.createClearScreen() as Data)
                
                switch buttonIndex - 1 {
                case 0  : commands.append(DisplayFunctions.createUserDefinedCharacter(true))
                default : commands.append(DisplayFunctions.createUserDefinedCharacter(false))     // 1
                }
            }
            
            self.blind = true
            
            defer {
                self.blind = false
            }
            
            guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                let alertView: UIAlertView = UIAlertView(title: "Fail to Open Port", message: "", delegate: nil, cancelButtonTitle: "OK")
                
                alertView.show()
                return
            }
            
            defer {
                SMPort.release(port)
            }
            
            _ = DisplayCommunication.requestStatus(port, completionHandler: { (result: Bool, title: String, message: String, connect: Bool) in
                if result == true {
                    if connect == true {
                        _ = DisplayCommunication.passThroughCommands(commands as Data, port: port, completionHandler: { (result: Bool, title: String, message: String) in
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
                else {
//                  let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Display Impossible.", delegate: nil, cancelButtonTitle: "OK")
                    let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Printer Impossible.", delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        
        return
    }
}
