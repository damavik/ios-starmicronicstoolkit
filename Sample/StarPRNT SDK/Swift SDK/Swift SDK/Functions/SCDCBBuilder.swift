//
//  SCDCBBuilder.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import UIKit

enum SCDCBInternationalType: Int {
    case usa          = 0x00
    case france       = 0x01
    case germany      = 0x02
    case uk           = 0x03
    case denmark      = 0x04
    case sweden       = 0x05
    case italy        = 0x06
    case spain        = 0x07
    case japan        = 0x08
    case norway       = 0x09
    case denmark2     = 0x0a
    case spain2       = 0x0b
    case latinAmerica = 0x0c
    case korea        = 0x0d
}

enum SCDCBCodePageType: Int {
    case cp437              = 0x00
    case katakana           = 0x01
    case cp850              = 0x02
    case cp860              = 0x03
    case cp863              = 0x04
    case cp865              = 0x05
    case cp1252             = 0x06
    case cp866              = 0x07
    case cp852              = 0x08
    case cp858              = 0x09
    case japanese           = 0x0a
    case simplifiedChinese  = 0x0b
    case traditionalChinese = 0x0c
    case hangul             = 0x0d
}

enum SCDCBCursorMode: Int {
    case off   = 0x00
    case blink = 0x01
    case on    = 0x02
}

enum SCDCBContrastMode: Int {
    case minus3  = 0x00
    case minus2  = 0x01
    case minus1  = 0x02
    case `default` = 0x03
    case plus1   = 0x04
    case plus2   = 0x05
    case plus3   = 0x06
}

class SCDCBBuilder {
    var commands: NSMutableData!
    
    static func createCommandBuilder() -> SCDCBBuilder {
        return SCDCBBuilder()
    }
    
    init() {
        self.commands = NSMutableData()
    }
    
    func appendByte(_ data: UInt8) {
        self.commands.append([data], length: 1)
    }
    
    func appendData(_ otherData: Data) {
        self.commands.append(otherData)
    }
    
    func appendBytes(_ bytes: [UInt8], length: Int) {
        self.commands.append(bytes, length: length)
    }
    
    func appendBackSpace() {
        let data: [UInt8] = [0x08]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendHorizontalTab() {
        let data: [UInt8] = [0x09]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendLineFeed() {
        let data: [UInt8] = [0x0a]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendCarriageReturn() {
        let data: [UInt8] = [0x0d]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendGraphic(_ image: [UInt8]) {
        let data: [UInt8] = [0x1b, 0x20]
        
        self.commands.append(data, length: data.count)
        
        self.commands.append(image, length: 5 * 160)
    }
    
    func appendCharacterSet(_ internationalType: SCDCBInternationalType, codePageType: SCDCBCodePageType) {
        let data: [UInt8] = [0x1b, 0x52, UInt8(internationalType.rawValue),
                             0x1b, 0x52, UInt8(codePageType     .rawValue + 0x30)]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendDeleteToEndOfLine() {
        let data: [UInt8] = [0x1b, 0x5b, 0x30, 0x4b]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendClearScreen() {
        let data: [UInt8] = [0x1b, 0x5b, 0x32, 0x4a]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendHomePosition() {
        let data: [UInt8] = [0x1b, 0x5b, 0x48, 0x27]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendTurnOn(_ turnOn: Bool) {
        let turnOnOff: UInt8
        
        if turnOn == true {
            turnOnOff = 0x01
        }
        else {
            turnOnOff = 0x00
        }
        
        let data: [UInt8] = [0x1b, 0x5b, turnOnOff, 0x50]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendSpecifiedPosition(_ x: Int, y: Int) {
        var workX: UInt8 = UInt8(x)
        var workY: UInt8 = UInt8(y)
        
        if !(x >= 1 && x <= 20) {
            workX = 1
        }
        
        if !(y >= 1 && y <= 2) {
            workY = 1
        }
        
        let data: [UInt8] = [0x1b, 0x5b, workY, 0x3b, workX, 0x48]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendCursorMode(_ cursorMode: SCDCBCursorMode) {
        let cursor: UInt8
        
        switch cursorMode {
        case SCDCBCursorMode.off   : cursor = 0x00
        case SCDCBCursorMode.blink : cursor = 0x01
        default                    : cursor = 0x02     // SCDCBCursorMode.on
        }
        
        let data: [UInt8] = [0x1b, 0x5c, 0x3f, 0x4c, 0x43, cursor]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendContrastMode(_ contrastMode: SCDCBContrastMode) {
        let data: [UInt8] = [0x1b, 0x5c, 0x3f, 0x4c, 0x44, UInt8(contrastMode.rawValue), 0x03]
        
        self.commands.append(data, length: data.count)
    }
    
    func appendUserDefinedCharacter(_ index: Int, code: Int, font: [UInt8]?) {
        let data: [UInt8] = [0x1b, 0x5c, 0x3f, 0x4c, 0x57, 0x01, 0x3b, UInt8(index), 0x3b, UInt8(code), 0x3b]
        
        self.commands.append(data, length: data.count)
        
        if code != 0x00 {
            self.commands.append(font!, length: 16)
        }
    }
    
    func appendUserDefinedDbcsCharacter(_ index: Int, code: Int, font: [UInt8]?) {
        let data: [UInt8] = [0x1b, 0x5c, 0x3f, 0x4c, 0x57, 0x02, 0x3b, UInt8(index), 0x3b, UInt8(code / 0x0100), UInt8(code % 0x0100), 0x3b]
        
        self.commands.append(data, length: data.count)
        
        if code != 0x00 {
            self.commands.append(font!, length: 32)
        }
    }
}
