//
//  BMLoginViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMLoginViewController.h"

@interface BMLoginViewController ()

@end

@implementation BMLoginViewController
@synthesize userName,password;
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
    
    
    //Initializing Firebase
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    _authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    [_authClient loginWithEmail:userName.text andPassword:password.text
           withCompletionBlock:^(NSError* error, FAUser* user) {
               
               if (error != nil) {
                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                   [alert show];
               } else {
                   [self dismissViewControllerAnimated:YES completion:nil];
               }
           }];
    
}
@end
