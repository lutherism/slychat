//
//  slychatViewController.m
//  slychat
//
//  Created by Alexander Jansen on 3/23/14.
//  Copyright Cuesta College 2014. All rights reserved.
//

#import "slychatViewController.h"

@interface slychatViewController ()

@property NSMutableArray *messages;

@end


@implementation slychatViewController

@synthesize messageText, sendButton, messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        lastId = 0;
        chatParser = NULL;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [sendButton release];
    [messageBar release];
    [chatParser release];
    [receivedData release];
    [super dealloc];
}

- (void)getNewMessages {
    NSLog(@"Get Messages");
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/messages.php?past=%ld&t=%ld",
					 lastId, time(0) ];
	
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
	
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
    NSLog(@"Got Messages");
    if (chatParser)
        [chatParser release];
    if ( self.messages == nil )
        self.messages = [[NSMutableArray alloc] init];
	
    chatParser = [[NSXMLParser alloc] initWithData:receivedData];
    [chatParser setDelegate:self];
    [chatParser parse];
	
    [receivedData release];
	
    [messageList reloadData];
	
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
								[self methodSignatureForSelector: @selector(timerCallback)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timerCallback)];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0
										 invocation:invocation repeats:NO];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"Raise Field");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = messageList.frame;
    CGRect textRect = messageBar.frame;
    bkgndRect.size.height -= kbSize.height;
    textRect.origin.y -= kbSize.height;
    [messageList setFrame:bkgndRect];
    [messageBar setFrame:textRect];
    [messageList setContentOffset:CGPointMake(0.0, messageText.frame.origin.y+kbSize.height) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = messageList.frame;
    bkgndRect.size.height += kbSize.height;
    CGRect textRect = messageBar.frame;
    textRect.origin.y += kbSize.height;
    [messageList setFrame:bkgndRect];
    [messageBar setFrame:textRect];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    messageList.contentInset = contentInsets;
    messageList.scrollIndicatorInsets = contentInsets;
}


- (void)timerCallback {
    NSLog(@"Timer callback");
    [self getNewMessages];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict {
    if ( [elementName isEqualToString:@"message"] ) {
        msgAdded = [[attributeDict objectForKey:@"added"] retain];
        msgId = [[attributeDict objectForKey:@"id"] intValue];
        msgUser = [[NSMutableString alloc] init];
        msgText = [[NSMutableString alloc] init];
        inUser = NO;
        inText = NO;
    }
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = YES;
    }
    if ( [elementName isEqualToString:@"text"] ) {
        inText = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( inUser ) {
        [msgUser appendString:string];
    }
    if ( inText ) {
        [msgText appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ( [elementName isEqualToString:@"message"] ) {
        [self.messages addObject:[NSDictionary dictionaryWithObjectsAndKeys:msgAdded,
							 @"added",msgUser,@"user",msgText,@"text",nil]];
		
        lastId = msgId;
		
        [msgAdded release];
        [msgUser release];
        [msgText release];
    }
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = NO;
    }
    if ( [elementName isEqualToString:@"text"] ) {
        inText = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Reload Table Sections");

    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:
(NSInteger)section {
    NSLog(@"Reload Table Size");
    return ( self.messages == nil ) ? 0 : [self.messages count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Reload Table");
    UITableViewCell *cell = (UITableViewCell *)[self.messageList 
												dequeueReusableCellWithIdentifier:@"ChatListItem"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatListItem" 
													 owner:self options:nil];

        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    NSDictionary *itemAtIndex = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
    if(itemAtIndex != nil){
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    textLabel.text = [itemAtIndex objectForKey:@"text"];
    UILabel *userLabel = (UILabel *)[cell viewWithTag:2];
    userLabel.text = [itemAtIndex objectForKey:@"user"];
	}
    return cell;
}

- (IBAction)sendClicked:(id)sender {
    [messageText resignFirstResponder];
    NSLog(@"Send Clicked");
    if ( [messageText.text length] > 0 ) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
        NSString *url = [NSString stringWithFormat:
						 @"http://slychat.openrobot.net/add.php"];
		
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] 
										 init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
		
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"user=%@&message=%@", 
						   [defaults stringForKey:@"user_preference"], 
						   messageText.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
		
        NSHTTPURLResponse *response = nil;
        NSError *error = [[[NSError alloc] init] autorelease];
        [NSURLConnection sendSynchronousRequest:request 
							  returningResponse:&response error:&error];
		
        [self getNewMessages];
    }
	
    messageText.text = @"";
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    messageList.dataSource = self;
    messageList.delegate = self;
    self.messages = [[NSMutableArray alloc] init];
	[self registerForKeyboardNotifications];
    [self getNewMessages];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


@end
