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
@property (nonatomic, retain) NSString *date;
@property (nonatomic,retain) Alias *alias;
@property (nonatomic,retain) NSString *cid;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) SlyAccount *sly;

- (id)initwithPartner:(NSString *)name alias:(Alias *)alias chat_id:(NSString *)chat_id sly:(SlyAccount *)sly;
- (id)initwithPartner:(NSString *)name alias:(Alias *)alias date_connected:(NSString *)date_created chat_id:(NSString *)chat_id messages:(NSMutableArray *)messages sly:(SlyAccount *)sly;

-(NSString *)getPartnerName;
-(Alias *)getMyAlias;
-(NSString *)getChatID;
-(NSMutableArray *)getMessages;
-(SlyAccount *)getSly;
-(Message *)getMessageByID:(NSString *)mid;

-(void)addMessages:(NSArray *)msg;


@end
