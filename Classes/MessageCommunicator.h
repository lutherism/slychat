//
//  MessageCommunicator.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol MessageCommunicatorDelegate;

@interface MessageCommunicator : NSObject

@property (assign, nonatomic) id<MessageCommunicatorDelegate> delegate;

-(void)getMessagesForContact:(NSString *)coordinate;

@end
