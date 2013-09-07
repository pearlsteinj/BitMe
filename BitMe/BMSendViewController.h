//
//  BMSendViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMSendViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *UID;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (nonatomic, retain) FAUser *user;
- (IBAction)send:(id)sender;

@end
