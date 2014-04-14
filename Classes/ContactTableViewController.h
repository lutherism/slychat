//
//  ContactTableViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import <UIKit/UIKit.h>
#import "ContactDatabase.h"
#import "MessageTimer.h"

@interface ContactTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UIButton *addContact;
    IBOutlet UITableView *contactList;
    
    NSMutableString *contactName;
    NSString *newContactName;
    int contactID;
    Boolean unreadmsg;
    int numunread;
    
    

}

@property (nonatomic,retain) UIButton *addContact;
@property (nonatomic,retain) UITableView *contactList;
@property int rowSelected;
@property (nonatomic,retain)NSMutableArray *contacts;
@property (nonatomic, retain)MessageTimer *messagChecker;
@property (nonatomic, retain)SlyAccount sly;



@end
