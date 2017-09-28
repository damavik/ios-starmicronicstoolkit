//
//  ScaleFunctions.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StarIO_Extension/StarIoExt.h>

@interface ScaleFunctions : NSObject

+ (void)appendZeroClear:(ISSCBBuilder *)builder;

+ (void)appendUnitChange:(ISSCBBuilder *)builder;

@end
