//
//  NewContactViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/8/14.
//
//

#import "NewContactViewController.h"
#import "Contact.h"


@interface NewContactViewController ()

@property NSMutableArray *contactData;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation NewContactViewController



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
        if (inputContact.text.length > 0) {
            self.make_contact = [[Contact alloc] initwithPartner:inputContact.text alias:selectedAlias chat_id:[NSNumber numberWithInteger:[parsing_id integerValue]] sly:_sly];
        
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
    [selectedAlias release];
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
    _sly = [[UIApplication sharedApplication]delegate]
    if([listAliases count]>0)selectedAlias =[listAliases objectAtIndex:0];
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
    if (chatParser)
        [chatParser release];
	
    if(receivedData)chatParser = [[NSXMLParser alloc] initWithData:receivedData];
    else NSLog(@"error: connecitonDidFinishLoading var receivedData");
    [chatParser setDelegate:self];
    [chatParser parse];
	
    [receivedData release];
}
- (void)timerCallback {
    NSLog(@"Timer callback");
    [self getNewContact];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
    if ( [elementName isEqualToString:@"id"] ) {
            inID = YES;
        NSLog(@"parsing");
        parsing_id=[[NSMutableString alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( inID ) {
        [parsing_id appendString:string];
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ( [elementName isEqualToString:@"id"] ) {
        inID = NO;
        NSLog(@"%@",parsing_id);
        NSLog(@"done parsing");
        NSLog(@"%@",chat_id);
        [connectingIndicator stopAnimating];
        [_doneButton setEnabled:TRUE];
    }
}

@end
