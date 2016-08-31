//
//  SearchPortViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import UIKit

class SearchPortViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    enum CellParamIndex: Int {
        case PortName = 0
        case ModelName
        case MacAddress
    }
    
    enum AlertViewIndex: Int {
        case RefreshPort = 0
        case PortName
        case PortSettings
        case ModelConfirm
        case ModelSelect0
        case ModelSelect1
        case CashDrawerOpenActive
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellArray: NSMutableArray!
    
    var selectedIndexPath: NSIndexPath!
    
    var didAppear: Bool!
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation: StarIoExtEmulation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//      self.appendRefreshButton                                  ("refreshPortInfo")
        self.appendRefreshButton(#selector(SearchPortViewController.refreshPortInfo))
        
        self.cellArray = NSMutableArray()
        
        self.selectedIndexPath = nil
        
        self.didAppear = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if didAppear == false {
            self.refreshPortInfo()
            
            self.didAppear = true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleSubtitle"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            let cellParam: [String] = self.cellArray[indexPath.row] as! [String]
            
//          cell      .textLabel!.text = cellParam[CellParamIndex.PortName.rawValue]
            cell      .textLabel!.text = cellParam[CellParamIndex.ModelName.rawValue]
//          cell.detailTextLabel!.text = cellParam[CellParamIndex.ModelName.rawValue]
            
            if cellParam[CellParamIndex.MacAddress.rawValue] == "" {
                cell.detailTextLabel!.text = cellParam[CellParamIndex.PortName.rawValue]
            }
            else {
                cell.detailTextLabel!.text = "\(cellParam[CellParamIndex.PortName.rawValue]) (\(cellParam[CellParamIndex.MacAddress.rawValue]))"
            }
            
            cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            if self.selectedIndexPath != nil {
                if indexPath.compare(self.selectedIndexPath) == NSComparisonResult.OrderedSame {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//      self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var cell: UITableViewCell!
        
        if self.selectedIndexPath != nil {
            cell = tableView.cellForRowAtIndexPath(self.selectedIndexPath)
            
            if cell != nil {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        self.selectedIndexPath = indexPath
        
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        
//      let portName:   String = cellParam[CellParamIndex.PortName  .rawValue]
        let modelName:  String = cellParam[CellParamIndex.ModelName .rawValue]
//      let macAddress: String = cellParam[CellParamIndex.MacAddress.rawValue]
        
        if false {     // Ex1. Direct Setting.
//          let portSettings: String = ""
//          let portSettings: String = "mini"
//          let portSettings: String = "escpos"
//          let portSettings: String = "Portable"
//
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.StarPRNT
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.StarLine
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.StarGraphic
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.EscPos
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.EscPosMobile
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.StarDotImpact
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewControllerAnimated(true)
        }
        else if false {     // Ex2. Direct Setting.
//          let modelIndex: ModelIndex = ModelIndex.MPOP
//          let modelIndex: ModelIndex = ModelIndex.FVP10
//          let modelIndex: ModelIndex = ModelIndex.TSP100
//          let modelIndex: ModelIndex = ModelIndex.TSP650II
//          let modelIndex: ModelIndex = ModelIndex.TSP700II
//          let modelIndex: ModelIndex = ModelIndex.TSP800II
//          let modelIndex: ModelIndex = ModelIndex.SM_S210I
//          let modelIndex: ModelIndex = ModelIndex.SM_S220I
//          let modelIndex: ModelIndex = ModelIndex.SM_S230I
//          let modelIndex: ModelIndex = ModelIndex.SM_T300I
//          let modelIndex: ModelIndex = ModelIndex.SM_T400I
//          let modelIndex: ModelIndex = ModelIndex.BSC10
//          let modelIndex: ModelIndex = ModelIndex.SM_S210I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.SM_S220I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.SM_S230I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.SM_T300I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.SM_T400I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.SM_L200
//          let modelIndex: ModelIndex = ModelIndex.SP700
//
//          let portSettings: String             = ModelCapability.portSettingsAtModelIndex(modelIndex)
//          let emulation:    StarIoExtEmulation = ModelCapability.emulationAtModelIndex   (modelIndex)
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewControllerAnimated(true)
        }
        else if false {     // Ex3. Indirect Setting.
//          let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(modelName)
//
//          let portSettings: String             = ModelCapability.portSettingsAtModelIndex(modelIndex)
//          let emulation:    StarIoExtEmulation = ModelCapability.emulationAtModelIndex   (modelIndex)
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewControllerAnimated(true)
        }
        else {     // Ex4. Indirect Setting.
            let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(modelName)
            
            if modelIndex != ModelIndex.None {
                let message: String = String(format: "Is your printer %@?", ModelCapability.titleAtModelIndex(modelIndex))
                
                let alertView: UIAlertView = UIAlertView.init(title: "Confirm.", message: message, delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "YES")
                
                alertView.tag = AlertViewIndex.ModelConfirm.rawValue
                
                alertView.show()
            }
            else {
                let alertView: UIAlertView = UIAlertView.init(title: "Confirm.", message: "What is your printer?", delegate: self, cancelButtonTitle: "Cancel")
                
//              for var i: Int = 0; i < ModelCapability.modelIndexCount(); i += 1 {
                for     i: Int in 0 ..< ModelCapability.modelIndexCount()         {
                    alertView.addButtonWithTitle(ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)))
                }
                
                alertView.tag = AlertViewIndex.ModelSelect0.rawValue
                
                alertView.show()
            }
        }
    }
    
    func refreshPortInfo() {
        let alertView: UIAlertView = UIAlertView.init(title: "Select Interface.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "LAN", "Bluetooth", "Bluetooth Low Energy", "All", "Manual")
        
        alertView.tag = AlertViewIndex.RefreshPort.rawValue
        
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == AlertViewIndex.PortName.rawValue {
            if buttonIndex == alertView.cancelButtonIndex {
                alertView.delegate = nil
                
                self.navigationController!.popViewControllerAnimated(true)
            }
            else {
                self.portName = alertView.textFieldAtIndex(0)!.text
                
                if self.portName == "" {
                    let nestAlertView: UIAlertView = UIAlertView.init(title: "Please enter the port name.", message: "Fill in the port name.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                    
                    nestAlertView.tag            = AlertViewIndex.PortName.rawValue
                    nestAlertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
                    
                    nestAlertView.textFieldAtIndex(0)!.text = AppDelegate.getPortName()
                    
                    nestAlertView.show()
                }
                else {
                    let nestAlertView: UIAlertView = UIAlertView.init(title: "Please enter the port settings.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                    
                    nestAlertView.tag            = AlertViewIndex.PortSettings.rawValue
                    nestAlertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
                    
                    nestAlertView.textFieldAtIndex(0)!.text = AppDelegate.getPortSettings()
                    
                    nestAlertView.show()
                }
            }
        }
        else if alertView.tag == AlertViewIndex.PortSettings.rawValue {
            if buttonIndex == alertView.cancelButtonIndex {
                alertView.delegate = nil
                
                self.navigationController!.popViewControllerAnimated(true)
            }
            else {
                self.portSettings = alertView.textFieldAtIndex(0)!.text
                
                let nestAlertView: UIAlertView = UIAlertView.init(title: "Confirm.", message: "What is your printer?", delegate: self, cancelButtonTitle: "Cancel")
                
//              for var i: Int = 0; i < ModelCapability.modelIndexCount(); i += 1 {
                for     i: Int in 0 ..< ModelCapability.modelIndexCount()         {
                    nestAlertView.addButtonWithTitle(ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)))
                }
                
                nestAlertView.tag = AlertViewIndex.ModelSelect1.rawValue
                
                nestAlertView.show()
            }
        }
        else if alertView.tag == AlertViewIndex.ModelConfirm.rawValue {
            if buttonIndex == 1 {     // YES!!!
                let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
                
                self.portName   = cellParam[CellParamIndex.PortName  .rawValue]
                self.modelName  = cellParam[CellParamIndex.ModelName .rawValue]
                self.macAddress = cellParam[CellParamIndex.MacAddress.rawValue]
                
                let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(self.modelName)
                
                self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
                self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
                
                if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
                    let nestAlertView: UIAlertView = UIAlertView.init(title: "Select CashDrawer Open Status.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "High when Open", "Low when Open")
                    
                    nestAlertView.tag = AlertViewIndex.CashDrawerOpenActive.rawValue
                    
                    nestAlertView.show()
                }
                else {
                    AppDelegate.setPortName                (self.portName)
                    AppDelegate.setPortSettings            (self.portSettings)
                    AppDelegate.setModelName               (self.modelName)
                    AppDelegate.setMacAddress              (self.macAddress)
                    AppDelegate.setEmulation               (self.emulation)
                    AppDelegate.setCashDrawerOpenActiveHigh(true)
                    
                    alertView.delegate = nil;
                    
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }
            else {     // NO!!!
                let nestAlertView: UIAlertView = UIAlertView.init(title: "Confirm.", message: "What is your printer?", delegate: self, cancelButtonTitle: "Cancel")
                
//              for var i: Int = 0; i < ModelCapability.modelIndexCount(); i += 1 {
                for     i: Int in 0 ..< ModelCapability.modelIndexCount()         {
                    nestAlertView.addButtonWithTitle(ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)))
                }
                
                nestAlertView.tag = AlertViewIndex.ModelSelect0.rawValue
                
                nestAlertView.show()
            }
        }
        else if alertView.tag == AlertViewIndex.ModelSelect0.rawValue {
            if buttonIndex != alertView.cancelButtonIndex {
                let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
                
                self.portName   = cellParam[CellParamIndex.PortName  .rawValue]
                self.modelName  = cellParam[CellParamIndex.ModelName .rawValue]
                self.macAddress = cellParam[CellParamIndex.MacAddress.rawValue]
                
                let modelIndex: ModelIndex = ModelCapability.modelIndexAtIndex(buttonIndex - 1)
                
                self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
                self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
                
                if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
                    let nestAlertView: UIAlertView = UIAlertView.init(title: "Select CashDrawer Open Status.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "High when Open", "Low when Open")
                    
                    nestAlertView.tag = AlertViewIndex.CashDrawerOpenActive.rawValue
                    
                    nestAlertView.show()
                }
                else {
                    AppDelegate.setPortName                (self.portName)
                    AppDelegate.setPortSettings            (self.portSettings)
                    AppDelegate.setModelName               (self.modelName)
                    AppDelegate.setMacAddress              (self.macAddress)
                    AppDelegate.setEmulation               (self.emulation)
                    AppDelegate.setCashDrawerOpenActiveHigh(true)
                    
                    alertView.delegate = nil;
                    
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }
        }
        else if alertView.tag == AlertViewIndex.ModelSelect1.rawValue {
            if buttonIndex != alertView.cancelButtonIndex {
                let modelIndex: ModelIndex = ModelCapability.modelIndexAtIndex(buttonIndex - 1)
                
                self.modelName    = ModelCapability.titleAtModelIndex       (modelIndex)
                self.macAddress   = self.portSettings;                                       // for display.
//              self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
                self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
                
                if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
                    let nestAlertView: UIAlertView = UIAlertView.init(title: "Select CashDrawer Open Status.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "High when Open", "Low when Open")
                    
                    nestAlertView.tag = AlertViewIndex.CashDrawerOpenActive.rawValue
                    
                    nestAlertView.show()
                }
                else {
                    AppDelegate.setPortName                (self.portName)
                    AppDelegate.setPortSettings            (self.portSettings)
                    AppDelegate.setModelName               (self.modelName)
                    AppDelegate.setMacAddress              (self.macAddress)
                    AppDelegate.setEmulation               (self.emulation)
                    AppDelegate.setCashDrawerOpenActiveHigh(true)
                    
                    alertView.delegate = nil;
                    
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }
        }
        else if alertView.tag == AlertViewIndex.CashDrawerOpenActive.rawValue {
            if buttonIndex != alertView.cancelButtonIndex {
                AppDelegate.setPortName    (self.portName)
                AppDelegate.setPortSettings(self.portSettings)
                AppDelegate.setModelName   (self.modelName)
                AppDelegate.setMacAddress  (self.macAddress)
                AppDelegate.setEmulation   (self.emulation)
                
                if buttonIndex == 1 {     // High when Open
                    AppDelegate.setCashDrawerOpenActiveHigh(true)
                }
                else if buttonIndex == 2 {     // Low when Open
                    AppDelegate.setCashDrawerOpenActiveHigh(false)
                }
                
                alertView.delegate = nil;
                
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView.tag == AlertViewIndex.RefreshPort.rawValue {
            if buttonIndex == alertView.cancelButtonIndex {
                alertView.delegate = nil
                
                self.navigationController!.popViewControllerAnimated(true)
            }
            else if buttonIndex == 5 {     // Manual
                let nestAlertView: UIAlertView = UIAlertView.init(title: "Please enter the port name.", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                
                nestAlertView.tag            = AlertViewIndex.PortName.rawValue
                nestAlertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
                
                nestAlertView.textFieldAtIndex(0)!.text = AppDelegate.getPortName()
                
                nestAlertView.show()
            }
            else {
                self.blind = true
                
                defer {
                    self.blind = false
                }
                
                self.cellArray.removeAllObjects()
                
                self.selectedIndexPath = nil
                
                let searchPrinterResult: [PortInfo]?
                
                switch buttonIndex {
                case 1  :     // LAN
                    searchPrinterResult = SMPort.searchPrinter("TCP:") as? [PortInfo]
                case 2  :     // Bluetooth
                    searchPrinterResult = SMPort.searchPrinter("BT:")  as? [PortInfo]
                case 3  :     // Bluetooth Low Energy
                    searchPrinterResult = SMPort.searchPrinter("BLE:") as? [PortInfo]
//              case 4  :     // All
                default :
                    searchPrinterResult = SMPort.searchPrinter()       as? [PortInfo]
                }
                
                guard let portInfoArray: [PortInfo] = searchPrinterResult else {
                    self.tableView.reloadData()
                    return
                }
                
                let portName:   String = AppDelegate.getPortName()
                let modelName:  String = AppDelegate.getModelName()
                let macAddress: String = AppDelegate.getMacAddress()
                
                var row: Int = 0
                
                for portInfo: PortInfo in portInfoArray {
                    self.cellArray.addObject([portInfo.portName, portInfo.modelName, portInfo.macAddress])
                    
                    if portInfo.portName   == portName  &&
                       portInfo.modelName  == modelName &&
                       portInfo.macAddress == macAddress {
                        self.selectedIndexPath = NSIndexPath(forRow: row, inSection: 0)
                    }
                    
                    row += 1
                }
                
                self.tableView.reloadData()
            }
        }
        
        return
    }
}
