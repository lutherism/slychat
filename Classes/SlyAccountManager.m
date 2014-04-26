//
//  SlyAccountManager.m
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import "SlyAccountManager.h"
#import "SlyAccountCommunicator.h"
#import "SlyAccountBuilder.h"

@implementation SlyAccountManager

-(void)fetchDatawithSly:(SlyAccount *)sly
{
    [self.communicator getDatawithSly:sly];
}

-(void)receivedSlyJSON:(NSData *)slyNotation
{
    NSError *error = nil;
    SlyAccount *sly = [slyAccountBuilder slyFromJSON:slyNotation error:&error];
    if(error != nil){
        [self.delegate fetchingSlyFailedWithError:error];
    }
    else {
        [self.delegate didRecieveSly:sly];
    }
}
-(void)fetchingSlyFailedWithError:(NSError *)error{
    NSLog(@"Error fetching Message: %@",[error localizedDescription]);
}
@end
