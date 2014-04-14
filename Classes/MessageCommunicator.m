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

-(void)getMessagesForContact:(NSString *)coordinate
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://slychat.openrobot.net/messages.php?contact=%@", coordinate];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    NSMutableURLRequest *req =[[NSMutableURLRequest alloc] initWithURL:url];
    //[req setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    [urlAsString release];
    [url release];
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingMessageFailedWithError:error];
        } else {
            [self.delegate receivedMessageJSON:data];
        }
    }];
}

@end
