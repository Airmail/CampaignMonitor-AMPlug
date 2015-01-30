//
//  APIHelper.h
//  CampaignMonitor
//
//  Created by Dean Thomas on 24/11/2014.
//  Copyright (c) 2014 SpikedSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHelperCM : NSObject

+(void)getClientsWithAPIKey: (NSString *)apiKey andDelegate: (id)delegate;
+(void)getCampaignsForClientId: (NSString *)clientId withAPIKey: (NSString *)apiKey andDelegate: (id)delegate;
+(void)subscribeEmail: (NSString *)email toList: (NSString *)listId withAPIKey: (NSString *)apiKey andDelegate: (id)delegate;
+(void)batchSubscribeEmail:(NSArray *)emails toList: (NSString *)listId withAPIKey:(NSString *)apiKey andDelegate:(id)delegate;

@end
