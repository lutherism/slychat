//
//  MessageBuilder.m
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import "MessageBuilder.h"
#import "Message.h"

@implementation MessageBuilder

+(NSArray *)messagesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil){
        *error = localError;
        return nil;
    }
    
    NSMutableArray *msgs = [[NSMutableArray alloc]init];
    
    NSArray *messages = [[parsedObject valueForKeyPath:@"chat"] valueForKeyPath:@"message"];
    NSLog(@"Recieved %i messages.",[messages count]);
    
    for(NSDictionary *messageDic in messages) {
        Message *msg = [[Message alloc]init];
        
        for(NSString *key in messageDic){
            if([msg respondsToSelector:NSSelectorFromString(key)]){
                [msg setValue:[messageDic valueForKey:key] forKey:key];
            }
        }
        [msgs addObject:msg];
    }
    return msgs;
}

@end
