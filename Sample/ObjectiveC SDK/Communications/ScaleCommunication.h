//
//  ScaleCommunication.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "Communication.h"

@interface ScaleCommunication : Communication

+ (BOOL)parseDoNotCheckCondition:(ISCPParser *)parser
                            port:(SMPort *)port
               completionHandler:(SendCompletionHandler)completionHandler;

@end
