//
//  slychatAppDelegate.m
//  slychat
//
//  Created by Alexander Jansen on 3/23/14.
//  Copyright Cuesta College 2014. All rights reserved.
//

#import "slychatAppDelegate.h"
#import "slychatViewController.h"
#import "AliasesViewController.h"

@implementation slychatAppDelegate;




- (void)applicationDidFinishLaunching:(UIApplication *)application {
    //NSString *segueId = @""
    //NSString *segueId = isLoggedIn ? @"MainIdentifier" : @"LoginIdentifier";
    //UIViewController *initViewController = [_mainStoryboard instantiateViewControllerWithIdentifier:segueId];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL isLoggedIn = ([SlyDatabase loadSly]);
    NSString *segueId;
    if(isLoggedIn){
        segueId = @"Main";
        _messagetimer = [[MessageTimer alloc]init];
    }
    else{
        segueId = @"Login";
    }
     _mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *initViewController = [_mainStoryboard instantiateViewControllerWithIdentifier:segueId];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = initViewController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}


@end
