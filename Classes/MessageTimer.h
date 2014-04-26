//
//  MessageTimer.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccountManagerDelegate.h"
#import "MessageManagerDelegate.h"

@class SlyAccount;
@class slychatAppDelegate;

@interface MessageTimer : NSObject <SlyAccountManagerDelegate, MessageManagerDelegate> {
    NSTimer *timer;
    int lastMsg;
    
}

@property (nonatomic,retain) slychatAppDelegate *appDelegate;

@end
