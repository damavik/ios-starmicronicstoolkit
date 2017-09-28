//
//  ScaleFunctions.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleFunctions.h"

@implementation ScaleFunctions

+ (void)appendZeroClear:(ISSCBBuilder *)builder {
    [builder appendZeroClear];
}

+ (void)appendUnitChange:(ISSCBBuilder *)builder {
    [builder appendUnitChange];
}

@end
