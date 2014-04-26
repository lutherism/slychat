//
//  SlyAccountCommunicator.m
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import "SlyAccountCommunicator.h"
#import "SlyAccountCommunicatorDelegate.h"

@implementation SlyAccountCommunicator

-(void)getDatawithSly:(SlyAccount *)sly
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://slychat.openrobot.net/slyfull.php?slyr=%@", [sly getName]];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSMutableURLRequest *req =[[NSMutableURLRequest alloc] initWithURL:url];
    //[req setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    //[urlAsString release];
    //[url release];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingSlyFailedWithError:error];
        } else {
            [self.delegate receivedSlyJSON:data];
        }
    }];
}

@end
