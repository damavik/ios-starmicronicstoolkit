//
//  ScaleFunctions.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class ScaleFunctions {
    static func createDisplayedWeightFunction() -> IStarIoExtDisplayedWeightFunction {
        return SSCPCBBuilder.createDisplayedWeightFunction()
    }
    
    static func createZeroClear() -> Data {
        let builder: SSCPCBBuilder = SSCPCBBuilder.createCommandBuilder()
        
        builder.appendZeroClear()
        
        return builder.commands.copy() as! Data
    }
    
    static func createUnitChange() -> Data {
        let builder: SSCPCBBuilder = SSCPCBBuilder.createCommandBuilder()
        
        builder.appendUnitChange()
        
        return builder.commands.copy() as! Data
    }
}
