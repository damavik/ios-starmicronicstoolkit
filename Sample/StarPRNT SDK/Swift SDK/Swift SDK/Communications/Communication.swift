//
//  Communication.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

typealias SendCompletionHandler = (_ result: Bool, _ title: String, _ message: String) -> Void

typealias SendCompletionHandlerWithNullableString = (_ result: Bool, _ title: String?, _ message: String?) -> Void

typealias RequestStatusCompletionHandler = (_ result: Bool, _ title: String, _ message: String, _ connect: Bool) -> Void

class Communication {
    static func sendCommands(_ commands: Data!, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.count)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &array, count: commands.count)
        
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
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.write(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
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
                message = "Printer is offline (EndCheckedBlock)"
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
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(_ commands: Data!, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.count)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &array, count: commands.count)
        
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
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.write(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
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
//              message = "Printer is offline (GetParsedStatus)"
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
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendFunctionDoNotCheckCondition(_ function: IStarIoExtFunction, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let commands: Data = function.createCommands()! as Data
        
        var length: UInt32 = UInt32(commands.count)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        (commands as NSData).getBytes(&array, length: commands.count)
        
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
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            var startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.write(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < length {
                break
            }
            
            var buffer: [UInt8] = [UInt8](repeating: 0, count: 1024 + 8)
            
            length = 1024
            
            Thread.sleep(forTimeInterval: 0.1)     // Break time.
            
            startDate = Date()
            
            var amount: UInt32 = 0
            
            while true {
                if Date().timeIntervalSince(startDate) >= 1.0 {     // 1000mS!!!
                    title   = "Printer Error"
                    message = "Read port timed out"
                    break
                }
                
                let readLength: UInt32 = port.read(&buffer, amount, length - amount, &error)
                
//              NSLog("readPort:%d", readLength)
//
//              for i: UInt32 in 0 ..< readLength {
//                  NSLog("%02x", buffer[Int(amount + i)])
//              }
                
                amount += readLength
                
                if function.completionHandler!(&buffer, &amount) == true {
                    length = UInt32(amount)
                    
                    title   = "Send Commands"
                    message = "Success"
                    
                    result = true
                    break
                }
            }
            
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommands(_ commands: Data!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.count)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &array, count: commands.count)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
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
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.write(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
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
                message = "Printer is offline (EndCheckedBlock)"
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
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(_ commands: Data!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let length: UInt32 = UInt32(commands.count)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &array, count: commands.count)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < length {
                let written: UInt32 = port.write(array, total, length - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
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
//              message = "Printer is offline (GetParsedStatus)"
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
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func connectBluetooth(_ completionHandler: SendCompletionHandlerWithNullableString?) {
        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil) { (error) -> Void in
            var result: Bool = false
            
            var title:   String? = ""
            var message: String? = ""
            
            if let error = error as NSError? {
                NSLog("Error:%@", error.description)
                
                switch error.code {
                case EABluetoothAccessoryPickerError.alreadyConnected.rawValue :
                    title   = "Success"
                    message = ""
                    
                    result = true
                case EABluetoothAccessoryPickerError.resultCancelled.rawValue,
                     EABluetoothAccessoryPickerError.resultFailed.rawValue :
                    title   = nil
                    message = nil
                    
                    result = false
//              case EABluetoothAccessoryPickerErrorCode.ResultNotFound :
                default                                                 :
                    title   = "Fail to Connect"
                    message = ""
                    
                    result = false
                }
            }
            else {
                title = "Success"
                message = ""
                
                result = true
            }
            
            if completionHandler != nil {
                completionHandler!(result, title, message)
            }
        }
    }
    
    static func disconnectBluetooth(_ modelName: String!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        while true {
            guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            if modelName.hasPrefix("TSP143IIIBI") == true {
                let array: [UInt8] = [0x1b, 0x1c, 0x26, 0x49]     // Only TSP143IIIBI
                
                let length: UInt32 = UInt32(array.count)
                
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
                
                let startDate: Date = Date()
                
                var total: UInt32 = 0
                
                while total < length {
                    let written: UInt32 = port.write(array, total, length - total, &error)
                    
                    if error != nil {
                        break
                    }
                    
                    total += written
                    
                    if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                        title   = "Printer Error"
                        message = "Write port timed out"
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
//                  title   = "Printer Error"
//                  message = "Printer is offline (EndCheckedBlock)"
//                  break
//              }
            }
            else {
                if port.disconnect() == false {
                    title   = "Fail to Disconnect"
                    message = "Note. Portable Printers is not supported."
                    break
                }
            }
            
            title   = "Success"
            message = ""
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
}
