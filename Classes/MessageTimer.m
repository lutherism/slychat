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
#import "MessageManager.h"
#import "MessageCommunicator.h"
#import "SlyAccount.h"
#import "Alias.h"
#import "Contact.h"
#import "slychatAppDelegate.h"

@implementation MessageTimer {
    NSArray *_messages;
    MessageManager *_manager;
}

//Server Request Methods

-(id)initWithAccount:(SlyAccount *)sly{
    [super init];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    _sly = [sly copy];
    _manager = [[MessageManager alloc] init];
    _manager.communicator = [[MessageCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    lastMsg = 0;
    return self;
}

-(void)dealloc{
    [super dealloc];
    [_sly release];
}

-(void)fetchingMessagesFailedWithError:(NSError *)error{
    NSLog(@"Error loading messages: %@",[error localizedDescription]);
}

-(void)startFetchingMessages
{
    NSLog(@"Checking for New Messages to %@.", [_sly getName]);
    [_manager fetchMessagesForConv:[_sly getName]];
}

-(void)didRecieveMessages:(NSArray *)messages
{
    NSLog(@"Got %i new messages.",[messages count]);
    [_appDelegate.mainData.myAccount addMessages:messages];
    [_appDelegate.mainData save];
}

- (void)timerCallback {
    [self startFetchingMessages];
}



@end
