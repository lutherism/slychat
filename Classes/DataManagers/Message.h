//
//  Message.h
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"
#import "Alias.h"
#import "SlyAccount.h"

@class Alias;
@class Contact;
@class SlyAccount;


@interface Message : NSObject <NSCopying, NSCoding>

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date_sent;
@property (nonatomic, retain) NSNumber * isMedia;
@property (nonatomic, retain) NSString * mediaURL;
@property (nonatomic, retain) SlyAccount* sly;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Alias *alias;
@property (nonatomic, retain) NSNumber * mid;

-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact sly:(SlyAccount *)sly alias:(Alias *)alias;
-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl sly:(SlyAccount *)sly alias:(Alias *)alias;
-(id)initwithText:(NSString *)message mid:(NSNumber *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl date:(NSDate *)date_sent isMedia:(NSNumber *)ismedia sly:(SlyAccount *)sly alias:(Alias *)alias;

-(NSString *)getText;
-(Contact *)getContact;
-(NSNumber *)getMessageID;
-(NSString *)getMedia;
-(NSDate *)getDateSent;
-(SlyAccount *)getSly;

@end
