//
//  SlyAccountManagerDelegate.h
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccount.h"


@protocol SlyAccountManagerDelegate <NSObject>

-(void)didRecieveSly:(SlyAccount *)sly;
-(void)fetchingSlyFailedWithError:(NSError *)error;

@end
