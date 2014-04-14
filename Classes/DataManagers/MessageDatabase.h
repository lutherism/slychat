//
//  MessageDatabase.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "Contact.h"

@interface MessageDatabase : NSObject

@property (nonatomic, retain) NSMutableArray *loadedMessages;

+(NSArray *)loadMessages:(Contact *)c;
+(void)save:(Message *)a;
+(void)deleteDocs;

@end
