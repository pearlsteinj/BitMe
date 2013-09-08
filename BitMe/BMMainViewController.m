//
//  BMMainViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMMainViewController.h"
#import "UAPush.h"
@interface BMMainViewController ()

@end

@implementation BMMainViewController
@synthesize balance, myUID;

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
    UIColor* mainColor = [UIColor colorWithRed:52.0/255 green:73.0/255 blue:100.0/255 alpha:1.0f];
    UIColor* secondaryColor = [UIColor colorWithRed:22.0/255 green:160.0/255 blue:133.0/255 alpha:1.0f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    self.navigationController.navigationBar.tintColor = secondaryColor;
    
    
    //Initialize FireBase
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
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
            self.user = user;
            [self updateInfo];
        }
    }];

    
}
-(void)viewWillAppear:(BOOL)animated{
    //Initialize FireBase
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    //Check for Account
    [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"Something Bad Happened :(" delegate:self cancelButtonTitle:@"Ok!!! I forgive you" otherButtonTitles:nil];
            [alert show];
            
        } else if (user == nil) {
            [self performSegueWithIdentifier:@"logIn" sender:self];
        }
        else{
            self.user = user;
            [self updateInfo];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateInfo{
    __block NSString *UID = [[NSString alloc]init];
    [[UAPush shared] addTagToCurrentDevice:UID];
    [[UAPush shared] updateRegistration];
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
    Firebase *lookup = [ref childByAppendingPath:@"lookup"];
    [lookup observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        UID = snapshot.value[[self.user userId]];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [myUID setText:UID];
        myUID.textColor = [UIColor whiteColor];
        myUID.textAlignment = NSTextAlignmentRight;
        
        [prefs setObject:UID forKey:@"UID"];
    }];
    Firebase *user = [ref childByAppendingPath:@"users"];
    [user observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        balance.text = snapshot.value[[NSString stringWithFormat:@"%@",UID]][@"balance"];
        balance.textAlignment = NSTextAlignmentRight;
        balance.textColor = [UIColor whiteColor];
        
    }];
    
}
@end
