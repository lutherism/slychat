//
//  NewContactViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "NewContactViewController.h"
#import "Contact.h"
#import "ContactTableViewController.h"


@interface NewContactViewController ()

@property NSMutableArray *contactData;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation NewContactViewController



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(sender == self.doneButton){
        [self getNewContact];
    }

}

-(IBAction)makeConnection{
    [connectingIndicator startAnimating];
    [self getNewContact];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [listAliases count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if([listAliases count]>0)return [[listAliases objectAtIndex:row]getName];
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if([listAliases count]>0)selectedAlias = [listAliases objectAtIndex:row];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    listAliases = [[NSMutableArray arrayWithArray:[[SlyDatabase loadSly]getAliases]]retain];
    if([listAliases count]>0)selectedAlias = [listAliases objectAtIndex:0];
    [inputContact becomeFirstResponder];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [inputContact release];
    [_doneButton release];
    [myAliases release];
    [_make_contact release];
    [connectingIndicator release];
    [connectButton release];
    [super dealloc];
}

//Server Request Data
- (void)getNewContact {
    NSLog(@"Get Messages");
    [connectingIndicator startAnimating];
    inputContact.enabled = NO;
    self.doneButton.enabled=NO;
    [myAliases setUserInteractionEnabled:NO];
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/create.php?user=%@&target=%@",
					 selectedAlias.getName, inputContact.text];
    NSLog(@"%@",url);
	
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        receivedData = [[NSMutableData data] retain];
        NSLog(@"Connection Made");
    }
    else
    {
    }
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response Recieved");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data
{
    NSLog(@"Response Recieved w/Data");
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Got Connection");
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
    for(NSString *key in parsedObject){
        if([key isEqualToString:@"id"]){
            NSLog(@"contact made: %@",key);
            SlyAccount *sly = [SlyDatabase loadSly];
            _make_contact = [[Contact alloc]initwithPartner:inputContact.text alias:[sly getAliasWithName:[selectedAlias getName]] chat_id:[parsedObject objectForKey:key] sly:sly];
            [sly addSlyContacts:[NSArray arrayWithObject:_make_contact]];
            [SlyDatabase save:sly];
            [self performSegueWithIdentifier:@"createcontact" sender:self.doneButton];
        }
        else{
            inputContact.text = @"";
            self.doneButton.enabled=YES;
        }
        
    }
    [connectingIndicator stopAnimating];
}

@end
