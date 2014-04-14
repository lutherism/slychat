//
//  Conversation.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "Conversation.h"
#import "Alias.h"
#import "Contact.h"
#import "Message.h"


@implementation Conversation

@dynamic date_started;
@dynamic unread;
@dynamic new_msg;
@dynamic messages;
@dynamic partner;
@dynamic myAlias;

- (id)init{
    [super init];
    return self;
}

@end
