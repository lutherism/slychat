//
//  MessageManager.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>
#import "MessageCommunicatorDelegate.h"
#import "MessageManagerDelegate.h"

@class MessageCommunicator;
@class SlyAccount;

@interface MessageManager : NSObject <MessageCommunicatorDelegate>
@property (retain, nonatomic) MessageCommunicator *communicator;
@property (assign, nonatomic) id<MessageManagerDelegate> delegate;
@property (nonatomic,retain) SlyAccount *sly;

-(void)fetchMessageSinceID:(NSNumber *)coordinate withSly:(SlyAccount *)sly;

@end
