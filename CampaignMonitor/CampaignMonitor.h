//
//  CampaignMonitor.h
//  CampaignMonitor
//
//  Created by Dean Thomas on 24/11/2014.
//  Copyright (c) 2014 SpikedSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>
#import "APIProtocol.h"

@interface CampaignMonitor : AMPlugin<APIProtocol>

-(void)setAPIKey: (NSString *)apiKey;
-(NSString *)getAPIKey;

-(void)setClientList: (NSArray *)clientList;
-(NSArray *)getClientList;

-(void)setDefaultClientId: (NSString *)clientId;
-(NSString *)getDefaultClientId;

-(void)setCampaignList: (NSArray *)campaignList;
-(NSArray *)getCampaignList;

-(void)setDefaultCampaignId: (NSString *)campaignId;
-(NSString *)getDefaultCampaignId;

@end
