//
//  SlyAccountCommunicator.h
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccount.h"

@class SlyAccount;

@protocol SlyAccountCommunicatorDelegate;

@interface SlyAccountCommunicator : NSObject

@property (assign, nonatomic) id<SlyAccountCommunicatorDelegate> delegate;

-(void)getDatawithSly:(SlyAccount *)sly;


@end
