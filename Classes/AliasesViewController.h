//
//  AliasesViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import <UIKit/UIKit.h>
#import "slychatAppDelegate.h"

@class SlyAccount;

@interface AliasesViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UIButton *createAlias;
    IBOutlet UITableView *aliasList;
    
	
}

@property (nonatomic,retain) UIButton *createAlias;
@property (nonatomic,retain) UITableView *aliasList;
@property (nonatomic,retain) NSMutableArray *aliases;
@property (nonatomic, retain)SlyAccount *sly;
@property (nonatomic,retain)slychatAppDelegate *appDelegate;
-(void)loadInitialData;

@end
