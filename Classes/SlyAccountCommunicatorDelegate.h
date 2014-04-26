//
//  SlyAccountCommunicatorDelegate.h
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import <Foundation/Foundation.h>

@protocol SlyAccountCommunicatorDelegate <NSObject>


-(void)receivedSlyJSON:(NSData *)messageNotation;
-(void)fetchingSlyFailedWithError:(NSError *)error;

@end
