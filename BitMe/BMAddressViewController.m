//
//  BMAddressViewController.m
//  BitMe
//
//  Created by Peter Bryan on 9/7/13.
//
//

#import "BMAddressViewController.h"

@interface BMAddressViewController ()

@end

@implementation BMAddressViewController
@synthesize myAddress;

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
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *address = [[snapshot.value objectForKey:user] objectForKey:@"address"];
        [myAddress setText:address];
    }];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
