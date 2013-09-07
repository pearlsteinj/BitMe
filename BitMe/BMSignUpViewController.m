//
//  BMSignUpViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMSignUpViewController.h"

@interface BMSignUpViewController ()

@end

@implementation BMSignUpViewController
@synthesize userName,password,password_verify;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize Firebase
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    _authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    if([password_verify.text isEqualToString:password.text]){
        [_authClient createUserWithEmail:userName.text password:password.text
                      andCompletionBlock:^(NSError* error, FAUser* user) {
                          
                          if (error != nil) {
                              NSLog(@"Seems not to work...");
                              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                              [alert show];
                          } else {
                              NSLog(@"Seems to work...");
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }
                      }];
    }
    else{
        NSLog(@"The user's a dumbass...");
    }
}
@end
