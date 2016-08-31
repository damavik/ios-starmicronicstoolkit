//
//  StarIoExt.h
//  StarIO_Extension
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISCBBuilder.h"

typedef NS_ENUM(NSInteger, StarIoExtEmulation) {     // Don't insert!
    StarIoExtEmulationNone = 0,
    StarIoExtEmulationStarPRNT,
    StarIoExtEmulationStarLine,
    StarIoExtEmulationStarGraphic,
    StarIoExtEmulationEscPos,
    StarIoExtEmulationEscPosMobile,
    StarIoExtEmulationStarDotImpact
};

@interface StarIoExt : NSObject

// Generic.

+ (NSString *)description;

// Command Builder.

+ (ISCBBuilder *)createCommandBuilder:(StarIoExtEmulation)emulation;

@end
