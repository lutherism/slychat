//
//  slyAccountBuilder.h
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import <Foundation/Foundation.h>
#import "SlyAccount.h"


@interface slyAccountBuilder : NSObject

+(SlyAccount *)slyFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end

