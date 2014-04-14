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
    [_messagChecker release];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    NewContactViewController *source = [segue sourceViewController];
    NSLog(@"load from new");
    if (source.make_contact != nil) {
        [_sly addSlyContacts:[NSArray arrayWithObject:source.make_contact]];
        [self loadInitialData];
        [self.contactList reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadInitialData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"check messages");
}
-(void)checkRequests {
    
    
}

- (void)loadInitialData {
    _contacts = [[NSMutableArray alloc]initWithArray:[_sly getContacts]];
    NSLog(@"%@",[_contacts description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contacts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Contact *contacted = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contacted.partner;
    cell.detailTextLabel.text = [contacted.alias getName];
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"openchat"]){
        SlychaterViewController *controller = (SlychaterViewController *)segue.destinationViewController;
        //[controller release];
        Contact *send_contact = [[_contacts objectAtIndex:[self.tableView indexPathForSelectedRow].row]copy];
        controller.contact = send_contact;
    }
}




@end
