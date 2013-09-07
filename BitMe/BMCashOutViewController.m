//
//  BMCashOutViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMCashOutViewController.h"

@interface BMCashOutViewController ()

@end

@implementation BMCashOutViewController
@synthesize available_balance,available;
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
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        available_balance = snapshot.value[user][@"balance"];
        NSLog(@"%@",available_balance);
        available.text = available_balance;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cashOut:(id)sender {
    float tempAmount = [_amount.text floatValue]*100000000;
    NSString *amount = [NSString stringWithFormat:@"%.0f",tempAmount];
    NSString *address =_address.text;
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    
        available_balance = snapshot.value[user][@"balance"];
        NSLog(@"%@",available_balance);
        available.text = available_balance;
    }];
    
    if([amount floatValue] <= [available_balance floatValue]*100000000){
        NSString *url = @"https://blockchain.info/merchant/0eb0d1fc-30fd-4138-80d4-984f9b6b7438/payment?password=walletBlock&to=";
        url = [url stringByAppendingString:address];
        url = [url stringByAppendingString:@"&amount="];
        url = [url stringByAppendingString:amount];
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
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:[NSString stringWithFormat:@"%@ \n Transaction Hash: %@",dict[@"notice"], dict[@"tx_hash"]] delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
            [alert show];
        }];    
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Impossible." message:@"You can not cash-out more than you own..." delegate:self cancelButtonTitle:@"Ugh Fine :(" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
