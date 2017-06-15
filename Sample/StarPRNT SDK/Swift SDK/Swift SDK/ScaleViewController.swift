//
//  ScaleViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import UIKit

class ScaleViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            return 4
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
                case 1  : cell.textLabel!.text = "Displayed Weight"
                case 2  : cell.textLabel!.text = "Zero Clear"
                default : cell.textLabel!.text = "Unit Change"          // 3
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
        
        if indexPath.section == 0 {
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
            
            _ = ScaleCommunication.requestStatus(port, completionHandler: { (result: Bool, title: String, message: String, connect: Bool) in
                if result == true {
                    if connect == true {
                        if indexPath.row == 0 {
                            let alertView: UIAlertView = UIAlertView(title: "Check Status", message: "Scale Connect.", delegate: nil, cancelButtonTitle: "OK")
                            
                            alertView.show()
                        }
                        else if indexPath.row == 1 {
                            let displayedWeightFunction: IStarIoExtDisplayedWeightFunction = ScaleFunctions.createDisplayedWeightFunction()
                            
                            _ = ScaleCommunication.passThroughFunction(displayedWeightFunction, port: port, completionHandler: { (result: Bool, title: String, message: String) in
                                if result == true {
                                    let alertView: UIAlertView
                                    
                                    switch displayedWeightFunction.status.rawValue {
                                        case StarIoExtDisplayedWeightStatus.zero.rawValue :
                                            alertView = UIAlertView(title: "Success [Zero]",
                                                                  message: displayedWeightFunction.weight,
                                                                 delegate: nil,
                                                        cancelButtonTitle: "OK")
                                        case StarIoExtDisplayedWeightStatus.notInMotion.rawValue :
                                            alertView = UIAlertView(title: "Success [Not in motion]",
                                                                  message: displayedWeightFunction.weight,
                                                                 delegate: nil,
                                                        cancelButtonTitle: "OK")
                                        default                                             :
//                                      case StarIoExtDisplayedWeightStatus.motion.rawValue :
                                            alertView = UIAlertView(title: "Success [Motion]",
                                                                  message: displayedWeightFunction.weight,
                                                                 delegate: nil,
                                                        cancelButtonTitle: "OK")
                                    }
                                    
                                    alertView.show()
                                }
                                else {     // Because the scale doesn't sometimes react.
                                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                                    
                                    alertView.show()
                                }
                            })
                        }
                        else if indexPath.row == 2 {
                            let commands: Data = ScaleFunctions.createZeroClear()
                            
                            _ = ScaleCommunication.passThroughCommands(commands, port: port, completionHandler: { (result: Bool, title: String, message: String) in
                                let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                                
                                alertView.show()
                            })
                        }
                        else {
                            let commands: Data = ScaleFunctions.createUnitChange()
                            
                            _ = ScaleCommunication.passThroughCommands(commands, port: port, completionHandler: { (result: Bool, title: String, message: String) in
                                let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                                
                                alertView.show()
                            })
                        }
                    }
                    else {
                        let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Scale Disconnect.", delegate: nil, cancelButtonTitle: "OK")
                        
                        alertView.show()
                    }
                }
                else {
//                  let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Scale Impossible.",   delegate: nil, cancelButtonTitle: "OK")
                    let alertView: UIAlertView = UIAlertView(title: "Failure", message: "Printer Impossible.", delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                }
            })
        }
        else {
            AppDelegate.setSelectedIndex(indexPath.row)
            
            self.performSegue(withIdentifier: "PushScaleExtViewController", sender: nil)
        }
        
        return
    }
}
