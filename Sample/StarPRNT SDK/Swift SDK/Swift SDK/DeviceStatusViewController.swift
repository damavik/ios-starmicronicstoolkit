//
//  DeviceStatusViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import UIKit

class DeviceStatusViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    enum CellParamIndex: Int {
        case TitleIndex = 0
        case DetailIndex
        case ColorIndex
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellArray: NSMutableArray!
    
    var didAppear: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//      self.appendRefreshButton                                    ("refreshDeviceStatus")
        self.appendRefreshButton(#selector(DeviceStatusViewController.refreshDeviceStatus))
        
        self.cellArray = NSMutableArray()
        
        self.didAppear = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if didAppear == false {
            self.refreshDeviceStatus()
            
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
        let cellIdentifier: String = "UITableViewCellStyleValue1"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            let cellParam: [AnyObject] = self.cellArray[indexPath.row] as! [AnyObject]
            
            cell      .textLabel!.text      = cellParam[CellParamIndex.TitleIndex .rawValue] as? String
            cell.detailTextLabel!.text      = cellParam[CellParamIndex.DetailIndex.rawValue] as? String
            cell.detailTextLabel!.textColor = cellParam[CellParamIndex.ColorIndex .rawValue] as! UIColor
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contents"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshDeviceStatus() {
        var result: Bool = false
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        self.cellArray.removeAllObjects()
        
        var error: NSError?
        
        while true {
            guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                break
            }
            
            defer {
                SMPort.releasePort(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                self.cellArray.addObject(["Online", "Offline", UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Online",  "Online",  UIColor.blueColor()])
            }
            
            if printerStatus.coverOpen == sm_true {
                self.cellArray.addObject(["Cover", "Open",   UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Cover", "Closed", UIColor.blueColor()])
            }
            
            if printerStatus.receiptPaperEmpty == sm_true {
                self.cellArray.addObject(["Paper", "Empty", UIColor.redColor()])
            }
            else if printerStatus.receiptPaperNearEmptyInner == sm_true ||
                    printerStatus.receiptPaperNearEmptyOuter == sm_true {
                self.cellArray.addObject(["Paper", "Near Empty", UIColor.orangeColor()])
            }
            else {
                self.cellArray.addObject(["Paper", "Ready",      UIColor.blueColor()])
            }
            
            if AppDelegate.getCashDrawerOpenActiveHigh() == true {
                if printerStatus.compulsionSwitch == sm_true {
                    self.cellArray.addObject(["Cash Drawer", "Open",   UIColor.redColor()])
                }
                else {
                    self.cellArray.addObject(["Cash Drawer", "Closed", UIColor.blueColor()])
                }
            }
            else {
                if printerStatus.compulsionSwitch == sm_true {
                    self.cellArray.addObject(["Cash Drawer", "Closed", UIColor.blueColor()])
                }
                else {
                    self.cellArray.addObject(["Cash Drawer", "Open",   UIColor.redColor()])
                }
            }
            
            if printerStatus.overTemp == sm_true {
                self.cellArray.addObject(["Head Temperature", "High",   UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Head Temperature", "Normal", UIColor.blueColor()])
            }
            
            if printerStatus.unrecoverableError == sm_true {
                self.cellArray.addObject(["Non Recoverable Error", "Occurs", UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Non Recoverable Error", "Ready",  UIColor.blueColor()])
            }
            
            if printerStatus.cutterError == sm_true {
                self.cellArray.addObject(["Paper Cutter", "Error", UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Paper Cutter", "Ready", UIColor.blueColor()])
            }
            
            if printerStatus.headThermistorError == sm_true {
                self.cellArray.addObject(["Head Thermistor", "Error",  UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Head Thermistor", "Normal", UIColor.blueColor()])
            }
            
            if printerStatus.voltageError == sm_true {
                self.cellArray.addObject(["Voltage", "Error",  UIColor.redColor()])
            }
            else {
                self.cellArray.addObject(["Voltage", "Normal", UIColor.blueColor()])
            }
            
            if printerStatus.etbAvailable == sm_true {
                self.cellArray.addObject(["ETB Counter", String(format: "%d", printerStatus.etbCounter), UIColor.blueColor()])
            }
            
            result = true
            break
        }
        
        if result == false {
            let alertView: UIAlertView = UIAlertView.init(title: "Fail to Open Port", message: "", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
        
        self.tableView.reloadData()
    }
}
