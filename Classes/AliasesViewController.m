//
//  AliasesViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import "AliasesViewController.h"
#import "Alias.h"
#import "AliasDatabase.h"
#import "NewAliasViewController.h"
#import "checkForRequests.h"


@interface AliasesViewController ()

@property (nonatomic,retain) AliasDatabase *database;

@end

@implementation AliasesViewController;
@synthesize createAlias;
@synthesize aliasList;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    NewAliasViewController *source = [segue sourceViewController];
    if (source.make_alias != nil) {
        [AliasDatabase save:source.make_alias];
        [self loadInitialData];
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad
{
    /*NSMutableArray *loadedAlias = [AliasDatabase loadAliasDocs];
    for(AliasDoc *a in loadedAlias){
        if(a.data !=nil)
        [self.aliases addObject:a.data];
    }*/
    [self loadInitialData];
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadInitialData {
    NSLog(@"Load Data");
    self.aliases =[[NSMutableArray alloc]initWithArray:[AliasDatabase loadAliases]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [super dealloc];
    [createAlias release];
    [aliasList release];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.aliases count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AliasCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    NSLog(@"make cell");
    cell.textLabel.text = [[_aliases objectAtIndex:indexPath.row] getName];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkRequests"]){
        checkForRequests *controller = (checkForRequests *)segue.destinationViewController;
        //[controller release];
        Alias *send_alias = [[_aliases objectAtIndex:[self.tableView indexPathForSelectedRow].row]copy];
        controller.checkThis = send_alias;
    }
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
