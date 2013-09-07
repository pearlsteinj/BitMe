//
//  BMCashOutViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMCashOutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *availble;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *address;
- (IBAction)cashOut:(id)sender;

@end
