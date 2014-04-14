//
//  AliasDatabase.h
//  slychat
//
//  Created by Alexander Jansen on 4/10/14.
//
//

#import <Foundation/Foundation.h>
#import "Alias.h"

@interface AliasDatabase : NSObject

@property (nonatomic, retain) NSMutableArray *loadedAlias;

+(NSArray *)loadAliases;
+(void)save:(Alias *)a;


@end
