//
//  BMContactsViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/8/13.
//
//

#import <UIKit/UIKit.h>

@interface BMContactsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSDictionary *contacts;
@end
