//
//  MessageCommunicator.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccount.h"

@class SlyAccount;

@protocol MessageCommunicatorDelegate;

@interface MessageCommunicator : NSObject

@property (assign, nonatomic) id<MessageCommunicatorDelegate> delegate;

-(void)getMessagesSinceID:(NSNumber *)coordinate withSly:(SlyAccount *)sly;

@end
