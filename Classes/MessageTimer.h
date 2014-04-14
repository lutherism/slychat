//
//  MessageTimer.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <Foundation/Foundation.h>
#import "MessageManagerDelegate.h"

@class SlyAccount;
@class slychatAppDelegate;

@interface MessageTimer : NSObject <MessageManagerDelegate> {
    NSTimer *timer;
    int lastMsg;
    
}
-(id)initWithAccount:(SlyAccount *)sly;
@property (nonatomic,retain) slychatAppDelegate *appDelegate;
@property (nonatomic,retain) SlyAccount *sly;

@end
