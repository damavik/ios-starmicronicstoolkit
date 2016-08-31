//
//  Communication.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

class Communication {
    static func sendCommands(commands: NSData!, port: SMPort!) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.length)
        
        var array: [UInt8] = [UInt8](count: commands.length, repeatedValue: 0)
        
        commands.getBytes(&array, length: commands.length)
        
        while true {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.beginCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (BeginCheckedBlock)"
                break
            }
            
            let startDate: NSDate = NSDate()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.writePort(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if NSDate().timeIntervalSinceDate(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < length {
                break
            }
            
            port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
            
            port.endCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (endCheckedBlock)"
                break
            }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(commands: NSData!, port: SMPort!) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.length)
        
        var array: [UInt8] = [UInt8](count: commands.length, repeatedValue: 0)
        
        commands.getBytes(&array, length: commands.length)
        
        while true {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (getParsedStatus)"
//              break
//          }
            
            let startDate: NSDate = NSDate()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.writePort(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if NSDate().timeIntervalSinceDate(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < length {
                break
            }
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (getParsedStatus)"
//              break
//          }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            
            alertView.show()
        }
        
        return result
    }
    
    static func sendCommands(commands: NSData!, portName: String!, portSettings: String!, timeout: UInt32) -> Bool! {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.length)
        
        var array: [UInt8] = [UInt8](count: commands.length, repeatedValue: 0)
        
        commands.getBytes(&array, length: commands.length)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.releasePort(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.beginCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (BeginCheckedBlock)"
                break
            }
            
            let startDate: NSDate = NSDate()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.writePort(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if NSDate().timeIntervalSinceDate(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < length {
                break
            }
            
            port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
            
            port.endCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (endCheckedBlock)"
                break
            }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(commands: NSData!, portName: String!, portSettings: String!, timeout: UInt32) -> Bool! {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.length)
        
        var array: [UInt8] = [UInt8](count: commands.length, repeatedValue: 0)
        
        commands.getBytes(&array, length: commands.length)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
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
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (getParsedStatus)"
//              break
//          }
            
            let startDate: NSDate = NSDate()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.writePort(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if NSDate().timeIntervalSinceDate(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < length {
                break
            }
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (getParsedStatus)"
//              break
//          }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
        }
        
        return result
    }

    static func connectBluetooth() {
        EAAccessoryManager.sharedAccessoryManager().showBluetoothAccessoryPickerWithNameFilter(nil) { (error) -> Void in
            var result: Bool
            var show:   Bool
            
            if error != nil {
                NSLog("Error:%@", error!.description)
                
                switch error!.code {
                case EABluetoothAccessoryPickerErrorCode.AlreadyConnected.rawValue :
                    result = true
                    show   = true
                case EABluetoothAccessoryPickerErrorCode.ResultCancelled.rawValue,
                     EABluetoothAccessoryPickerErrorCode.ResultFailed   .rawValue :
                    result = false
                    show   = false
//              case EABluetoothAccessoryPickerErrorCode.ResultNotFound :
                default                                                 :
                    result = false
                    show   = true
                }
            }
            else {
                result = true
                show   = true
            }
            
            if show == true {
                dispatch_async(dispatch_get_main_queue()) {
                    var alertView: UIAlertView
                    
                    if result == true {
                        alertView = UIAlertView(title: "Success", message: nil, delegate: nil, cancelButtonTitle: "OK")
                    }
                    else {
                        alertView = UIAlertView(title: "Fail to Connect", message: nil, delegate: nil, cancelButtonTitle: "OK")
                    }
                    
                    alertView.show()
                }
            }
        }
    }
    
    static func disconnectBluetooth(modelName: String!, portName: String!, portSettings: String!, timeout: UInt32) -> Bool! {
        var result: Bool = false
        
        while true {
            guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                break
            }
            
            defer {
                SMPort.releasePort(port)
            }
            
            if modelName.hasPrefix("TSP143IIIBI") == true {
                var error: NSError?
                
                let array: [UInt8] = [0x1b, 0x1c, 0x26, 0x49]     // Only TSP143IIIBI
                
                let length: UInt32 = UInt32(array.count)
                
                var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
                
                port.beginCheckedBlock(&printerStatus, 2, &error)
                
                if error != nil {
                    break
                }
                
                if printerStatus.offline == sm_true {
                    break
                }
                
                let startDate: NSDate = NSDate()
                
                var total: UInt32 = 0
                
                while total < length {
                    let written: UInt32 = port.writePort(array, total, length - total, &error)
                    
                    if error != nil {
                        break
                    }
                    
                    total += written
                    
                    if NSDate().timeIntervalSinceDate(startDate) >= 30.0 {     // 30000mS!!!
                        break
                    }
                }
                
                if total < length {
                    break
                }
                
//              port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
//
//              port.endCheckedBlock(&printerStatus, 2, &error)
//
//              if error != nil {
//                  break
//              }
//
//              if printerStatus.offline == sm_true {
//                  break
//              }
            }
            else {
                if port.disconnect() == false {
                    break
                }
            }
            
            result = true
            break
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView: UIAlertView
            
            if result == true {
                alertView = UIAlertView(title: "Success", message: nil, delegate: nil, cancelButtonTitle: "OK")
            }
            else {
                alertView = UIAlertView(title: "Fail to Disconnect", message: "Note. Portable Printers is not supported.", delegate: nil, cancelButtonTitle: "OK")
            }
            
            alertView.show()
        }
        
        return result
    }
}
