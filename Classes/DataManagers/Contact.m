//
//  Contact.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "Contact.h"


@implementation Contact


#define kNameKey    @"partner"
#define kDateKey    @"date_connected"
#define kChatKey    @"chat"
#define kAliasKey   @"alias"
#define kMessagesKey   @"messages"
#define kSlyKey   @"sly"


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_partner forKey:kNameKey];
    [encoder encodeObject:_date_connected forKey:kDateKey];
    [encoder encodeObject:_chat_id forKey:kChatKey];
    [encoder encodeObject:_alias forKey:kAliasKey];
    [encoder encodeObject:_sly forKey:kSlyKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSDate *date_created = [decoder decodeObjectForKey:kDateKey];
    NSString *partner = [decoder decodeObjectForKey:kNameKey];
    Alias *alias = [decoder decodeObjectForKey:kAliasKey];
    NSNumber *chat = [decoder decodeObjectForKey:kChatKey];
    NSMutableArray *messages = [decoder decodeObjectForKey:kMessagesKey];
    SlyAccount *sly = [decoder decodeObjectForKey:kSlyKey];
    return [self initwithPartner:partner alias:alias date_connected:date_created chat_id:chat messages:messages sly:sly];
}

-(void)dealloc{
    [_partner release];
    [_chat_id release];
    [_date_connected release];
    [_alias release];
    [_sly release];
    [_messages release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    Contact *copy = [[[self class] allocWithZone: zone] initwithPartner:_partner alias:_alias date_connected:_date_connected chat_id:_chat_id messages:_messages sly:_sly];
    return copy;
}

- (id)initwithPartner:(NSString *)partner alias:(Alias *)alias date_connected:(NSDate *)date_created chat_id:(NSNumber *)chat_id messages:(NSMutableArray *)messages sly:(SlyAccount *)sly{
    self = [super init];
    _alias=[alias copy];
    _partner=[partner copy];
    _date_connected = [date_created copy];
    _chat_id = [chat_id copy];
    _messages = [messages copy];
    return self;
}

- (id)initwithPartner:(NSString *)partner alias:(Alias *)alias chat_id:(NSNumber *)chat_id sly:(SlyAccount *)sly{
    self = [super init];
    _alias=[alias copy];
    _partner=[partner copy];
    _date_connected = [[NSDate alloc]init];
    _chat_id = [chat_id copy];
    _messages = [[NSMutableArray alloc]init];
    return self;
}

-(NSString *)getPartnerName{
    if(_partner)return _partner;
    return nil;
}

-(Alias *)getMyAlias{
    if(_alias)return _alias;
    return nil;
}

-(NSNumber *)getChatID{
    if(_chat_id)return _chat_id;
    return nil;
}
-(NSMutableArray *)getMessages{
    if(_messages)return _messages;
    return nil;
}

-(void)addMessages:(NSArray *)msgs{
    [_messages addObjectsFromArray:msgs];
}
-(Message *)getMessageByID:(NSNumber *)mid{
    for(Message *m in _messages){
        if([[m getMessageID]isEqual:mid])return m;
    }
    return nil;
}
-(SlyAccount *)getSly{
    if(_sly)return _sly;
    return nil;
}

@end
