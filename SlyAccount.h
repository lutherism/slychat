//
//  SlyAccount.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <Foundation/Foundation.h>
#import "Alias.h"
#import "Contact.h"
#import "KeyChainItemWrapper.h"

@class Alias;
@class Contact;
@class Message;

@interface SlyAccount : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSMutableArray *aliases;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) KeychainItemWrapper *keys;

- (id)initWithName:(NSString *)name date:(NSDate *)date_created aliaslist:(NSMutableArray *)aliases contacts:(NSMutableArray *)contacts messages:(NSMutableArray *)messages keys:(KeychainItemWrapper *)keys;
- (id)initwithName:(NSString *)name keys:(KeychainItemWrapper *)keys;

-(NSString *)getName;
-(NSArray *)getAliases;
-(NSArray *)getContacts;
-(NSArray *)getMessages;
-(KeychainItemWrapper *)getKeys;

-(Alias *)getAliasWithName:(NSString *)name;
-(Contact *)getContactWithID:(NSNumber *)cont;

-(void)addSlyContacts:(NSArray *)contacts;
-(void)addMessages:(NSArray *)messages;
-(void)addAliases:(NSArray *)aliases;


@end
