//
//  NewAliasViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import <UIKit/UIKit.h>
#import "Alias.h"

@interface NewAliasViewController : UIViewController <NSXMLParserDelegate> {
    IBOutlet UIButton *randomizeButton;
    IBOutlet UISwitch *usageType;
    IBOutlet UITextField *inputAlias;
    IBOutlet UILabel *nonAvailable;
    IBOutlet UIActivityIndicatorView *aliasIndicator;
    IBOutlet UIBarButtonItem *doneButton;
    
    NSString *aliasName;
    NSMutableString *generatedName;
    Boolean *usageSetting;
    NSXMLParser *chatParser;
    NSMutableData *receivedData;
    NSMutableArray *listAliases;
    NSString *chat_id;
    BOOL *inID;
    NSMutableString *parsing_id;
    
}

-(IBAction)checkAvailable:(id)sender;
@property (nonatomic, retain) Alias *make_alias;
@property (nonatomic, retain) UIButton *randomizeButton;
@property (nonatomic, retain) UISwitch *usageType;
@property (nonatomic, retain) SlyAccount *sly;


@end
