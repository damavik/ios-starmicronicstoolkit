//
//  IStarIoExtDisplayedWeightFunction.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

enum StarIoExtDisplayedWeightStatus: Int {
    case invalid = 0
    case zero
    case notInMotion
    case motion
}

class IStarIoExtDisplayedWeightFunction: IStarIoExtFunction {
    var status: StarIoExtDisplayedWeightStatus!
    
    var weight: String!
    
    override init() {
        super.init()
        
        self.completionHandler = nil
        
        self.status = StarIoExtDisplayedWeightStatus.invalid
        
        self.weight = ""
    }
    
    override func createCommands() -> NSData? {
        return nil
    }
}
