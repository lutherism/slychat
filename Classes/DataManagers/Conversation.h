//
//  Conversation.h
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alias, Contact, Message;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSDate * date_started;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSNumber * new_msg;
@property (nonatomic, retain) Message *messages;
@property (nonatomic, retain) Contact *partner;
@property (nonatomic, retain) Alias *myAlias;

@end
