//
//  MessageBuilder.h
//  slychat
//
//  Created by Alexander Jansen on 4/13/14.
//
//

#import <Foundation/Foundation.h>

@interface MessageBuilder : NSObject

+(NSArray *)messagesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
