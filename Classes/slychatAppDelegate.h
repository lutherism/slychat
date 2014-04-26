//
//  slychatAppDelegate.h
//  slychat
//
//  Created by Alexander Jansen on 3/23/14.
//  Copyright Cuesta College 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlyDatabase.h"
#import "MessageTimer.h"


@interface slychatAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIStoryboard *mainStoryboard;
@property (nonatomic, retain) MessageTimer *messagetimer;

@end

