//
//  Alias.h
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Alias.h"
#import "Contact.h"
#import "Message.h"
#import "SlyAccount.h"

@class Contact;
@class Conversation;

@interface Alias : NSObject <NSCoding, NSCopying>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) SlyAccount *sly;

- (id)initWithName:(NSString *)name date_created:(NSDate *)date_created settings:(NSDictionary *)settings contacts:(NSMutableArray *)contacts messages:(NSMutableArray *)messages sly:(SlyAccount *)sly;
- (id)initwithName:(NSString *)name sly:(SlyAccount *)sly;

-(NSString *)getName;
-(Contact *)getContactWithID:(NSNumber *)cid;
-(NSMutableArray *)getContacts;
-(NSMutableArray *)getMessages;
-(SlyAccount *)getAccount;
-(NSDictionary *)getSettings;

-(void)addSlyContacts:(NSArray *)contacts;
-(void)addMessages:(NSArray *)messages;
-(void)setSettings:(NSDictionary *)settings;
@end
