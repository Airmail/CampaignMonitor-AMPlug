//
//  APIHelper.m
//  CampaignMonitor
//
//  Created by Dean Thomas on 24/11/2014.
//  Copyright (c) 2014 SpikedSoftware. All rights reserved.
//

#import "APIHelperCM.h"
#import "APIProtocol.h"
@import AppKit;

static NSOperationQueue *operationQueue = nil;


@implementation APIHelperCM

+(NSOperationQueue *)operationQueue
{
    if (operationQueue == nil)
    {
        operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return operationQueue;
}

+(void)getClientsWithAPIKey:(NSString *)apiKey andDelegate:(id)delegate
{
    NSString *apiUrl = @"https://api.createsend.com/api/v3.1/clients.json";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", apiKey, @"nopassreqiured"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [delegate finishedCallFor:@"GetClients" withData:dict];
    }];
}

+(void)getCampaignsForClientId:(NSString *)clientId withAPIKey:(NSString *)apiKey andDelegate:(id)delegate
{
    NSString *apiUrl = [NSString stringWithFormat:@"https://api.createsend.com/api/v3.1/clients/%@/lists.json", clientId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", apiKey, @"nopassreqiured"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [delegate finishedCallFor:@"GetCampaigns" withData:dict];
    }];
}

+(void)subscribeEmail:(NSString *)email toList:(NSString *)listId withAPIKey:(NSString *)apiKey andDelegate:(id)delegate
{
    NSString *apiUrl = [NSString stringWithFormat:@"https://api.createsend.com/api/v3.1/subscribers/%@.json", listId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", apiKey, @"nopassreqiured"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //Body
    NSDictionary *dict = @{ @"EmailAddress": email, @"Resubscribe": @"true" };
    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [request setHTTPBody:payloadData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //They don't return any JSON, annoyingly they just return the email address... very strange.
        NSDictionary *dict = @{ @"response": [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] };
        [delegate finishedCallFor:@"SubscribeEmail" withData:dict];
    }];
}

+(void)batchSubscribeEmail:(NSArray *)emails toList:(NSString *)listId withAPIKey:(NSString *)apiKey andDelegate:(id)delegate
{
    NSString *apiUrl = [NSString stringWithFormat:@"https://api.createsend.com/api/v3.1/subscribers/%@/import.json", listId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", apiKey, @"nopassreqiured"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
   
    NSMutableArray *emailsPayload = [NSMutableArray new];
    for (int e = 0; e < emails.count; e ++)
        [emailsPayload addObject:@{ @"EmailAddress": [emails objectAtIndex:e] }];
    NSDictionary *payload = @{ @"Subscribers": emailsPayload, @"Resubscribe": @"true" };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [delegate finishedCallFor:@"Batch Subscibe Email" withData:dict];
    }];
}

@end
