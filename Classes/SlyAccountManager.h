//
//  SlyAccountManager.h
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccountCommunicatorDelegate.h"
#import "SlyAccountManagerDelegate.h"

@class SlyAccountCommunicator;
@class SlyAccount;

@interface SlyAccountManager : NSObject <SlyAccountCommunicatorDelegate>
@property (retain, nonatomic) SlyAccountCommunicator *communicator;
@property (assign, nonatomic) id<SlyAccountManagerDelegate> delegate;
@property (nonatomic,retain) SlyAccount *sly;

-(void)fetchDatawithSly:(SlyAccount *)sly;

@end
