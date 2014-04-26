//
//  SlyDatabase.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccount.h"

@interface SlyDatabase : NSObject
@property (nonatomic, retain) SlyAccount *myAccount;

+(SlyAccount *)loadSly;
-(void)save;
+(void)save:(SlyAccount *)sly;
+(void)deleteDocs;

@end
