//
//  BMSendViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMSendViewController.h"
#import "UAPush.h"
@interface BMSendViewController ()

@end

@implementation BMSendViewController
@synthesize UID, amount,address;

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
    UIColor* mainColor = [UIColor colorWithRed:52.0/255 green:73.0/255 blue:100.0/255 alpha:1.0f];
    UIColor* secondaryColor = [UIColor colorWithRed:22.0/255 green:160.0/255 blue:133.0/255 alpha:1.0f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    self.navigationController.navigationBar.tintColor = secondaryColor;
}
-(void)viewWillAppear:(BOOL)animated{
    self.UID.text = self.address;
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
        if ([priorBalance floatValue] < [amount.text floatValue]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"You is poor :(" delegate:self cancelButtonTitle:@"I'm a beggar beholden" otherButtonTitles:nil];
            [alert show];
        }
        else if (![snapshot.value objectForKey:UID.text] || [[prefs objectForKey:@"UID"] isEqual:UID.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-Oh" message:@"You is lonely :(" delegate:self cancelButtonTitle:@"Do not pass go, you lonely bastard" otherButtonTitles:nil];
            [alert show];
        }
        else{
            // All my code could look more like below
            // Sorry for the scrappy work
            [[[lookup childByAppendingPath:user] childByAppendingPath:@"balance" ] setValue:[NSString stringWithFormat:@"%f", ([priorBalance floatValue] - [amount.text floatValue])]];
            [[[lookup childByAppendingPath:UID.text] childByAppendingPath:@"balance" ] setValue:[NSString stringWithFormat:@"%f", ([[[snapshot.value objectForKey:UID.text] objectForKey:@"balance"] floatValue] + [amount.text floatValue])]];


            Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com"];
            FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
            
            //Check for Account
            [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
                if (error != nil) {                    
                } else if (user == nil) {
                }
                else{
                    NSString *url = [NSString stringWithFormat:@"http://www.sendgrid.com/api/mail.send.json?to=%@&toname=user&from=peterbbryan%%40gmail.com&fromname=BitMe&subject=You%%20received%%20BitCoins,%%20congratulations!&text=You%%20have%%20received%%20a%%20payment%%20of%%20%@&api_user=peterbbryan&api_key=walletBlock", user.email, amount.text];
                    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
                    // create the connection with the request
                    // and start loading the data
                    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                    
                    [PFPush sendPushMessageToChannelInBackground:[@"a" stringByAppendingString: UID.text] withMessage:@"You have received a payment in BitMe!"];
                   
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sent!" message:@"BitCoins were succesfully transferred!" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                }
            }];
         
            //[self sendPush];
            
            
            
        }
    }];
}






- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
        NSURLCredential * credential = [[NSURLCredential alloc] initWithUser:@"NGKir7QlSImvdr_wUNfpyA" password:@"kGHChRScQBS6lSEczqsIhA" persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
}







-(void)sendPush{
    
    //This feels right and gets a status 200. Why is it not doing anything????
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://go.urbanairship.com/api/push/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"all",  @"audience",
                         @"\"alert\" : \"Hi from Urban Airship!\"", @"notification",
                         @"all", @"device_types",
                         nil];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    [request setHTTPBody:postdata];
    NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:@"NGKir7QlSImvdr_wUNfpyA" password:@"kGHChRScQBS6lSEczqsIhA" persistence:NSURLCredentialPersistenceForSession];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    /*
    NSURL *aUrl = [NSURL URLWithString:@"https://go.urbanairship.com/api/push/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"yourVarialbes=yourvalues";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [connection start];
    

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://go.urbanairship.com/api/push/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *UID = [self UID].text;
    NSString *jsonString =@"{\
    \"audience\" : {\
    \"OR\" : [\
    { \"tag\" : [\"sports\", \"entertainment\"]}\
    ]\
    },\
    \"notification\" : {\
    \"alert\" : \"Hi from Urban Airship!\",\
    },\
    \"device_types\" : [\"ios\"]\
    }\
    ";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *pushdata = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:pushdata];
    NSLog(@"%@",[self stringOutputForDictionary:pushdata]);
    [request setHTTPBody:temp];
    [NSURLConnection connectionWithRequest:request delegate:self];
 */
}

- (void) connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *) challenge {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
        NSURLCredential * credential = [[NSURLCredential alloc] initWithUser:@"NGKir7QlSImvdr_wUNfpyA" password:@"kGHChRScQBS6lSEczqsIhA" persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }

}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
    NSHTTPURLResponse * res = (NSHTTPURLResponse *) response;
    NSLog(@"response: %@",res);
    NSLog(@"res %i\n",res.statusCode);
    NSLog([response description]);
    
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode]) {
        // do error handling here
        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    } else {
        // start recieving data
    }
    
}
-(void)setAddressField:(NSString *)UID{
    self.address = UID;
}
@end
