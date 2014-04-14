//
//  checkForRequests.h
//  slychat
//
//  Created by Alexander Jansen on 4/11/14.
//
//

#import <Foundation/Foundation.h>
#import "Alias.h"
#import "Contact.h"

@interface checkForRequests : UITableViewController <UITableViewDataSource,UITableViewDelegate, NSXMLParserDelegate> {
    NSXMLParser *chatParser;
    NSMutableData *receivedData;
    BOOL *inID;
    BOOL *inUser;
    BOOL *request;
    IBOutlet UITableView *requestList;
    
    NSInteger num_requests;
    NSMutableString *parsing_id;
    NSMutableString *parsing_user;
}

@property (nonatomic,retain) Alias *checkThis;
@property (nonatomic, retain) NSMutableArray *contacts;

@end
