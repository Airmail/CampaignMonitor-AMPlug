//
//  APIProtocol.h
//  CampaignMonitor
//
//  Created by Dean Thomas on 24/11/2014.
//  Copyright (c) 2014 SpikedSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIProtocol

-(void)finishedCallFor: (NSString *)method withData: (NSDictionary*)dict;

@end
