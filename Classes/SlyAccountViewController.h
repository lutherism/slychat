//
//  SlyAccountViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import <UIKit/UIKit.h>
#import "MessageTimer.h"

@interface SlyAccountViewController : UIViewController <NSXMLParserDelegate> {
    NSString *aliasName;
    NSMutableString *generatedName;
    Boolean *usageSetting;
    NSXMLParser *chatParser;
    NSMutableData *receivedData;
    NSMutableArray *listAliases;
    NSString *chat_id;
    BOOL *inID;
    NSMutableString *parsing_id;
    NSString *name;
    NSString *pass;
}
@property (retain, nonatomic) IBOutlet UITextField *accountEditField;
@property (retain, nonatomic) IBOutlet UITextField *passwordEditField;
@property (retain, nonatomic) IBOutlet UITextField *accountLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *aliasIndicator;
@property (retain, nonatomic) MessageTimer *messagetimer;


@end
