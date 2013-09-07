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

- (IBAction)send:(id)sender;
@end
