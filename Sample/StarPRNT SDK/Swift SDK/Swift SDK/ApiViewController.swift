//
//  ApiViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import UIKit

class ApiViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleValue1"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            switch indexPath.row {
            case 0  :
                cell.textLabel!.text = "Generic"
            case 1  :
                cell.textLabel!.text = "Font Style"
            case 2  :
                cell.textLabel!.text = "Initialization"
            case 3  :
                cell.textLabel!.text = "Code Page"
            case 4  :
                cell.textLabel!.text = "International"
            case 5  :
                cell.textLabel!.text = "Feed"
            case 6  :
                cell.textLabel!.text = "Character Space"
            case 7  :
                cell.textLabel!.text = "Line Space"
            case 8  :
                cell.textLabel!.text = "Emphasis"
            case 9  :
                cell.textLabel!.text = "Invert"
            case 10 :
                cell.textLabel!.text = "Under Line"
            case 11 :
                cell.textLabel!.text = "Multiple"
            case 12 :
                cell.textLabel!.text = "Absolute Position"
            case 13 :
                cell.textLabel!.text = "Alignment"
            case 14 :
                cell.textLabel!.text = "Logo"
            case 15 :
                cell.textLabel!.text = "Cut Paper"
            case 16 :
                cell.textLabel!.text = "Peripheral"
            case 17 :
                cell.textLabel!.text = "Sound"
            case 18 :
                cell.textLabel!.text = "Bitmap"
            case 19 :
                cell.textLabel!.text = "Barcode"
            case 20 :
                cell.textLabel!.text = "PDF417"
            case 21 :
                cell.textLabel!.text = "QR Code"
            case 22 :
                cell.textLabel!.text = "Black Mark"
//          case 23 :
            default :
                cell.textLabel!.text = "Page Mode"
            }
            
            cell.detailTextLabel!.text = ""
            
            cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sample"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        var commands: Data? = nil
        
        let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
        
        let width: Int = AppDelegate.getSelectedPaperSize().rawValue
        
        let alertView: UIAlertView
        
        switch indexPath.row {
        case 0  :
            commands = ApiFunctions.createGenericData(emulation)
        case 1  :
            commands = ApiFunctions.createFontStyleData(emulation)
        case 2  :
            commands = ApiFunctions.createInitializationData(emulation)
        case 3  :
            commands = ApiFunctions.createCodePageData(emulation)
        case 4  :
            commands = ApiFunctions.createInternationalData(emulation)
        case 5  :
            commands = ApiFunctions.createFeedData(emulation)
        case 6  :
            commands = ApiFunctions.createCharacterSpaceData(emulation)
        case 7  :
            commands = ApiFunctions.createLineSpaceData(emulation)
        case 8  :
            commands = ApiFunctions.createEmphasisData(emulation)
        case 9  :
            commands = ApiFunctions.createInvertData(emulation)
        case 10 :
            commands = ApiFunctions.createUnderLineData(emulation)
        case 11 :
            commands = ApiFunctions.createMultipleData(emulation)
        case 12 :
            commands = ApiFunctions.createAbsolutePositionData(emulation)
        case 13 :
            commands = ApiFunctions.createAlignmentData(emulation)
        case 14 :
            commands = ApiFunctions.createLogoData(emulation)
        case 15 :
            commands = ApiFunctions.createCutPaperData(emulation)
        case 16 :
            commands = ApiFunctions.createPeripheralData(emulation)
        case 17 :
            commands = ApiFunctions.createSoundData(emulation)
        case 18 :
            commands = ApiFunctions.createBitmapData(emulation, width: width)
        case 19 :
            commands = ApiFunctions.createBarcodeData(emulation)
        case 20 :
            commands = ApiFunctions.createPdf417Data(emulation)
        case 21 :
            commands = ApiFunctions.createQrCodeData(emulation)
        case 22 :
            alertView = UIAlertView(title: "Select black mark type.",
                                  message: "",
                                 delegate: self,
                        cancelButtonTitle: "Cancel",
                        otherButtonTitles: "Invalid", "Valid", "Valid with Detection")
            
            alertView.show()
//      case 23 :
        default :
            commands = ApiFunctions.createPageModeData(emulation, width: width)
        }
        
        if commands != nil {
            self.blind = true
            
            defer {
                self.blind = false
            }
            
            let portName:     String = AppDelegate.getPortName()
            let portSettings: String = AppDelegate.getPortSettings()
            
            _ = Communication.sendCommands(commands, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (result: Bool, title: String, message: String) in     // 10000mS!!!
                let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                
                alertView.show()
            })
        }
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var commands: Data? = nil
            
            let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
            
            switch (buttonIndex - 1) {
            case 0 :      // Invalid
                commands = ApiFunctions.createBlackMarkData(emulation, type: SCBBlackMarkType.invalid)
            case 1 :      // Valid
                commands = ApiFunctions.createBlackMarkData(emulation, type: SCBBlackMarkType.valid)
//          case 2 :      // Valid with Detection
            default :
                commands = ApiFunctions.createBlackMarkData(emulation, type: SCBBlackMarkType.validWithDetection)
            }
            
            self.blind = true
            
            defer {
                self.blind = false
            }
            
            let portName:     String = AppDelegate.getPortName()
            let portSettings: String = AppDelegate.getPortSettings()
            
            _ = Communication.sendCommands(commands, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (result: Bool, title: String, message: String) in     // 10000mS!!!
                let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                
                alertView.show()
            })
        }
    }
}
