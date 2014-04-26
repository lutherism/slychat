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

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * date_sent;
@property (nonatomic, retain) NSString * ismedia;
@property (nonatomic, retain) NSString * medialink;
@property (nonatomic, retain) SlyAccount* sly;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Alias *alias;
@property (nonatomic, retain) NSString *mid;
@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *sender;


-(id)initwithText:(NSString *)message mid:(NSString *)mid contact:(Contact *)contact sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias;
-(id)initwithText:(NSString *)message mid:(NSString *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias;
-(id)initwithText:(NSString *)message mid:(NSString *)mid contact:(Contact *)contact mediaURL:(NSString *)mediaurl date:(NSString *)date_sent isMedia:(NSString *)ismedia sender:(NSString *)sender cid:(NSString *)cid sly:(SlyAccount *)sly alias:(Alias *)alias;

-(NSString *)getText;
-(Contact *)getContact;
-(NSString *)getMessageID;
-(NSString *)getMedia;
-(NSString *)getDateSent;
-(SlyAccount *)getSly;
-(NSString *)getSender;
-(NSString *)getChatID;

@end
