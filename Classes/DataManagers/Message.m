//
//  Message.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "Message.h"


@implementation Message

#define kContactKey @"contact"
#define kDateKey    @"date_sent"
#define kMessageKey @"message"
#define kLinkKey    @"medialink"
#define kIsMediaKey @"ismeda"
#define kIDKey @"messageID"
#define kSlyKey @"sly"
#define kAliasKey @"alias"
#define kSenderKey @"sender"
#define kCIDKey @"cid"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_contact forKey:kContactKey];
    [encoder encodeObject:_date_sent forKey:kDateKey];
    [encoder encodeObject:_message forKey:kMessageKey];
    [encoder encodeObject:_medialink forKey:kLinkKey];
    [encoder encodeObject:_ismedia forKey:kIsMediaKey];
    [encoder encodeObject:_mid forKey:kIDKey];
    [encoder encodeObject:_cid forKey:kCIDKey];
    [encoder encodeObject:_sly forKey:kSlyKey];
    [encoder encodeObject:_alias forKey:kAliasKey];
    [encoder encodeObject:_sender forKey:kSenderKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *date = [decoder decodeObjectForKey:kDateKey];
    NSString *text = [decoder decodeObjectForKey:kMessageKey];
    Contact *conversation = [decoder decodeObjectForKey:kContactKey];
    NSString *mediaURL = [decoder decodeObjectForKey:kLinkKey];
    NSString *sender = [decoder decodeObjectForKey:kSenderKey];
    NSString *mediacont = [decoder decodeObjectForKey:kIsMediaKey];
    NSString *mid = [decoder decodeObjectForKey:kIDKey];
    NSString *cid = [decoder decodeObjectForKey:kCIDKey];
    SlyAccount *sly = [decoder decodeObjectForKey:kSlyKey];
    Alias *alias = [decoder decodeObjectForKey:kAliasKey];
    return [self initwithText:text mid:mid contact:conversation mediaURL:mediaURL date:date isMedia:mediacont sender:sender cid:cid sly:sly alias:alias];
}

-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _message = [message copy];
    _date_sent = [[[NSDate alloc]init]description];
    _ismedia = 0;
    _medialink = nil;
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    _sender = [sender copy];
    _cid = [cid copy];
    return self;
}

-(id)initwithText:(NSString *)message mid:(NSString *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _message = [message copy];
    _date_sent = [[[NSDate alloc]init]description];
    _ismedia = 1;
    _medialink = [mediaurl copy];
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    _sender = [sender copy];
    _cid = [cid copy];
    return self;
}

-(id)initwithText:(NSString *)message mid:(NSString *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl date:(NSString *)date_sent isMedia:(NSString *)mediacont sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _message = [message copy];
    _date_sent = [date_sent copy];
    _ismedia = [mediacont copy];
    _medialink = [mediaurl copy];
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    _sender = [sender copy];
    _cid = [cid copy];
    return self;
}
-(void)dealloc{
    [_message release];
    [_date_sent release];
    [_ismedia release];
    [_medialink release];
    [_mid release];
    [_contact release];
    [_sly release];
    [_alias release];
    [_sender release];
    [_cid release];
    [super dealloc];
}
- (id)copyWithZone:(NSZone *)zone
{
    Message *copy = [[[self class] allocWithZone: zone] initwithText:_message mid:_mid contact:_contact mediaURL:_medialink date:_date_sent isMedia:_ismedia sender:_sender cid:_cid sly:_sly alias:_alias];
    return copy;
}
-(NSString *)getText{
    if(_message)return _message;
    return nil;
}
-(NSString *)getSender{
    if(_sender)return _sender;
    return nil;
}
-(Contact *)getContact{
    if(_contact)return _contact;
    return nil;
}
-(NSString *)getDateSent{
    if(_date_sent)return _date_sent;
    return nil;
}
-(NSString *)getMedia{
    if(_ismedia>0)return _medialink;
    return nil;
}
-(NSString *)getMessageID{
    if(_mid) return _mid;
    return nil;
}
-(NSString *)getChatID{
    if(_cid)return _cid;
    return nil;
}
-(SlyAccount *)getSly{
    if(_sly)return _sly;
    return nil;
}

@end
