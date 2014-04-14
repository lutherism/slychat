//
//  Alias.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "Alias.h"

@implementation Alias

#define kDateKey      @"date_created"
#define kNameKey      @"name"
#define kTypeKey      @"type"
#define kAvailableKey @"avail"
#define kContactsKey   @"contacts"
#define kSlyKey   @"sly"
#define kMessagesKey   @"messages"
#define kSettingsKey @"settings"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_date_created forKey:kDateKey];
    [encoder encodeObject:_contacts forKey:kContactsKey];
    [encoder encodeObject:_messages forKey:kMessagesKey];
    [encoder encodeObject:_settings forKey:kSettingsKey];
    [encoder encodeObject:_sly forKey:kSlyKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSDate *date_created = [decoder decodeObjectForKey:kDateKey];
    NSString *name = [decoder decodeObjectForKey:kNameKey];
    NSDictionary *settings = [decoder decodeObjectForKey:kSettingsKey];
    NSMutableArray *contacts = [decoder decodeObjectForKey:kContactsKey];
    NSMutableArray *messages = [decoder decodeObjectForKey:kMessagesKey];
    SlyAccount *sly = [decoder decodeObjectForKey:kSlyKey];
    return [self initWithName:name date_created:date_created settings:settings contacts:contacts messages:messages sly:sly];
}
-(void)dealloc{
    [_name release];
    [_date_created release];
    [_settings release];
    [_contacts release];
    [_messages release];
    [_contacts release];
    [super dealloc];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    Alias *copy = [[[self class] allocWithZone: zone] initWithName:_name date_created:_date_created settings:_settings contacts:_contacts messages:_messages sly:_sly];
    return copy;
}

- (id)initwithName:(NSString *)name sly:(SlyAccount *)sly{
    self = [super init];
    _name=[name copy];
    _date_created = [[NSDate alloc]init];
    _settings = [[NSDictionary alloc]init];
    _contacts = [[NSMutableArray alloc]init];
    _messages = [[NSMutableArray alloc]init];
    _sly = [sly copy];
    return self;
}


- (id)initWithName:(NSString *)name date_created:(NSDate *)date_created settings:(NSDictionary *)settings contacts:(NSMutableArray *)contacts messages:(NSMutableArray *)messages sly:(SlyAccount *)sly
{
    self = [super init];
    _name = [name copy];
    _date_created = [date_created copy];
    _settings = [settings copy];
    _contacts = [contacts copy];
    _messages = [messages copy];
    _sly = [sly copy];
    return self;
}

-(NSString *)getName{
    if(_name)return _name;
    return @"";
}
- (NSMutableArray *)getContacts
{
    if(_contacts)return _contacts;
    return nil;
}
-(Contact *)getContactWithID:(NSNumber *)cid{
    for(Contact *c in _contacts)
    {
        if([[c getChatID]isEqual:cid])return c;
    }
    return nil;
}
-(NSMutableArray *)getMessages{
    if(_messages)return _messages;
    return nil;
}
-(SlyAccount *)getAccount{
    if(_sly)return _sly;
    return _sly;
}
-(NSDictionary *)getSettings{
    if(_settings)return _settings;
    return nil;
}

-(void)addSlyContacts:(NSArray *)contacts{
    [_contacts addObjectsFromArray:contacts];
}
-(void)addMessages:(NSArray *)messages{
    [_messages addObjectsFromArray:messages];
    for(Contact *c in _contacts){
        [c addMessages:messages];
    }
}
-(void)setSettings:(NSDictionary *)settings{
    settings = [_settings copy];
}

@end
