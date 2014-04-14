//
//  AliasesViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import <UIKit/UIKit.h>

@interface AliasesViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UIButton *createAlias;
    IBOutlet UITableView *aliasList;
    
	
}

@property (nonatomic,retain) UIButton *createAlias;
@property (nonatomic,retain) UITableView *aliasList;
@property (nonatomic,retain) NSMutableArray *aliases;
-(void)loadInitialData;

@end
