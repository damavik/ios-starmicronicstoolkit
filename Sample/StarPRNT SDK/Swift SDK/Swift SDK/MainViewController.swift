//
//  MainViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import UIKit

class MainViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    enum SectionIndex: Int {
        case device = 0
        case printer
        case cashDrawer
        case barcodeReader
        case display
        case scale
        case combination
        case api
        case allReceipts
        case deviceStatus
        case appendixBluetooth
    }
    
    enum AlertViewIndex: Int {
        case language = 0
        case languageFixedPaperSize
        case paperSize
        case confirm
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let title: String = "StarPRNT Swift SDK"
        
        let version: String = String(format: "Ver.%@", Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        self.navigationItem.title = String(format: "%@ %@", title, version)
        
        self.selectedIndexPath = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//      return SectionIndex.device           .rawValue + 1
//      return SectionIndex.printer          .rawValue + 1
//      return SectionIndex.cashDrawer       .rawValue + 1
//      return SectionIndex.barcodeReader    .rawValue + 1
//      return SectionIndex.display          .rawValue + 1
//      return SectionIndex.scale            .rawValue + 1
//      return SectionIndex.combination      .rawValue + 1
//      return SectionIndex.api              .rawValue + 1
//      return SectionIndex.allReceipts      .rawValue + 1
//      return SectionIndex.deviceStatus     .rawValue + 1
        return SectionIndex.appendixBluetooth.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionIndex.printer.rawValue {
            return 4
        }
        
        if section == SectionIndex.appendixBluetooth.rawValue {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if SectionIndex(rawValue: indexPath.section)! == SectionIndex.device {
            if AppDelegate.getModelName() == "" {
                let cellIdentifier: String = "UITableViewCellStyleValue1"
                
                cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
                }
                
                if cell != nil {
                    cell.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
                    
                    cell      .textLabel!.text = "Unselected State"
                    cell.detailTextLabel!.text = ""
                    
                    cell      .textLabel!.textColor = UIColor.red
                    cell.detailTextLabel!.textColor = UIColor.red
                    
                    UIView.beginAnimations(nil, context: nil)
                    
                    cell      .textLabel!.alpha = 0.0
                    cell.detailTextLabel!.alpha = 0.0
                    
                    UIView.setAnimationDelay             (0.0)                             // 0mS!!!
                    UIView.setAnimationDuration          (0.6)                             // 600mS!!!
                    UIView.setAnimationRepeatCount       (Float(UINT32_MAX))
                    UIView.setAnimationRepeatAutoreverses(true)
                    UIView.setAnimationCurve             (UIViewAnimationCurve.easeIn)
                    
                    cell      .textLabel!.alpha = 1.0
                    cell.detailTextLabel!.alpha = 1.0
                    
                    UIView.commitAnimations()
                    
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    
                    cell.isUserInteractionEnabled = true
                }
            }
            else {
                let cellIdentifier: String = "UITableViewCellStyleSubtitle"
                
                cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
                }
                
                if cell != nil {
                    cell.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
                    
//                  cell      .textLabel!.text = AppDelegate.getPortName()
                    cell      .textLabel!.text = AppDelegate.getModelName()
//                  cell.detailTextLabel!.text = AppDelegate.getModelName()
                    
                    if AppDelegate.getMacAddress() == "" {
                        cell.detailTextLabel!.text = AppDelegate.getPortName()
                    }
                    else {
                        cell.detailTextLabel!.text = "\(AppDelegate.getPortName()) (\(AppDelegate.getMacAddress()))"
                    }
                    
                    cell      .textLabel!.textColor = UIColor.blue
                    cell.detailTextLabel!.textColor = UIColor.blue
                    
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
            }
        }
        else {
            let cellIdentifier: String = "UITableViewCellStyleValue1"
            
            cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
            }
            
            if cell != nil {
                switch SectionIndex(rawValue: indexPath.section)! {
                case SectionIndex.printer :
                    cell.backgroundColor = UIColor.white
                    
                    switch indexPath.row {
                    case 0 :
                        cell      .textLabel!.text = "Sample"
                        cell.detailTextLabel!.text = ""
                    case 1 :
                        cell      .textLabel!.text = "Black Mark Sample"
                        cell.detailTextLabel!.text = ""
                    case 2 :
                        cell      .textLabel!.text = "Black Mark Sample (Paste)"
                        cell.detailTextLabel!.text = ""
//                  case 3  :
                    default :
                        cell      .textLabel!.text = "Page Mode Sample"
                        cell.detailTextLabel!.text = ""
                    }
                    
                    cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                    cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                case SectionIndex.cashDrawer,
                     SectionIndex.display,
                     SectionIndex.scale,
                     SectionIndex.deviceStatus :
                    cell.backgroundColor = UIColor.white
                    
                    cell      .textLabel!.text = "Sample"
                    cell.detailTextLabel!.text = ""
                    
                    cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                    cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                case SectionIndex.barcodeReader,
                     SectionIndex.combination :
                    cell.backgroundColor = UIColor.white
                    
                    cell      .textLabel!.text = "StarIoExtManager Sample"
                    cell.detailTextLabel!.text = ""
                    
                    cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                    cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                case SectionIndex.api :
                    cell.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 1.0, alpha: 1.0)
                    
                    cell      .textLabel!.text = "Sample"
                    cell.detailTextLabel!.text = ""
                    
                    cell      .textLabel!.textColor = UIColor.blue
                    cell.detailTextLabel!.textColor = UIColor.blue
                case SectionIndex.allReceipts :
                    cell.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1.0)
                    
                    cell      .textLabel!.text = "Sample"
                    cell.detailTextLabel!.text = ""
                    
                    cell      .textLabel!.textColor = UIColor.blue
                    cell.detailTextLabel!.textColor = UIColor.blue
//              case SectionIndex.appendixBluetooth :
                default                            :
                    cell.backgroundColor = UIColor.white
                    
                    if indexPath.row == 0 {
                        cell      .textLabel!.text = "Pairing and Connect Bluetooth"
                        cell.detailTextLabel!.text = ""
                    }
                    else {
                        cell      .textLabel!.text = "Disconnect Bluetooth"
                        cell.detailTextLabel!.text = ""
                    }
                    
                    cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                    cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                }
                
                var userInteractionEnabled: Bool = true
                
                if AppDelegate.getModelName() == "" {
                    userInteractionEnabled = false
                }
                
                let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
                
                if emulation == StarIoExtEmulation.starGraphic {
                    if indexPath.section == SectionIndex.printer.rawValue {
                        if indexPath.row == 1 ||     // Black Mark Sample
                           indexPath.row == 2 {      // Black Mark Sample (Paste)
                            userInteractionEnabled = false
                        }
                    }
                }
                
                if emulation == StarIoExtEmulation.starGraphic ||
                   emulation == StarIoExtEmulation.starDotImpact {
                    if indexPath.section == SectionIndex.printer.rawValue {
                        if indexPath.row == 3 {      // Page Mode Sample
                            userInteractionEnabled = false
                        }
                    }
                }
                
                if emulation == StarIoExtEmulation.starLine    ||
                   emulation == StarIoExtEmulation.starGraphic ||
                   emulation == StarIoExtEmulation.escPos {
                    if indexPath.section == SectionIndex.barcodeReader.rawValue ||
                       indexPath.section == SectionIndex.display      .rawValue ||
                       indexPath.section == SectionIndex.scale        .rawValue ||
                       indexPath.section == SectionIndex.combination  .rawValue {
                        userInteractionEnabled = false
                    }
                }
                
                if emulation == StarIoExtEmulation.escPosMobile {
                    if indexPath.section == SectionIndex.cashDrawer   .rawValue ||
                       indexPath.section == SectionIndex.barcodeReader.rawValue ||
                       indexPath.section == SectionIndex.display      .rawValue ||
                       indexPath.section == SectionIndex.scale        .rawValue ||
                       indexPath.section == SectionIndex.combination  .rawValue {
                        userInteractionEnabled = false
                    }
                }
                
                if emulation == StarIoExtEmulation.starDotImpact {
                    if indexPath.section == SectionIndex.barcodeReader.rawValue ||
                       indexPath.section == SectionIndex.display      .rawValue ||
                       indexPath.section == SectionIndex.scale        .rawValue ||
                       indexPath.section == SectionIndex.combination  .rawValue ||
                       indexPath.section == SectionIndex.allReceipts  .rawValue {
                        userInteractionEnabled = false
                    }
                }
                
                if indexPath.section == SectionIndex.appendixBluetooth.rawValue {
                    if indexPath.row == 1 {     // Only Disconnect Bluetooth
                        if AppDelegate.getPortName().hasPrefix("BT:") == false {
                            userInteractionEnabled = false
                        }
                    }
                }
                
                if userInteractionEnabled == true {
                    cell      .textLabel!.alpha = 1.0
                    cell.detailTextLabel!.alpha = 1.0
                    
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    
                    cell.isUserInteractionEnabled = true
                }
                else {
                    cell      .textLabel!.alpha = 0.3
                    cell.detailTextLabel!.alpha = 0.3
                    
                    cell.accessoryType = UITableViewCellAccessoryType.none
                    
                    cell.isUserInteractionEnabled = false
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String!
        
        switch SectionIndex(rawValue: section)! {
        case SectionIndex.device :
            title = "Destination Device"
        case SectionIndex.printer :
            title = "Printer"
        case SectionIndex.cashDrawer :
            title = "Cash Drawer"
        case SectionIndex.barcodeReader :
            title = "Barcode Reader (for mPOP)"
        case SectionIndex.display :
            title = "Display (for mPOP)"
        case SectionIndex.scale :
            title = "Scale (for mPOP)"
        case SectionIndex.combination :
            title = "Combination (for mPOP)"
        case SectionIndex.api :
            title = "API"
        case SectionIndex.allReceipts :
            title = "AllReceipts"
        case SectionIndex.deviceStatus :
            title = "Device Status"
//      case SectionIndex.appendixBluetooth :
        default                             :
            title = "Appendix (Bluetooth)"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndexPath = indexPath
        
        let alertView: UIAlertView
        
        switch SectionIndex(rawValue: self.selectedIndexPath.section)! {
        case SectionIndex.device :
            self.performSegue(withIdentifier: "PushSearchPortViewController", sender: nil)
        case SectionIndex.printer :
            switch self.selectedIndexPath.row {
            case 0 :
                alertView = UIAlertView(title: "Select language.",
                                      message: "",
                                     delegate: self,
                            cancelButtonTitle: "Cancel",
                            otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German", "Russian", "Simplified Chinese", "Traditional Chinese")
                
                if AppDelegate.getEmulation() == StarIoExtEmulation.escPos ||
                   AppDelegate.getEmulation() == StarIoExtEmulation.starDotImpact {
                    alertView.tag = AlertViewIndex.languageFixedPaperSize.rawValue
                }
                else {
                    alertView.tag = AlertViewIndex.language.rawValue
                }
            case 1, 2 :
                alertView = UIAlertView(title: "Select language.",
                                      message: "",
                                     delegate: self,
                            cancelButtonTitle: "Cancel",
//                          otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German", "Russian", "Simplified Chinese", "Traditional Chinese")
                            otherButtonTitles: "English", "Japanese")
                
                alertView.tag = AlertViewIndex.languageFixedPaperSize.rawValue
//          case 3  :
            default :
                alertView = UIAlertView(title: "Select language.",
                                      message: "",
                                     delegate: self,
                            cancelButtonTitle: "Cancel",
//                          otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German", "Russian", "Simplified Chinese", "Traditional Chinese")
                            otherButtonTitles: "English", "Japanese")
                
                alertView.tag = AlertViewIndex.language.rawValue
            }
            
            alertView.show()
        case SectionIndex.cashDrawer :
            self.performSegue(withIdentifier: "PushCashDrawerViewController", sender: nil)
        case SectionIndex.barcodeReader,
             SectionIndex.display,
             SectionIndex.scale,
             SectionIndex.combination :
            alertView = UIAlertView(title: "This menu is for mPOP.",
                                  message: "",
                                 delegate: self,
                        cancelButtonTitle: "Cancel",
                        otherButtonTitles: "Continue")
            
            alertView.tag = AlertViewIndex.confirm.rawValue
            
            alertView.show()
        case SectionIndex.api :
            if AppDelegate.getEmulation() == StarIoExtEmulation.escPos {
                AppDelegate.setSelectedPaperSize(PaperSizeIndex.escPosThreeInch)
                
                self.performSegue(withIdentifier: "PushApiViewController", sender: nil)
            }
            else if AppDelegate.getEmulation() == StarIoExtEmulation.starDotImpact {
                AppDelegate.setSelectedPaperSize(PaperSizeIndex.dotImpactThreeInch)
                
                self.performSegue(withIdentifier: "PushApiViewController", sender: nil)
            }
            else {
                alertView = UIAlertView(title: "Select paper size.",
                    message: "",
                    delegate: self,
                    cancelButtonTitle: "Cancel",
                    otherButtonTitles: "2\" (384dots)", "3\" (576dots)", "4\" (832dots)")
                
                alertView.tag = AlertViewIndex.paperSize.rawValue
                
                alertView.show()
            }
        case SectionIndex.allReceipts :
            alertView = UIAlertView(title: "Select language.",
                                  message: "",
                                 delegate: self,
                        cancelButtonTitle: "Cancel",
//                      otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German", "Russian", "Simplified Chinese", "Traditional Chinese")
                        otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German")
            
            if AppDelegate.getEmulation() == StarIoExtEmulation.escPos {
                alertView.tag = AlertViewIndex.languageFixedPaperSize.rawValue
            }
            else {
                alertView.tag = AlertViewIndex.language.rawValue
            }
            
            alertView.show()
        case SectionIndex.deviceStatus :
            self.performSegue(withIdentifier: "PushDeviceStatusViewController", sender: nil)
//      case SectionIndex.appendixBluetooth :
        default                             :
            if self.selectedIndexPath.row == 0 {
                Communication.connectBluetooth({ (result: Bool, title: String?, message: String?) in
                    if title   != nil ||
                       message != nil {
                        let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                        
                        alertView.show()
                    }
                })
            }
            else {
                self.blind = true
                
                defer {
                    self.blind = false
                }
                
                let modelName:    String = AppDelegate.getModelName()
                let portName:     String = AppDelegate.getPortName()
                let portSettings: String = AppDelegate.getPortSettings()
                
                _ = Communication.disconnectBluetooth(modelName, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (result: Bool, title: String, message: String) in     // 10000mS!!!
                    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                    
                    alertView.show()
                })
            }
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let nestAlertView: UIAlertView
            
            switch AlertViewIndex(rawValue: alertView.tag)! {
            case AlertViewIndex.language :
                AppDelegate.setSelectedLanguage(LanguageIndex(rawValue: buttonIndex - 1)!)     // Same!!!
                
                nestAlertView = UIAlertView(title: "Select paper size.",
                                          message: "",
                                         delegate: self,
                                cancelButtonTitle: "Cancel",
                                otherButtonTitles: "2\" (384dots)", "3\" (576dots)", "4\" (832dots)")
                
                nestAlertView.tag = AlertViewIndex.paperSize.rawValue
                
                nestAlertView.show()
            case AlertViewIndex.languageFixedPaperSize :
                AppDelegate.setSelectedLanguage(LanguageIndex(rawValue: buttonIndex - 1)!)     // Same!!!
                
                switch SectionIndex(rawValue: self.selectedIndexPath.section)! {
                case SectionIndex.printer :
                    switch self.selectedIndexPath.row {
                    case 0 :
                        if AppDelegate.getEmulation() == StarIoExtEmulation.escPos {
                            AppDelegate.setSelectedPaperSize(PaperSizeIndex.escPosThreeInch)
                        }
                        else {
                            AppDelegate.setSelectedPaperSize(PaperSizeIndex.dotImpactThreeInch)
                        }
                        
                        self.performSegue(withIdentifier: "PushPrinterViewController",        sender: nil)
                    case 1 :
                        AppDelegate.setSelectedPaperSize(PaperSizeIndex.threeInch)
                        
                        self.performSegue(withIdentifier: "PushBlackMarkViewController",      sender: nil)
//                  case 2  :
                    default :
                        AppDelegate.setSelectedPaperSize(PaperSizeIndex.threeInch)
                        
                        self.performSegue(withIdentifier: "PushBlackMarkPasteViewController", sender: nil)
                    }
                case SectionIndex.combination :
                    AppDelegate.setSelectedPaperSize(PaperSizeIndex.twoInch)
                    
                    self.performSegue(withIdentifier: "PushCombinationViewController", sender: nil)
//              case SectionIndex.allReceipts :
                default                       :
                    AppDelegate.setSelectedPaperSize(PaperSizeIndex.escPosThreeInch)
                    
                    self.performSegue(withIdentifier: "PushAllReceiptsViewController", sender: nil)
              }
            case AlertViewIndex.paperSize :
                switch (buttonIndex - 1) {
                case 0 :
                    AppDelegate.setSelectedPaperSize(PaperSizeIndex.twoInch)
                case 1 :
                    AppDelegate.setSelectedPaperSize(PaperSizeIndex.threeInch)
//              case 2  :
                default :
                    AppDelegate.setSelectedPaperSize(PaperSizeIndex.fourInch)
                }
                
                switch SectionIndex(rawValue: self.selectedIndexPath.section)! {
                case SectionIndex.printer :
                    switch self.selectedIndexPath.row {
                    case 0 :
                        self.performSegue(withIdentifier: "PushPrinterViewController",  sender: nil)
//                  case 3  :
                    default :
                        self.performSegue(withIdentifier: "PushPageModeViewController", sender: nil)
                    }
                case SectionIndex.api :
                    self.performSegue(withIdentifier: "PushApiViewController",         sender: nil)
//              case SectionIndex.allReceipts :
                default                       :
                    self.performSegue(withIdentifier: "PushAllReceiptsViewController", sender: nil)
                }
            case AlertViewIndex.confirm :
                switch SectionIndex(rawValue: self.selectedIndexPath.section)! {
                case SectionIndex.barcodeReader :
                    self.performSegue(withIdentifier: "PushBarcodeReaderExtViewController", sender: nil)
                case SectionIndex.display :
                    self.performSegue(withIdentifier: "PushDisplayViewController",          sender: nil)
                case SectionIndex.scale :
                    self.performSegue(withIdentifier: "PushScaleViewController",            sender: nil)
//              case SectionIndex.combination :
                default                       :
                    nestAlertView = UIAlertView(title: "Select language.",
                                              message: "",
                                             delegate: self,
                                    cancelButtonTitle: "Cancel",
                                    otherButtonTitles: "English", "Japanese", "French", "Portuguese", "Spanish", "German", "Russian", "Simplified Chinese", "Traditional Chinese")
                    
                    nestAlertView.tag = AlertViewIndex.languageFixedPaperSize.rawValue
                    
                    nestAlertView.show()
                }
            }
        }
    }
}
