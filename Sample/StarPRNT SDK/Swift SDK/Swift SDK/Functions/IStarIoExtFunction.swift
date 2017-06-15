//
//  IStarIoExtFunction.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

typealias StarIoExtFunctionCompletionHandler = (_ buffer: inout [UInt8], _ length: inout UInt32) -> Bool

class IStarIoExtFunction {
    var completionHandler: StarIoExtFunctionCompletionHandler?
    
    init() {
        self.completionHandler = nil
    }
    
    func createCommands() -> NSData? {
        return nil
    }
}
