//
//  BMSendViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMSendViewController.h"

@interface BMSendViewController ()

@end

@implementation BMSendViewController
@synthesize UID, amount;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    NSString *url = @"https://bitme.firebaseIO.com/users";
    Firebase* lookup = [[Firebase alloc] initWithUrl:url];
    
    
    [lookup observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *priorBalance = [[snapshot.value objectForKey:user] objectForKey:@"balance"];
        if ([priorBalance integerValue] < [amount.text integerValue]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"You is poor :(" delegate:self cancelButtonTitle:@"I'm a beggar beholden" otherButtonTitles:nil];
            [alert show];
        }
        else if (![snapshot.value objectForKey:UID.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"You is lonely :(" delegate:self cancelButtonTitle:@"Do not pass go, you lonely bastard" otherButtonTitles:nil];
            [alert show];
        }
        else{
            // All my code could look more like below
            // Sorry for the scrappy work
            [[[lookup childByAppendingPath:user] childByAppendingPath:@"balance" ] setValue:[NSString stringWithFormat:@"%i", ([priorBalance integerValue] - [amount.text integerValue])]];
            [[[lookup childByAppendingPath:UID.text] childByAppendingPath:@"balance" ] setValue:[NSString stringWithFormat:@"%i", ([[[snapshot.value objectForKey:UID.text] objectForKey:@"balance"] integerValue] + [amount.text integerValue])]];
        }
    }];
    
}


@end
