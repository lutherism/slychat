//
//  checkForRequests.m
//  slychat
//
//  Created by Alexander Jansen on 4/11/14.
//
//

#import "checkForRequests.h"

@implementation checkForRequests


- (void)viewDidLoad
{
    [super viewDidLoad];
    _contacts = [[NSMutableArray alloc]init];
    [self getRequests];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected request");
    NSLog(@"%@",[_contacts description]);
    Contact *c = [_contacts objectAtIndex:indexPath.row];
    //[ContactDatabase save:c];
    //[requestList cellForRowAtIndexPath:indexPath.row].accessoryType = UITableViewCellAccessoryCheckmark;
    [self acceptRequests:c];
    [_contacts removeObjectAtIndex:indexPath.row];
    [requestList reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Contact *contacted = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contacted.partner;
    cell.detailTextLabel.text = [contacted.alias getName];
    return cell;
}


//Server Request Data
- (void)getRequests {
    NSLog(@"Get Messages");
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/requests.php?me=%@",
					 [_checkThis getName]];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        receivedData = [[NSMutableData data] retain];
        [parsing_id release];
        [parsing_user release];
        NSLog(@"Connection Made");
    }
    else
    {
    }
}

- (void)acceptRequests:(Contact *)cid {
    NSLog(@"Accept Request");
    NSLog(@"%@",[cid getName]);
    NSString *url = [NSString stringWithFormat:
					 @"http://slychat.openrobot.net/requests.php?accept=yes&convid=%@",
					 [cid getChatID]];
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
    request = YES;
    [requestList reloadData];
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
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = YES;
        NSLog(@"parsing");
        parsing_user=[[NSMutableString alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( inID ) {
        [parsing_id appendString:string];
    }
    if ( inUser ) {
        [parsing_user appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ( [elementName isEqualToString:@"id"] ) {
        inID = NO;
        NSLog(@"%@",parsing_id);
        NSLog(@"done parsing");
    }
    if ( [elementName isEqualToString:@"user"] ) {
        inUser = NO;
        NSLog(@"%@",parsing_user);
        NSLog(@"done parsing");
    }
    if ( [elementName isEqualToString:@"conversation"] ) {
        Contact *newContact = [[Contact alloc]initwithAlias:parsing_user myAlias:_checkThis chat_id:[NSNumber numberWithInteger:[parsing_id integerValue]]];
        NSLog(@"%@",[NSString stringWithFormat:@"request from %@",parsing_user]);
        [_contacts addObject:newContact];
    }
}

- (void)dealloc {
    [requestList release];
    [_contacts release];
    [super dealloc];
}
@end
