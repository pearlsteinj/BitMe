//
//  BMMainViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMMainViewController.h"

@interface BMMainViewController ()

@end

@implementation BMMainViewController
@synthesize balance;
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
    //Initialize FireBase
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    __block NSString *UID = [[NSString alloc]init];
    //Check for Account
    NSLog(@"HERE");
    [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"Something Bad Happened :(" delegate:self cancelButtonTitle:@"Ok!!! I forgive you" otherButtonTitles:nil];
            [alert show];
            
        } else if (user == nil) {
            [self performSegueWithIdentifier:@"logIn" sender:self];        
        }
        else{
            Firebase *lookup = [ref childByAppendingPath:@"lookup"];
            //UID = [lookup valueForKey:[user userId]];
            [lookup observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                UID = snapshot.value[[user userId]];
            }];
            Firebase *user = [ref childByAppendingPath:@"users"];
            [user observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                balance.text = snapshot.value[[NSString stringWithFormat:@"%@",UID]][@"balance"];
            }];
        }
    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
