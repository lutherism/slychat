//
//  MessageTimer.m
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import "MessageTimer.h"
#import "Message.h"
#import "SlyDatabase.h"
#import "SlyAccountManager.h"
#import "SlyAccountCommunicator.h"
#import "MessageCommunicator.h"
#import "MessageManager.h"
#import "SlyAccount.h"
#import "Alias.h"
#import "Contact.h"
#import "slychatAppDelegate.h"

@implementation MessageTimer {
    NSArray *_messages;
    SlyAccountManager *_slymanager;
    MessageManager *_msgmanager;
}

//Server Request Methods

-(id)init{
    [super init];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"slyaccount: %@",[[SlyDatabase loadSly] getName]);
    _slymanager = [[SlyAccountManager alloc] init];
    _slymanager.communicator = [[SlyAccountCommunicator alloc] init];
    _slymanager.communicator.delegate = _slymanager;
    _slymanager.delegate = self;
    _msgmanager = [[MessageManager alloc] init];
    _msgmanager.communicator = [[MessageCommunicator alloc] init];
    _msgmanager.communicator.delegate = _msgmanager;
    _msgmanager.delegate = self;
    lastMsg = 0;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
								[self methodSignatureForSelector: @selector(timerCallback)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timerCallback)];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0
										 invocation:invocation repeats:YES];
    [self fetchFullSlyData];
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void)fetchingMessagesFailedWithError:(NSError *)error{
    NSLog(@"Error loading messages: %@",[error localizedDescription]);
}

-(void)startFetchingMessages
{
    NSLog(@"Checking for New Messages with ID %i.", lastMsg);
    [_msgmanager fetchMessageSinceID:[NSNumber numberWithInt:lastMsg] withSly:[SlyDatabase loadSly]];
}

-(void)fetchFullSlyData
{
    NSLog(@"getching Sly Data");
    [_slymanager fetchDatawithSly:[SlyDatabase loadSly]];
}

-(void)didRecieveMessages:(NSArray *)messages{
    SlyAccount *sly = [[SlyDatabase loadSly]retain];
    [sly addMessages:messages];
    NSLog(@"%@",[[sly getMessages]description]);
    for(Message *m in messages){
        if(lastMsg<[[m getMessageID]intValue])lastMsg = [[m getMessageID]intValue];
    }
    [SlyDatabase save:sly];
    [sly release];
    if([messages count]>0)[[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];
}

-(void)didRecieveSly:(SlyAccount *)sly
{
    for(Message *m in [sly getMessages]){
        if(lastMsg<[[m getMessageID]intValue])lastMsg = [[m getMessageID]intValue];
    }
    [SlyDatabase save:sly];
    [self startFetchingMessages];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRoot" object:nil];
    
    //_appDelegate.mainStoryboard

}

- (void)timerCallback {
    NSLog(@"timer callback");
    [self startFetchingMessages];
}



@end
