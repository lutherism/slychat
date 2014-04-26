//
//  NewContactViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "SlyDatabase.h"

@interface NewContactViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,NSXMLParserDelegate>{
    IBOutlet UIButton *addContact;
    IBOutlet UITextField *inputContact;
    IBOutlet UIButton *contacts;
    IBOutlet UIPickerView *myAliases;
    IBOutlet UIActivityIndicatorView *connectingIndicator;
    IBOutlet UIButton *connectButton;
    NSMutableData *receivedData;
    NSMutableArray *listAliases;
    Alias *selectedAlias;
    NSString *chat_id;
    BOOL *inID;
    NSMutableString *parsing_id;
    
}
@property (nonatomic,retain) Contact *make_contact;
-(IBAction)makeConnection;



@end
