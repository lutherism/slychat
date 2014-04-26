//
//  ContactTableViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import "ContactTableViewController.h"
#import "Contact.h"
#import "NewContactViewController.h"
#import "SlychaterViewController.h"
#import "MessageTimer.h"
#import "SlyAccount.h"
#import "slychatAppDelegate.h"


@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

@synthesize contactList;
@synthesize addContact;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}
-(void)dealloc{
    [super dealloc];
}

- (void)unwindToList:(UIStoryboardSegue *)segue
{
    NewContactViewController *source = [segue sourceViewController];
    NSLog(@"load from new");
    [self.contactList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateRoot" object:nil];

    //[self loadInitialData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"check messages");
}

- (void)updateView:(NSNotification *)notification {
    NSLog(@"update view");
    [self.contactList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"load sections");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"load rows");
    NSLog(@"%@",[[[SlyDatabase loadSly]getContacts]description]);
    return [[[SlyDatabase loadSly]getContacts]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"load cell");
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Contact *contacted = [[[SlyDatabase loadSly] getContacts] objectAtIndex:indexPath.row];
    cell.textLabel.text = contacted.partner;
    NSLog(@"contacted for name %@",[[contacted getMyAlias]getName]);
    cell.detailTextLabel.text = [[contacted getMyAlias]getName];
    return cell;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"openchat"]){
        SlychaterViewController *controller = (SlychaterViewController *)segue.destinationViewController;
        //[controller release];
        controller.contactname = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;
    }
}




@end
