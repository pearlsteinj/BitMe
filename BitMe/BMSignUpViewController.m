//
//  BMSignUpViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMSignUpViewController.h"
#include <stdlib.h>
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
                              Firebase *fire = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/"];
                              Firebase *users = [fire childByAppendingPath:@"users"];
                              unsigned int UID = [self generateUID];
                              Firebase *new_user = [users childByAppendingPath:[NSString stringWithFormat:@"%u",UID]];
                              Firebase *balance = [new_user childByAppendingPath:@"balance"];
                              [balance setValue:@"0"];
                              Firebase *lookup = [fire childByAppendingPath:@"lookup"];
                              Firebase *new_entry = [lookup childByAppendingPath:[NSString stringWithFormat:@"%u",UID]];
                              [new_entry setValue:[user email]];
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }
                      }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Password fields aren't the same!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
-(unsigned int)generateUID{
    unsigned int UID = (arc4random()%999999)+1;
    NSLog(@"%uf",UID);
    return UID;
}

@end
