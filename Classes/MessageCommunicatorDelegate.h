//
//  MessageCommunicatorDelegate.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol MessageCommunicatorDelegate <NSObject>

-(void)receivedMessageJSON:(NSData *)messageNotation;
-(void)fetchingMessageFailedWithError:(NSError *)error;

@end
