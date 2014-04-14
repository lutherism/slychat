//
//  MessageManager.m
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import "MessageManager.h"
#import "MessageCommunicator.h"
#import "MessageBuilder.h"

@implementation MessageManager

-(void)fetchMessagesForConv:(NSString *)coordinate
{
    [self.communicator getMessagesForContact:coordinate];
}

-(void)receivedMessageJSON:(NSData *)messageNotation
{
    NSError *error = nil;
    NSArray *messages = [MessageBuilder messagesFromJSON:messageNotation error:&error];
    
    if(error != nil){
        [self.delegate fetchingMessagesFailedWithError:error];
    }
    else {
        [self.delegate didRecieveMessages:messages];
    }
}
-(void)fetchingMessageFailedWithError:(NSError *)error{
    NSLog(@"Error fetching Message: %@",[error localizedDescription]);
}
@end
