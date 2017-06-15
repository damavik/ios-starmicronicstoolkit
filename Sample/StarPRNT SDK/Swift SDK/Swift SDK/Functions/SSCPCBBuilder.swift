//
//  SSCPCBBuilder.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class DisplayedWeightFunction: IStarIoExtDisplayedWeightFunction {
    override init() {
        super.init()
        
        let handler: StarIoExtFunctionCompletionHandler = { (buffer: inout [UInt8], length: inout UInt32) -> Bool in
            var index: Int = 0
            
            if length >= 20 {
                while length >= 20 {
                    if buffer[index]      == 0x0a &&
                       buffer[index + 19] == 0x0d {
                        if buffer[index + 1] == 0x5a {
                            self.status = StarIoExtDisplayedWeightStatus.zero
                        }
                        else if buffer[index + 4] == 0x4d {
                            self.status = StarIoExtDisplayedWeightStatus.motion
                        }
                        else {
                            self.status = StarIoExtDisplayedWeightStatus.notInMotion
                        }
                        
                        var _weight: String = ""
                        
                        for i: Int in 6 ..< 19 {
//                          if buffer[index + i] >= 0x20 && buffer[index + i] <= 0x7f {
                            if buffer[index + i] >= 0x21 && buffer[index + i] <= 0x7f {
                                let text: String = String(format: "%c", buffer[index + i])
                                
                                _weight += text
                            }
                        }
                        
                        self.weight = _weight
                        
                        return true
                    }
                    
                    index += 1
                    
                    length -= 1
                }
                
                for i: Int in 0 ..< 20 - 1 {
                    buffer[i] = buffer[index + i]
                }
            }
            
            return false
        }
        
        self.completionHandler = handler
        
        self.status = StarIoExtDisplayedWeightStatus.invalid
        self.weight = ""
    }
    
    override func createCommands() -> NSData {
        let commands: NSMutableData = NSMutableData()
        
        let data: [UInt8] = [0x0a, 0x57, 0x0d]
        
        commands.append(data, length: data.count)
        
        return commands as NSData
    }
}

class SSCPCBBuilder {
    let commands: NSMutableData
    
    static func createDisplayedWeightFunction() -> IStarIoExtDisplayedWeightFunction {
        return DisplayedWeightFunction()
    }
    
    static func createCommandBuilder() -> SSCPCBBuilder {
        return SSCPCBBuilder()
    }
    
    init() {
        self.commands = NSMutableData()
    }
    
    func appendZeroClear() {
        let data: [UInt8] = [0x0a, 0x5a, 0x0d]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendUnitChange() {
        let data: [UInt8] = [0x0a, 0x55, 0x0d]
        
        self.commands.append(data, length: data.count)
    }
}
