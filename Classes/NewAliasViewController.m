//
//  NewAliasViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/7/14.
//
//

#import "NewAliasViewController.h"
#import "Alias.h"

@interface NewAliasViewController ()
@property NSMutableArray *aliasData;

@end

@implementation NewAliasViewController

@synthesize usageType;
@synthesize randomizeButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != doneButton) return;
    if (inputAlias.text.length > 0) {
        self.make_alias = [[Alias alloc] initwithName:inputAlias.text sly:_sly];
        //self.make_alias.name = self.inputAlias.text;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [inputAlias becomeFirstResponder];
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

-(IBAction)checkAvailable:(id)sender{
    if(inputAlias.text.length>4){
    [_make_alias release];
    [self makeNewAlias:inputAlias.text];
    }
    else{
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Alias Name too short"
                                                           message:@"An Alias must have at least 6 characters."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

//Server Request Data
- (void)makeNewAlias:(NSString *)reqAlias {
    NSLog(@"Check for Alias Availability");
    [aliasIndicator startAnimating];
    NSMutableString *strApplicationUUID = [[NSMutableString alloc]init];
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    [strApplicationUUID setString:[oNSUUID UUIDString]];
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/newalias.php?phone=%@&request=%@",strApplicationUUID,reqAlias];
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
        [aliasIndicator stopAnimating];
        [doneButton setEnabled:TRUE];
    }
}

- (void)dealloc {
    [doneButton release];
    [inputAlias release];
    [nonAvailable release];
    [aliasIndicator release];
    [super dealloc];
}
@end
