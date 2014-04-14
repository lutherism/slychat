//
//  SlychaterViewController.h
//  slychat
//
//  Created by Alexander Jansen on 4/9/14.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "Contact.h"
#import "MessageDatabase.h"

@interface SlychaterViewController : UIViewController <UIBubbleTableViewDataSource>{

NSMutableData *receivedData;

NSTimer *timer;
}

@property (nonatomic,retain) Contact* contact;

@end
