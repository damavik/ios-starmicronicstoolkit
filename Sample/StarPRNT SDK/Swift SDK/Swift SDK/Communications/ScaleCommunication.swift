//
//  ScaleCommunication.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class RequestScaleStatusFunction: IStarIoExtFunction {
    var connect: Bool!
    
    override init() {
        super.init()
        
        let handler: StarIoExtFunctionCompletionHandler = { (buffer: inout [UInt8], length: inout UInt32) -> Bool in
            var index: Int = 0
            
            if length >= 5 {
                while length >= 5 {
                    if buffer[index]     == 0x1b &&
                       buffer[index + 1] == 0x1e &&
                       buffer[index + 2] == 0x42 &&
                       buffer[index + 3] == 0x51 {
                        length -= 5 - 1
                        
                        for i: Int in 0 ..< Int(length) {
                            buffer[i] = buffer[index + 5 - 1 + i]
                        }
                        
                        if (buffer[0] & 0x02) != 0x00 {
                            self.connect = true
                        }
                        else {
                            self.connect = false
                        }
                        
                        return true
                    }
                    
                    index += 1
                    
                    length -= 1
                }
                
                for i: Int in 0 ..< 5 - 1 {
                    buffer[i] = buffer[index + i]
                }
            }
            
            return false
        }
        
        completionHandler = handler
        
        connect = false
    }
    
    override func createCommands() -> NSData {
        let commands: NSMutableData = NSMutableData()
        
        let data: [UInt8] = [0x1b, 0x1e, 0x42, 0x51]
        
        commands.append(data, length: data.count)
        
        return commands as NSData
    }
}

class ScaleCommunication: Communication {
    static func requestStatus(_ port: SMPort!, completionHandler: RequestStatusCompletionHandler?) -> Bool {
        let function: RequestScaleStatusFunction = RequestScaleStatusFunction()
        
        return super.sendFunctionDoNotCheckCondition(function, port: port, completionHandler: { (result: Bool, title: String, message: String) in
            if completionHandler != nil {
                completionHandler!(result, title, message, function.connect)
            }
        })
    }
    
    static func passThroughCommands(_ commands: Data, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        let data: NSMutableData = NSMutableData()
        
        let l0: UInt8 = UInt8(commands.count % 0x0100)
        let l1: UInt8 = UInt8(commands.count / 0x0100)
        
        let header: [UInt8] = [0x1b, 0x1d, 0x42, 0x50, l0, l1]
        
        data.append(header, length: header.count)
        
        data.append(commands)
        
        return super.sendCommandsDoNotCheckCondition(data as Data!, port: port, completionHandler: completionHandler)
    }
    
    static func passThroughFunction(_ function: IStarIoExtFunction, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let data: NSMutableData = NSMutableData()
        
        let clearBuffer: [UInt8] = [0x1b, 0x1d, 0x42, 0x53]
        
        data.append(clearBuffer, length: clearBuffer.count)
        
        let command: Data = function.createCommands()! as Data
        
        let l0: UInt8 = UInt8(command.count % 0x0100)
        let l1: UInt8 = UInt8(command.count / 0x0100)
        
        let header: [UInt8] = [0x1b, 0x1d, 0x42, 0x50, l0, l1]
        
        data.append(header, length: header.count)
            
        data.append(command)
        
        var array: [UInt8] = [UInt8](repeating: 0, count: data.length)
        
        data.getBytes(&array, length: data.length)

        let startDate: Date = Date()
        
        while result == false {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            if Date().timeIntervalSince(startDate) >= 1.0 {     // 1000ms!!
                title   = "Printer Error"
                message = "Write port timed out"
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
            
            let startSendDateDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(data.length) {
                let writeLength: UInt32 = port.write(array, total, UInt32(data.length) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += writeLength
                
                if Date().timeIntervalSince(startSendDateDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(data.length) {
                break
            }
            
            while result == false {
                if Date().timeIntervalSince(startSendDateDate) >= 0.25 {     // 250mS!!!
                    title   = "Printer Error"
                    message = "Read port timed out"
                    break
                }
                
                Thread.sleep(forTimeInterval: 0.05)     // Break time.

                let requestData: [UInt8] = [0x1b, 0x1d, 0x42, 0x52]
                
                total = 0
                
                while total < UInt32(requestData.count) {
                    let writeLength: UInt32 = port.write(requestData, total, UInt32(requestData.count) - total, &error)
                    
                    if error != nil {
                        break
                    }
                    
                    total += writeLength
                    
                    if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                        title   = "Printer Error"
                        message = "Write port timed out"
                        break
                    }
                }
                
                if total < UInt32(requestData.count) {
                    break
                }
                
                var buffer: [UInt8] = [UInt8](repeating: 0, count: 1024 + 8)
                
                var length: UInt32 = 0
                
                total = 0
                
                while result == false {
                    Thread.sleep(forTimeInterval: 0.01)     // Break time.
                    
                    if Date().timeIntervalSince(startSendDateDate) >= 0.25 {     // 250mS!!!
                        title   = "Printer Error"
                        message = "Read port timed out"
                        break
                    }
                    
                    let readLength: UInt32 = port.read(&buffer, total, 1024 - total, &error)
                    
//                  NSLog("readPort:%d", readLength)
//
//                  for i: UInt32 in 0 ..< readLength {
//                      NSLog("%02x", buffer[Int(total + i)])
//                  }
                    
                    total += readLength
                    
                    var index: Int = 0
                    
                    if total >= 6 {
                        
                        var isResendRequest: Bool = false
                        
                        while total >= 6 {
                            if buffer[index]     == 0x1b &&
                               buffer[index + 1] == 0x1d &&
                               buffer[index + 2] == 0x42 &&
                               buffer[index + 3] == 0x52 {
                                length = UInt32(buffer[index + 4]) + UInt32(buffer[index + 5]) * 0x0100
                                
                                
                                if length == 0 {
                                    total -= 6
                                    
                                    for i: Int in 0 ..< Int(total) {
                                        buffer[i] = buffer[index + 6 + i]
                                    }
                                    
                                    isResendRequest = true;
                                }
                                else if length <= (total + 6) {
                                    total -= 6
                                    
                                    for i: Int in 0 ..< Int(total) {
                                        buffer[i] = buffer[index + 6 + i]
                                    }
                                    
                                    result = true
                                }

                                break
                            }
                            
                            index += 1
                            
                            total -= 1
                        }
                        
                        if isResendRequest == true {
                            break;
                        }
                    }
                }
                
                if result == true {
                    if function.completionHandler!(&buffer, &total) == true {
                        title   = "Send Commands"
                        message = "Success"
                    }
                }
            }
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
