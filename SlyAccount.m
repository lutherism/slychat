//
//  SlyAccount.m
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import "SlyAccount.h"
#import "Contact.h"
#import "Message.h"
#import "Alias.h"


@implementation SlyAccount

#define kDateKey      @"date_created"
#define kNameKey      @"name"
#define kAliasesKey   @"aliases"
#define kContactsKey  @"contacts"
#define kMessagesKey  @"messages"
#define kKeysKey  @"keys"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_date_created forKey:kDateKey];
    [encoder encodeObject:_aliases forKey:kAliasesKey];
    [encoder encodeObject:_contacts forKey:kContactsKey];
    [encoder encodeObject:_messages forKey:kMessagesKey];
    [encoder encodeObject:_keys forKey:kKeysKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *date_created = [decoder decodeObjectForKey:kDateKey];
    NSString *name = [decoder decodeObjectForKey:kNameKey];
    NSMutableArray *aliases = [[NSMutableArray alloc]init];
    [aliases addObjectsFromArray:[decoder decodeObjectForKey:kAliasesKey]];
    NSMutableArray *messages = [[NSMutableArray alloc]init];
    [messages addObjectsFromArray:[decoder decodeObjectForKey:kMessagesKey]];
    NSMutableArray *contacts = [[NSMutableArray alloc]init];
    [contacts addObjectsFromArray:[decoder decodeObjectForKey:kContactsKey]];
    KeychainItemWrapper *keys = [decoder decodeObjectForKey:kKeysKey];
    return [self initWithName:name date:date_created aliaslist:aliases contacts:contacts messages:messages keys:keys];
}
-(void)dealloc{
    [_name release];
    [_date_created release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    SlyAccount *copy = [[[self class] allocWithZone: zone] initWithName:_name date:_date_created aliaslist:_aliases contacts:_contacts messages:_messages keys:_keys];
    return copy;
}

- (id)initwithName:(NSString *)name keys:(KeychainItemWrapper *)keys{
    self = [super init];
    _name=[name copy];
    _date_created = [[[NSDate alloc]init]description];
    _aliases = [[NSMutableArray alloc]init];
    _contacts = [[NSMutableArray alloc]init];
    _messages = [[NSMutableArray alloc]init];
    _keys = keys;
    return self;
}


- (id)initWithName:(NSString *)name date:(NSString *)date_created aliaslist:(NSMutableArray *)aliases contacts:(NSMutableArray *)contacts messages:(NSMutableArray *)messages keys:(KeychainItemWrapper *)keys
{
    self = [super init];
    _name = [name copy];
    _date_created = [date_created copy];
    _aliases = [aliases copy];
    _contacts = [contacts copy];
    _messages = [messages copy];
    _messages = [keys copy];
    return self;
}
-(NSString *)getName{
    if(_name)return _name;
    return nil;
}
-(KeychainItemWrapper *)getKeys{
    if(_keys)return _keys;
    return nil;
}
-(void)addMessages:(NSArray *)messages{
    if([_messages count]<1)_messages=[[NSMutableArray alloc]init];
    for(Message *m in messages){
        NSLog(@"adding message: %@",[m getText]);
        [_messages addObject:m];
        Contact *contact = [self getContactWithID:[m getChatID]];
        [contact addMessages:[NSArray arrayWithObject:m]];
    }
}
-(void)addSlyContacts:(NSArray *)contacts{
    if([_contacts count]<1)_contacts = [[NSMutableArray alloc]init];
    for(Contact *c in contacts){
        NSLog(@"adding contact: %@",[c getChatID]);
        [_contacts addObject:c];
        Alias *alias = [c getMyAlias];
        [alias addSlyContacts:[NSArray arrayWithObject:c]];
    }
}
-(void)setAliases:(NSArray *)aliases{
    _aliases = [[NSMutableArray arrayWithArray:aliases]retain];
}
-(void)addAliases:(NSArray *)aliases{
    if([_aliases count]<1)_aliases = [[NSMutableArray alloc]init];
    [_aliases addObjectsFromArray:aliases];
}
-(NSArray *)getAliases
{
    if(_aliases)return _aliases;
    return nil;
}
-(NSArray *)getContacts
{
    if(_contacts)return _contacts;
    return nil;
}
-(NSArray *)getMessages
{
    if(_messages)return _messages;
    return nil;
}
-(Alias *)getAliasWithName:(NSString *)name {
    for(Alias *a in _aliases){
        if([[a getName] isEqual:name])return a;
    }
    return nil;
}
-(Contact *)getContactWithName:(NSString *)name{
    for(Alias *a in _aliases){
        for(Contact *c in [a getContacts]){
            if([[c getPartnerName]isEqual:name])return c;
        }
    }
    return nil;
}
-(Contact *)getContactWithID:(NSString *)cid{
    for(Alias *a in _aliases){
        for(Contact *c in [a getContacts]){
            if([[c getChatID]isEqual:cid])return c;
        }
    }
    return nil;
}


@end
