//
//  SlyAccountViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import "SlyAccountViewController.h"
#import "SlyDatabase.h"
#import "SlyAccount.h"

@interface SlyAccountViewController ()

@end

@implementation SlyAccountViewController

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
    // Do any additional setup after loading the view.
}
- (IBAction)login:(id)sender {
    name =[_accountEditField.text copy];
    pass = [_passwordEditField.text copy];
    [self makeNewAlias:name pass:pass];
    [_aliasIndicator startAnimating];
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

//Server Request Data
- (void)makeNewAlias:(NSString *)Alias pass:(NSString *)pass {
    NSLog(@"Check for Alias Availability");
    NSMutableString *strApplicationUUID = [[NSMutableString alloc]init];
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    [strApplicationUUID setString:[oNSUUID UUIDString]];
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/login.php?phone=%@&Slyname=%@&Pass=%@",strApplicationUUID,Alias,pass];
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

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
    if ( [elementName isEqualToString:@"sucess"] ) {
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( inID ) {
        [parsing_id appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ( [elementName isEqualToString:@"success"] ) {
        NSLog(@"done conencting");
        [_aliasIndicator stopAnimating];
        [SlyDatabase save:[[SlyAccount alloc]initwithName:name]];
        [self performSegueWithIdentifier: @"login" sender: self];
    }
}

- (void)dealloc {
    [_accountEditField release];
    [_passwordEditField release];
    [_accountLabel release];
    [_aliasIndicator release];
    [super dealloc];
}
@end
