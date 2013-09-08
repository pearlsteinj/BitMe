//
//  BMAddContactViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/8/13.
//
//

#import <UIKit/UIKit.h>

@interface BMAddContactViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *UID;
@property (strong, nonatomic) IBOutlet UITextField *name;
- (IBAction)add:(id)sender;

@end
