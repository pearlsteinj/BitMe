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
@synthesize myAddress,balance;

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
        _address = [[snapshot.value objectForKey:user] objectForKey:@"address"];
        [myAddress setText:_address];
        _bal = [[snapshot.value objectForKey:user] objectForKey:@"balance"];
        [balance setText:_bal];
    }];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)copy:(id)sender {
    NSString *copyStringverse = [[NSString alloc] initWithFormat:@"%@",_address];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
}

- (IBAction)refreshBalance:(id)sender {
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    NSString *url = @"https://blockchain.info/merchant/0eb0d1fc-30fd-4138-80d4-984f9b6b7438/address_balance?password=walletBlock&address=";
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@",_address]];
    url = [url stringByAppendingString:@"&confirmations=0"];                     
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    __block NSURLResponse* theResponse = nil;
    __block NSData *theData = nil;
    NSLog(@"%@",url);

   [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
       theResponse = response;
       theData = data;
       [self updateInfo:data];
    }];    

    
}
-(void)updateInfo:(NSData *)theData{
    NSLog(@"Updating Balance");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSString *totalBalance = dict[@"total_received"];
    NSLog(@"%@",dict[@"balance"]);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        _old_bal = [[snapshot.value objectForKey:user] objectForKey:@"old_amount"];
        _bal = [[snapshot.value objectForKey:user] objectForKey:@"balance"];
        [balance setText:_bal];
        float balFloat = [_bal floatValue];
        float new_bal = [totalBalance floatValue]/100000000;
        float original = [_old_bal floatValue];
        NSLog(@"ORIGINAL: %f . NEW BAL: %f balFloat: %f",original,new_bal,balFloat);
        if(new_bal != original){
            float amountToAdd = new_bal - original;
            balFloat += amountToAdd;
            Firebase *userToChange = [ref childByAppendingPath:[NSString stringWithFormat:@"%@",user]];
            [[userToChange childByAppendingPath:@"balance"] setValue:[NSString stringWithFormat:@"%f", balFloat]];
            [[userToChange childByAppendingPath:@"old_amount"] setValue:[NSString stringWithFormat:@"%f", new_bal]];
            _bal = [[snapshot.value objectForKey:user] objectForKey:@"balance"];
        }
        
    }];
}
@end
