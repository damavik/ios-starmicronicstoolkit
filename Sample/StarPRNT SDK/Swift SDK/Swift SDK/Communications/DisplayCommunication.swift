//
//  DisplayCommunication.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class RequestDisplayStatusFunction: IStarIoExtFunction {
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
                       buffer[index + 3] == 0x41 {
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
        
        self.completionHandler = handler
        
        self.connect = false
    }
    
    override func createCommands() -> NSData {
        let commands: NSMutableData = NSMutableData()
        
        let data: [UInt8] = [0x1b, 0x1e, 0x42, 0x41]
        
        commands.append(data, length: data.count)
        
        return commands as NSData
    }
}

class DisplayCommunication: Communication {
    static func requestStatus(_ port: SMPort!, completionHandler: RequestStatusCompletionHandler?) -> Bool {
        let function: RequestDisplayStatusFunction = RequestDisplayStatusFunction()
        
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
        
        let header: [UInt8] = [0x1b, 0x1d, 0x42, 0x40, l0, l1]
        
        data.append(header, length: header.count)
        
        data.append(commands)
        
        return super.sendCommandsDoNotCheckCondition(data as Data!, port: port, completionHandler: completionHandler)
    }
}
