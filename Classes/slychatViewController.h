//
//  slychatViewController.h
//  slychat
//
//  Created by Alexander Jansen on 3/23/14.
//  Copyright Cuesta College 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slychatViewController : UIViewController <NSXMLParserDelegate, UITableViewDataSource,UITableViewDelegate> {

	IBOutlet UITextField *messageText;
    IBOutlet UIBarButtonItem *sendButton;
    IBOutlet UITableView *messageList;
    IBOutlet UIToolbar *messageBar;
	
    NSMutableData *receivedData;
    long lastId;
	
    NSTimer *timer;
	
    NSXMLParser *chatParser;
    NSString *msgAdded;
    NSMutableString *msgUser;
    NSMutableString *msgText;
    int msgId;
    Boolean inText;
    Boolean inUser;
	
}

@property (nonatomic,retain) UITextField *messageText;
@property (nonatomic,retain) UIBarButtonItem *sendButton;
@property (nonatomic,retain) UITableView *messageList;

- (IBAction)sendClicked:(id)sender;

@end

