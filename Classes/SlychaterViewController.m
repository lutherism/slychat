//
//  SlychaterViewController.m
//  slychat
//
//  Created by Alexander Jansen on 4/9/14.
//
//

#import "SlychaterViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "ContactTableViewController.h"
#import "SlyDatabase.h"


@interface SlychaterViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    NSMutableArray *bubbleData;
}

@end

@implementation SlychaterViewController

-(void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bubbleTable.bubbleDataSource = self;
    _contact = [[SlyDatabase loadSly]getContactWithName:_contactname];
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    [self getNewMessages];
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateRoot" object:nil];
    [self getNewMessages];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
								[self methodSignatureForSelector: @selector(timerCallback)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timerCallback)];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0
										 invocation:invocation repeats:NO];
}
- (void)timerCallback {
    NSLog(@"Timer callback");
    [self getNewMessages];
}
-(void)updateView:(NSObject *)nill{
    SlyAccount *sly = [SlyDatabase loadSly];
    _contact = [sly getContactWithName:[_contact getPartnerName]];
    [bubbleTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:
                     @"http://slychat.openrobot.net/add.php"];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]
                                     init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *urli = [NSString stringWithFormat:@"user=%@&message=%@&conv=%@",[[_contact getMyAlias]getName],textField.text, [_contact getChatID]];
    [body appendData:[urli dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = [[[NSError alloc] init] autorelease];
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:&error];
    NSLog(@"%@",urli);

    [self getNewMessages];
    [bubbleTable reloadData];
    
    textField.text = @"";
    [textField resignFirstResponder];
}

//Server Request Methods

- (void)getNewMessages {
    NSLog(@"Get Messages");
    if(bubbleData)[bubbleData release];
    bubbleData = [[NSMutableArray alloc]init];
    NSArray *messages = [_contact getMessages];
    for(Message *m in messages)
    {
        if([[m getSender] isEqualToString:[_contact getPartnerName]]) [bubbleData addObject:[NSBubbleData dataWithText:[m getText] date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse]];
        else [bubbleData addObject:[NSBubbleData dataWithText:[m getText] date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeMine]];
    }
}
/*
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
    if ( bubbleData == nil )
        bubbleData = [[NSMutableArray alloc] init];
	
    if(receivedData)chatParser = [[NSXMLParser alloc] initWithData:receivedData];
    else NSLog(@"error: connecitonDidFinishLoading var receivedData");
    [chatParser setDelegate:self];
    [chatParser parse];
	
    [receivedData release];
	
    [bubbleTable reloadData];
	
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
								[self methodSignatureForSelector: @selector(timerCallback)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timerCallback)];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0
										 invocation:invocation repeats:NO];
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
        if([msgUser isEqualToString:[[_contact getMyAlias]getName]]) [bubbleData addObject:[NSBubbleData dataWithText:msgText date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeMine]];
        else [bubbleData addObject:[NSBubbleData dataWithText:msgText date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse]];
		
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
*/


@end

