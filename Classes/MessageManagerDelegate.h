//
//  MessageManager.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol MessageManagerDelegate

-(void)didRecieveMessages:(NSArray *)messages;
-(void)fetchingMessagesFailedWithError:(NSError *)error;

@end
