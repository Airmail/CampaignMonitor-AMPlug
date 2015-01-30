//
//  CampaignMonitorConfigView.m
//  CampaignMonitor
//
//  Created by Dean Thomas on 24/11/2014.
//  Copyright (c) 2014 SpikedSoftware. All rights reserved.
//

#import "CampaignMonitorConfigView.h"
#import "CampaignMonitor.h"
#import "APIHelperCM.h"

@interface CampaignMonitorConfigView ()

@property (strong, nonatomic) NSTextField *apiKey;
@property (strong, nonatomic) NSPopUpButton *clientListPopup;
@property (strong, nonatomic) NSPopUpButton *campaignListPopup;
@property (strong, nonatomic) NSArray *clientsAvailableList;
@property (strong, nonatomic) NSArray *campaignsAvailableList;

@end


@implementation CampaignMonitorConfigView


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self)
    {
        [self LoadView];
    }
    return self;
}

- (CampaignMonitor*) myPlugin
{
    return (CampaignMonitor*)self.plugin;
}

- (void) ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self LoadView];
    });
}

- (void) LoadView
{
    float x = 0, y = 0;
    
    NSTextView *apiKeyLabel = [[NSTextView alloc] initWithFrame:CGRectMake(x, y, 75.0f, 17.0f)];
    [apiKeyLabel setString:@"API Key"];
    [apiKeyLabel setEditable:false];
    [apiKeyLabel setSelectable:false];
    [apiKeyLabel setDrawsBackground:false];
    y += apiKeyLabel.frame.size.height + 5.0f;
    
    self.apiKey = [[NSTextField alloc] initWithFrame:CGRectMake(x, y, 230.0f, 22.0f)];
    [self.apiKey setEditable: YES];
    [self.apiKey setPlaceholderString:@"API Key from your account"];
    
    NSString *apiKey = [[self myPlugin] getAPIKey];
    if (apiKey != nil)
        [self.apiKey setStringValue:apiKey];
    
    x += self.apiKey.frame.size.width + 5.0f;
    
    NSButton *apiKeyTest = [[NSButton alloc] initWithFrame:CGRectMake(x, y, 120.0f, 25.0f)];
    [apiKeyTest setTitle:@"Update Clients"];
    [apiKeyTest setButtonType:NSMomentaryPushInButton];
    [apiKeyTest setBezelStyle:NSRoundedBezelStyle];
    [apiKeyTest setTarget:self];
    [apiKeyTest setAction:@selector(refreshClients_clicked)];
    
    x = 0;
    y += apiKeyTest.frame.size.height + 5.0f;
    
    NSTextView *clientListLabel = [[NSTextView alloc] initWithFrame:CGRectMake(x, y, 75.0f, 17.0f)];
    [clientListLabel setString:@"Clients"];
    [clientListLabel setEditable:false];
    [clientListLabel setSelectable:false];
    [clientListLabel setDrawsBackground:false];
    
    x = 0;
    y += clientListLabel.frame.size.height + 5.0f;
    
    self.clientListPopup = [[NSPopUpButton alloc] initWithFrame:CGRectMake(0, y, 220.0f, 25.0f) pullsDown:false];
    [self.clientListPopup setTarget:self];
    [self.clientListPopup setAction:@selector(clientList_popupAction:)];
    [self.clientListPopup removeAllItems];
    [self.clientListPopup addItemWithTitle:@"Select One..."];
    
    NSArray *existingClients = [[self myPlugin] getClientList];
    NSString *selectedClient = [[self myPlugin] getDefaultClientId];
    for (int i = 0; i < existingClients.count; i ++)
    {
        NSString *name = [[existingClients objectAtIndex:i] objectForKey:@"Name"];
        NSString *itemId = [[existingClients objectAtIndex:i] objectForKey:@"ClientID"];
        [self.clientListPopup addItemWithTitle:name];
        
        //Do we have a selected item
        if (selectedClient != nil)
            if ([itemId isEqualTo:selectedClient])
                [self.clientListPopup selectItemAtIndex:(i+1)];
    }
    
    x = 0;
    y += self.clientListPopup.frame.size.height + 5.0f;
    
    NSTextView *campaignListLabel = [[NSTextView alloc] initWithFrame:CGRectMake(x, y, 150.0f, 17.0f)];
    [campaignListLabel setString:@"Default Campaign"];
    [campaignListLabel setEditable:false];
    [campaignListLabel setSelectable:false];
    [campaignListLabel setDrawsBackground:false];
    
    x = 0;
    y += campaignListLabel.frame.size.height + 5.0f;
    
    //Campaigns
    self.campaignListPopup = [[NSPopUpButton alloc] initWithFrame:CGRectMake(0, y, 220.0f, 25.0f) pullsDown:false];
    [self.campaignListPopup setTarget:self];
    [self.campaignListPopup setAction:@selector(campaignList_popupAction:)];
    [self.campaignListPopup removeAllItems];
    [self.campaignListPopup addItemWithTitle:@"Select One..."];
    
    NSArray *existingCampaigns = [[self myPlugin] getCampaignList];
    NSString *selectedCampaign = [[self myPlugin] getDefaultCampaignId];
    for (int i = 0; i < existingCampaigns.count; i ++)
    {
        NSString *name = [[existingCampaigns objectAtIndex:i] objectForKey:@"Name"];
        NSString *itemId = [[existingCampaigns objectAtIndex:i] objectForKey:@"ListID"];
        [self.campaignListPopup addItemWithTitle:name];
        
        //Do we have a selected item
        if (selectedCampaign != nil)
            if ([itemId isEqualTo:selectedCampaign])
                [self.campaignListPopup selectItemAtIndex:(i+1)];
    }
    
    x = 0;
    y += self.campaignListPopup.frame.size.height + 25.0f;
    
    NSButton *saveButton = [[NSButton alloc] initWithFrame:CGRectMake(0, y, 120.0f, 25.0f)];
    [saveButton setTitle:@"Save Changes"];
    [saveButton setButtonType:NSMomentaryPushInButton];
    [saveButton setBezelStyle:NSRoundedBezelStyle];
    [saveButton setTarget:self];
    [saveButton setAction:@selector(saveChangesAction:)];
    
    [self addSubview:apiKeyLabel];
    [self addSubview:self.apiKey];
    [self addSubview:apiKeyTest];
    [self addSubview:clientListLabel];
    [self addSubview:self.clientListPopup];
    [self addSubview:campaignListLabel];
    [self addSubview:self.campaignListPopup];
    [self addSubview:saveButton];
    
}

-(void)refreshClients_clicked
{
    NSString *apiKey = self.apiKey.stringValue;
    if (apiKey.length == 32)
        [APIHelperCM getClientsWithAPIKey:apiKey andDelegate:self];
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"API Key not quite correct. Should be 32 characters."];
        [alert runModal];
    }
    
    return;
}

-(void)clientList_popupAction:(id)sender
{
    if (self.clientListPopup.indexOfSelectedItem > 0)
    {
        NSUInteger selectedClientIndex = self.clientListPopup.indexOfSelectedItem - 1;
        NSString *clientId = [[self.clientsAvailableList objectAtIndex:selectedClientIndex] objectForKey:@"ClientID"];

        NSString *apiKey = self.apiKey.stringValue;
        [APIHelperCM getCampaignsForClientId:clientId withAPIKey:apiKey andDelegate:self];
    }
}

-(void)campaignList_popupAction:(id)sender
{
    
}

-(void)finishedCallFor:(NSString *)method withData:(NSDictionary *)dict
{
    if ([method isEqualToString:@"GetClients"])
    {
        //Run through all of the 'items' found, and bind them to the list
        [self.clientListPopup removeAllItems];
        [self.clientListPopup addItemWithTitle:@"Select One..."];
        
        NSArray *items = (NSArray *)dict;
        for (int i = 0; i < items.count; i ++)
        {
            NSString *name = [[items objectAtIndex:i] objectForKey:@"Name"];
            [self.clientListPopup addItemWithTitle:name];
        }
        
        //Now we know we have the items, lets store them...
        self.clientsAvailableList = items;
        [[self myPlugin] setClientList:items];
    }
    else if ([method isEqualToString:@"GetCampaigns"])
    {
        //Run through all of the 'items' found, and bind them to the list
        [self.campaignListPopup removeAllItems];
        [self.campaignListPopup addItemWithTitle:@"Select One..."];
        
        NSArray *items = (NSArray *)dict;
        for (int i = 0; i < items.count; i ++)
        {
            NSString *name = [[items objectAtIndex:i] objectForKey:@"Name"];
            [self.campaignListPopup addItemWithTitle:name];
        }
        
        //Now we know we have the items, lets store them...
        self.campaignsAvailableList = items;
        [[self myPlugin] setCampaignList:items];
    }
}


-(void)saveChangesAction: (id)sender
{
    //Get the Selected List and the API Key, then save them
    CampaignMonitor *plugin = (CampaignMonitor *)[self plugin];
    NSString *message;
    BOOL shouldSave = YES;
    
    //Save the API Key
    if ([self.apiKey stringValue].length == 32)
        [plugin setAPIKey:[self.apiKey stringValue]];
    else
    {
        shouldSave = NO;
        message = @"API Key not quite correct. Should be 32 characters.";
    }
    
    //Save the selected client
    NSUInteger selectedIndex = self.clientListPopup.indexOfSelectedItem;
    if (selectedIndex > 0)
    {
        NSArray *lists = [plugin getClientList];
        NSDictionary *list = [lists objectAtIndex:(selectedIndex - 1)];
        [plugin setDefaultClientId:[list objectForKey:@"ClientID"]];
    }
    else
    {
        shouldSave = NO;
        message = @"You must select a Client";
    }
    
    //Save the selected campaign
    selectedIndex = self.campaignListPopup.indexOfSelectedItem;
    if (selectedIndex > 0)
    {
        NSArray *lists = [plugin getCampaignList];
        NSDictionary *list = [lists objectAtIndex:(selectedIndex - 1)];
        [plugin setDefaultCampaignId:[list objectForKey:@"ListID"]];
    }
    else
    {
        shouldSave = NO;
        message = @"You must select a Campaign";
    }
    
    if (shouldSave)
    {
        [plugin SavePreferences];
        message = @"Preferences have been saved.";
    }
    
    NSAlert *al = [[NSAlert alloc] init];
    [al setMessageText:message];
    [al runModal];
}

@end
