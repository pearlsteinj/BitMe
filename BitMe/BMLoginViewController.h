//
//  BMLoginViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, retain) FirebaseSimpleLogin *authClient;
- (IBAction)logIn:(id)sender;

@end
