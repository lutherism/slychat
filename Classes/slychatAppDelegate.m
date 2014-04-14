//
//  slychatAppDelegate.m
//  slychat
//
//  Created by Alexander Jansen on 3/23/14.
//  Copyright Cuesta College 2014. All rights reserved.
//

#import "slychatAppDelegate.h"
#import "slychatViewController.h"
#import "AliasDatabase.h"
#import "AliasesViewController.h"

@implementation slychatAppDelegate;




- (void)applicationDidFinishLaunching:(UIApplication *)application {
    //NSString *segueId = @""
    //NSString *segueId = isLoggedIn ? @"MainIdentifier" : @"LoginIdentifier";
    //UIViewController *initViewController = [_mainStoryboard instantiateViewControllerWithIdentifier:segueId];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _mainData = [[SlyDatabase alloc]init];
    [_mainData loadSly];
    _messageChecker = [[MessageTimer alloc]initWithAccount:_mainData.myAccount];
    BOOL isLoggedIn = ([_mainData.myAccount getName]!=nil);
    NSString *segueId = isLoggedIn ? @"Main" : @"Login";
    NSLog(@"%@",segueId);
     _mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *initViewController = [_mainStoryboard instantiateViewControllerWithIdentifier:segueId];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = initViewController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_window release];
    [_mainData release];
    [_messageChecker release];
    [super dealloc];
}


@end
