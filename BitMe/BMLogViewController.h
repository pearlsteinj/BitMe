//
//  BMLogViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/8/13.
//
//

#import <UIKit/UIKit.h>

@interface BMLogViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *top_bar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSDictionary *entries; 
@end
