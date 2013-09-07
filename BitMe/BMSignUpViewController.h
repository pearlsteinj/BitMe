//
//  BMSignUpViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMSignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *password_verify;
@property (nonatomic,retain) FirebaseSimpleLogin *authClient;
- (IBAction)signUp:(id)sender;

@end
