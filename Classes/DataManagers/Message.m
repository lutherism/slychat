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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_contact forKey:kContactKey];
    [encoder encodeObject:_date_sent forKey:kDateKey];
    [encoder encodeObject:_text forKey:kMessageKey];
    [encoder encodeObject:_mediaURL forKey:kLinkKey];
    [encoder encodeObject:_isMedia forKey:kIsMediaKey];
    [encoder encodeObject:_mid forKey:kIDKey];
    [encoder encodeObject:_sly forKey:kSlyKey];
    [encoder encodeObject:_alias forKey:kAliasKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSDate *date = [decoder decodeObjectForKey:kDateKey];
    NSString *text = [decoder decodeObjectForKey:kMessageKey];
    Contact *conversation = [decoder decodeObjectForKey:kContactKey];
    NSString *mediaURL = [decoder decodeObjectForKey:kLinkKey];
    NSNumber *mediacont = [decoder decodeObjectForKey:kIsMediaKey];
    NSNumber *mid = [decoder decodeObjectForKey:kIDKey];
    SlyAccount *sly = [decoder decodeObjectForKey:kSlyKey];
    Alias *alias = [decoder decodeObjectForKey:kAliasKey];
    return [self initwithText:text mid:mid contact:conversation mediaURL:mediaURL date:date isMedia:mediacont sly:sly alias:alias];
}

-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _text = [message copy];
    _date_sent = [[NSDate alloc]init];
    _isMedia = 0;
    _mediaURL = nil;
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [_alias copy];
    return self;
}

-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _text = [message copy];
    _date_sent = [[NSDate alloc]init];
    _isMedia = 1;
    _mediaURL = [mediaurl copy];
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    return self;
}
-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl date:(NSDate *)date_sent sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _text = [message copy];
    _date_sent = [date_sent copy];
    _isMedia = 1;
    _mediaURL = [mediaurl copy];
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    return self;
}
-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl date:(NSDate *)date_sent isMedia:(NSNumber *)mediacont sly:(SlyAccount *)sly alias:(Alias *)alias{
    [super init];
    _text = [message copy];
    _date_sent = [date_sent copy];
    _isMedia = [mediacont copy];
    _mediaURL = [mediaurl copy];
    _contact = [contact copy];
    _sly = [sly copy];
    _alias = [alias copy];
    return self;
}
-(void)dealloc{
    [_text release];
    [_date_sent release];
    [_isMedia release];
    [_mediaURL release];
    [_mid release];
    [_contact release];
    [_sly release];
    [_alias release];
    [super dealloc];
}
- (id)copyWithZone:(NSZone *)zone
{
    Message *copy = [[[self class] allocWithZone: zone] initwithText:_text mid:_mid contact:_contact mediaURL:_mediaURL date:_date_sent isMedia:_isMedia sly:_sly alias:_alias];
    return copy;
}
-(NSString *)getText{
    if(_text)return _text;
    return nil;
}
-(Contact *)getContact{
    if(_contact)return _contact;
    return nil;
}
-(NSDate *)getDateSent{
    if(_date_sent)return _date_sent;
    return nil;
}
-(NSString *)getMedia{
    if(_isMedia>0)return _mediaURL;
    return nil;
}
-(NSNumber *)getMessageID{
    if(_mid) return _mid;
    return nil;
}
-(SlyAccount *)getSly{
    if(_sly)return _sly;
    return nil;
}

@end
