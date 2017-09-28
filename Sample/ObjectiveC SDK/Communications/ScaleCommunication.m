//
//  ScaleCommunication.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleCommunication.h"

@implementation ScaleCommunication

+ (BOOL)parseDoNotCheckCondition:(ISCPParser *)parser
                            port:(SMPort *)port
               completionHandler:(SendCompletionHandler)completionHandler {
    BOOL result = NO;
    
    NSString *title   = @"";
    NSString *message = @"";
    
    NSData *sendCommands    = [parser createSendCommands];
    NSData *receiveCommands = [parser createReceiveCommands];
    
    @try {
        while (YES) {
            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }
            
            StarPrinterStatus_2 printerStatus;
            
            [port getParsedStatus:&printerStatus :2];
            
//          if (printerStatus.offline == SM_TRUE) {     // Do not check condition.
//              title   = @"Printer Error";
//              message = @"Printer is offline (GetParsedStatus)";
//              break;
//          }
            
            NSDate *startDate = [NSDate date];
            
            while (result == NO) {
                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 1.0) {       // 1000ms!!
                    title   = @"Printer Error";
                    message = @"Read port timed out";
                    break;
                }
                
                uint32_t total = 0;
                
                while (total < (uint32_t) sendCommands.length) {
                    uint32_t written = [port writePort:sendCommands.bytes :total :(uint32_t) sendCommands.length - total];
                    
                    total += written;
                    
                    if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                        title   = @"Printer Error";
                        message = @"Write port timed out";
                        break;
                    }
                }
                
                if (total < (uint32_t) sendCommands.length) {
                    break;
                }
                
                NSDate *innerStartDate = [NSDate date];
                
                while (result == NO) {
//                  if ([[NSDate date] timeIntervalSinceDate:innerStartDate] >= 1.0)  {     // 1000mS!!!
                    if ([[NSDate date] timeIntervalSinceDate:innerStartDate] >= 0.25) {     //  250mS!!!
//                      title   = @"Printer Error";
//                      message = @"Read port timed out";
                        break;
                    }
                    
                    total = 0;
                    
                    while (total < (uint32_t) receiveCommands.length) {
                        uint32_t written = [port writePort:receiveCommands.bytes :total :(uint32_t) receiveCommands.length - total];
                        
                        total += written;
                        
                        if ([[NSDate date] timeIntervalSinceDate:innerStartDate] >= 30.0) {     // 30000mS!!!
                            title   = @"Printer Error";
                            message = @"Write port timed out";
                            break;
                        }
                    }
                    
                    if (total < (uint32_t) receiveCommands.length) {
                        break;
                    }
                    
                    uint8_t buffer[1024 + 8];
                    
                    int amount = 0;
                    
                    StarIoExtParserCompletionResult completionResult = StarIoExtParserCompletionResultInvalid;
                    
                    while (completionResult == StarIoExtParserCompletionResultInvalid) {
//                      if ([[NSDate date] timeIntervalSinceDate:innerStartDate] >= 1.0)  {     // 1000mS!!!
                        if ([[NSDate date] timeIntervalSinceDate:innerStartDate] >= 0.25) {     //  250mS!!!
//                          title   = @"Printer Error";
//                          message = @"Read port timed out";
                            break;
                        }
                        
                        [NSThread sleepForTimeInterval:0.01];     // Break time.
                        
                        int readLength = [port readPort:buffer :amount :1024 - amount];
                        
//                      NSLog(@"readPort:%d", readLength);
//
//                      for (int i = 0; i < readLength; i++) {
//                          NSLog(@"%02x", buffer[amount + i]);
//                      }
                        
                        amount += readLength;
                        
                        completionResult = parser.completionHandler(buffer, &amount);
                        
                        if (completionResult == StarIoExtParserCompletionResultSuccess) {
                            title   = @"Send Commands";
                            message = @"Success";
                            
                            result = YES;
                        }
                    }
                }
            }
            
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }
    
    if (completionHandler != nil) {
        completionHandler(result, title, message);
    }
    
    return result;
}

@end
