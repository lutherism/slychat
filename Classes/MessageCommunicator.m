//
//  MessageCommunicator.m
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import "MessageCommunicator.h"
#import "MessageCommunicatorDelegate.h"

@implementation MessageCommunicator

-(void)getMessagesSinceID:(NSNumber *)coordinate withSly:(SlyAccount *)sly
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://slychat.openrobot.net/getnew.php?past=%@&slyr=%@", [coordinate stringValue], [sly getName]];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSMutableURLRequest *req =[[NSMutableURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingMessageFailedWithError:error];
        } else {
            [self.delegate receivedMessagesJSON:data];
        }
    }];
}

@end
