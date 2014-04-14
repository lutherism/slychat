//
//  Contact.h
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Alias.h"
#import "Message.h"

@class Alias;
@class Message;
@class SlyAccount;

@interface Contact : NSObject <NSCopying, NSCoding>

@property (nonatomic,retain) NSString *partner;
@property (nonatomic, retain) NSDate *date_connected;
@property (nonatomic,retain) Alias *alias;
@property (nonatomic,retain) NSNumber *chat_id;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) SlyAccount *sly;

- (id)initwithPartner:(NSString *)name alias:(Alias *)alias chat_id:(NSNumber *)chat_id sly:(SlyAccount *)sly;
- (id)initwithPartner:(NSString *)name alias:(Alias *)alias date_connected:(NSDate *)date_created chat_id:(NSNumber *)chat_id messages:(NSMutableArray *)messages sly:(SlyAccount *)sly;

-(NSString *)getPartnerName;
-(Alias *)getMyAlias;
-(NSNumber *)getChatID;
-(NSMutableArray *)getMessages;
-(SlyAccount *)getSly;
-(Message *)getMessageByID:(NSNumber *)mid;

-(void)addMessages:(NSArray *)msg;


@end
