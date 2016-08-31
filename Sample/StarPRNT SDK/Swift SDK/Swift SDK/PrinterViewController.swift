//
//  PrinterViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import UIKit

class CustomUIImagePickerController: UIImagePickerController {
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if AppDelegate.isIPad() {
            return UIInterfaceOrientationMask.All
        }
        
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}

class PrinterViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 2 {
            return 7
        }
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleValue1"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            if indexPath.section != 2 {
                let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(AppDelegate.getSelectedLanguage(), paperSizeIndex: AppDelegate.getSelectedPaperSize())
                
                switch indexPath.row {
                case 0 :
                    cell.textLabel!.text = String(format: "%@ %@ Text Receipt",                localizeReceipts.languageCode, localizeReceipts.paperSize)
                case 1 :
                    cell.textLabel!.text = String(format: "%@ %@ Text Receipt (UTF8)",         localizeReceipts.languageCode, localizeReceipts.paperSize)
                case 2 :
                    cell.textLabel!.text = String(format: "%@ %@ Raster Receipt",              localizeReceipts.languageCode, localizeReceipts.paperSize)
                case 3 :
                    cell.textLabel!.text = String(format: "%@ %@ Raster Receipt (Both Scale)", localizeReceipts.languageCode, localizeReceipts.scalePaperSize)
                case 4 :
                    cell.textLabel!.text = String(format: "%@ %@ Raster Receipt (Scale)",      localizeReceipts.languageCode, localizeReceipts.scalePaperSize)
                case 5 :
                    cell.textLabel!.text = String(format: "%@ Raster Coupon",                  localizeReceipts.languageCode)
//              case 6  :
                default :
                    cell.textLabel!.text = String(format: "%@ Raster Coupon (Rotation90)",     localizeReceipts.languageCode)
                }
                
                cell.detailTextLabel!.text = ""
                
                cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                
//              cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                var userInteractionEnabled: Bool = true
                
                let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
                
                if emulation == StarIoExtEmulation.StarGraphic {
                    if indexPath.row == 0 ||     // Text Receipt
                       indexPath.row == 1 {     // Text Receipt (UTF8)
                        userInteractionEnabled = false
                    }
                }
                
                if emulation == StarIoExtEmulation.EscPos ||
                   emulation == StarIoExtEmulation.EscPosMobile {
                    if indexPath.row == 1 {     // Text Receipt (UTF8)
                        userInteractionEnabled = false
                    }
                }
                
                if emulation == StarIoExtEmulation.StarDotImpact {
                    if indexPath.row == 2 ||     // Raster Receipt
                       indexPath.row == 3 ||     // Raster Receipt (Both Scale)
                       indexPath.row == 4 {      // Raster Receipt (Scale)
                        userInteractionEnabled = false
                    }
                }
                
                if userInteractionEnabled == true {
                    cell      .textLabel!.alpha = 1.0
                    cell.detailTextLabel!.alpha = 1.0
                    
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    
                    cell.userInteractionEnabled = true
                }
                else {
                    cell      .textLabel!.alpha = 0.3
                    cell.detailTextLabel!.alpha = 0.3
                    
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    
                    cell.userInteractionEnabled = false
                }
            }
            else {
                if (indexPath.row == 0) {
                    cell.textLabel!.text = "Print Photo from Library"
                }
                else {
                    cell.textLabel!.text = "Print Photo by Camera"
                }
                
                cell.detailTextLabel!.text = ""
                
                cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                
//              cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                var userInteractionEnabled: Bool = true
                
                let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
                
                if emulation == StarIoExtEmulation.StarDotImpact {
                    userInteractionEnabled = false
                }
                
                if userInteractionEnabled == true {
                    cell      .textLabel!.alpha = 1.0
                    cell.detailTextLabel!.alpha = 1.0
                    
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    
                    cell.userInteractionEnabled = true
                }
                else {
                    cell      .textLabel!.alpha = 0.3
                    cell.detailTextLabel!.alpha = 0.3
                    
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    
                    cell.userInteractionEnabled = false
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String
        
        if section == 0 {
            title = "Like a StarIO-SDK Sample"
        }
        else if section == 1 {
            title = "StarIoExtManager Sample"
        }
        else {
            title = "Appendix"
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            let commands: NSData
            
            let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
            
            let width: Int = AppDelegate.getSelectedPaperSize().rawValue
            
            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(AppDelegate.getSelectedLanguage(), paperSizeIndex: AppDelegate.getSelectedPaperSize())
            
            switch indexPath.row {
            case 0 :
                commands = PrinterFunctions.createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: false)
            case 1 :
                commands = PrinterFunctions.createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: true)
            case 2 :
                commands = PrinterFunctions.createRasterReceiptData(emulation, localizeReceipts: localizeReceipts)
            case 3 :
                commands = PrinterFunctions.createScaleRasterReceiptData(emulation, localizeReceipts: localizeReceipts, width: width, bothScale: true)
            case 4 :
                commands = PrinterFunctions.createScaleRasterReceiptData(emulation, localizeReceipts: localizeReceipts, width: width, bothScale: false)
            case 5 :
                commands = PrinterFunctions.createCouponData(emulation, localizeReceipts: localizeReceipts, width: width, rotation: SCBBitmapConverterRotation.Normal)
//          case 6  :
            default :
                commands = PrinterFunctions.createCouponData(emulation, localizeReceipts: localizeReceipts, width: width, rotation: SCBBitmapConverterRotation.Right90)
            }
            
            self.blind = true
            
            defer {
                self.blind = false
            }
            
            Communication.sendCommands(commands, portName: AppDelegate.getPortName(), portSettings: AppDelegate.getPortSettings(), timeout: 10000)     // 10000mS!!!
        }
        else if indexPath.section == 1 {
            AppDelegate.setSelectedIndex(indexPath.row)
            
            self.performSegueWithIdentifier("PushPrinterExtViewController", sender: nil)
        }
        else {
            if (indexPath.row == 0) {
//              let imagePickerController:       UIImagePickerController =       UIImagePickerController()
                let imagePickerController: CustomUIImagePickerController = CustomUIImagePickerController()
                
                imagePickerController.sourceType    = UIImagePickerControllerSourceType.PhotoLibrary
                imagePickerController.allowsEditing = false
                imagePickerController.delegate      = self
                
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
            else {
                let imagePickerController: UIImagePickerController = UIImagePickerController()
                
                imagePickerController.sourceType    = UIImagePickerControllerSourceType.Camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate      = self
                
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//      let image: UIImage = info[UIImagePickerControllerEditedImage]   as! UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let commands: NSData
        
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(AppDelegate.getEmulation())
        
        builder.beginDocument()
        
        builder.appendBitmap(image, diffusion: true, width: AppDelegate.getSelectedPaperSize().rawValue, bothScale: true)
        
        builder.appendCutPaper(SCBCutPaperAction.PartialCutWithFeed)
        
        builder.endDocument()
        
        commands = builder.commands.copy() as! NSData
        
        self.blind = true
        
        defer {
            self.blind = false
        }
        
        Communication.sendCommands(commands, portName: AppDelegate.getPortName(), portSettings: AppDelegate.getPortSettings(), timeout: 10000)     // 10000mS!!!
    }
}
