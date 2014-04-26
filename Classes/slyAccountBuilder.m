//
//  slyAccountBuilder.m
//  slychat
//
//  Created by Alexander Jansen on 4/21/14.
//
//

#import "slyAccountBuilder.h"
#import "Contact.h"
#import "Message.h"

@implementation slyAccountBuilder

+(SlyAccount *)slyFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil){
        *error = localError;
        return nil;
    }
    
    NSMutableArray *aliases = [[NSMutableArray alloc]init];
    NSMutableArray *totalcontacts = [[NSMutableArray alloc]init];
    NSMutableArray *totalmessages = [[NSMutableArray alloc]init];
    SlyAccount *sly = [[SlyAccount alloc]init];
    
    //NSArray *messages = [parsedObject ];
    //NSLog(@"Recieved %i messages.",[messages count]);
    
    //for(NSDictionary *messageDic in messages) {
    for(NSString *aliaskey in parsedObject){
        NSLog(@"%@",aliaskey);
        if([sly respondsToSelector:NSSelectorFromString(aliaskey)]){
            [sly setValue:[parsedObject objectForKey:aliaskey] forKey:aliaskey];
        }
        else{
            Alias *alias = [[Alias alloc]init];
            NSMutableArray *contacts = [[NSMutableArray alloc]init];
            for(NSString *alias_info_key in [parsedObject objectForKey:aliaskey]){
                if([alias respondsToSelector:NSSelectorFromString(alias_info_key)]){
                    [alias setValue:[[parsedObject objectForKey:aliaskey]objectForKey:alias_info_key] forKey:alias_info_key];
                }
                else{
                    Contact *contact = [[Contact alloc]init];
                    NSMutableArray *msgs = [[NSMutableArray alloc]init];
                    for(NSString *contact_info_key in [[parsedObject objectForKey:aliaskey]objectForKey:alias_info_key]){
                        if([contact respondsToSelector:NSSelectorFromString(contact_info_key)]){
                            [contact setValue:[[[parsedObject objectForKey:aliaskey]objectForKey:alias_info_key]objectForKey:contact_info_key] forKey:contact_info_key];
                        }
                        else{
                            Message *msg = [[Message alloc]init];
                            for(NSString *message_info_key in [[[parsedObject objectForKey:aliaskey]objectForKey:alias_info_key]objectForKey:contact_info_key]){
                                if([msg respondsToSelector:NSSelectorFromString(message_info_key)]){
                                    [msg setValue:[[[[parsedObject objectForKey:aliaskey]objectForKey:alias_info_key]objectForKey:contact_info_key]objectForKey:message_info_key] forKey:message_info_key];
                                }
                            }
                            msg.sly = sly;
                            msg.alias = alias;
                            msg.contact = contact;
                            [msgs addObject:msg];
                            [totalmessages addObject:msg];
                        }
                    }
                    contact.alias = alias;
                    contact.sly = sly;
                    //[contact addMessages:msgs];
                    [contacts addObject:contact];
                    [totalcontacts addObject:contact];
                }
            }
            alias.sly = sly;
            //[alias addSlyContacts:contacts];
            [aliases addObject:alias];
        }
    }
    [sly addAliases:aliases];
    [sly addSlyContacts:totalcontacts];
    [sly addMessages:totalmessages];
    return sly;
}

@end
