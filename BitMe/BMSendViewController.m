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
        if ([priorBalance floatValue] < [amount.text floatValue]){
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
                    NSString *url = [NSString stringWithFormat:@"http://www.sendgrid.com/api/mail.send.json?to=peterbbryan%%40gmail.com&toname=user&from=%@&fromname=BitMe&subject=You%%20received%%20BitCoins,%%20congratulations!&text=You%%20have%%20received%%20a%%20payment%%20of%%20%@&api_user=peterbbryan&api_key=walletBlock", user.email, amount.text];
                    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
                    // create the connection with the request
                    // and start loading the data
                    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                }
            }];
         
            [self sendPush];
            
        }
    }];
}

-(void)sendPush{
    
    //This feels right and gets a status 200. Why is it not doing anything????
    
    
    NSURL *aUrl = [NSURL URLWithString:@"https://go.urbanairship.com/api/push/broadcast/?message=one&audience=all&device_types=all"];
    
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"all",  @"audience",
                        @"onepingandonepingonlyplease", @"message",
                        @"all", @"device_types",
                         nil];
    NSError *error;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection start];
    
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
- (NSString *)stringOutputForDictionary:(NSDictionary *)inputDict {
    NSMutableString * outputString = [NSMutableString stringWithCapacity:256];
    
    NSArray * allKeys = [inputDict allKeys];
    
    for (NSString * key in allKeys) {
        if ([[inputDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            [outputString appendString: [self stringOutputForDictionary: (NSDictionary *)inputDict]];
        }
        else {
            [outputString appendString: key];
            [outputString appendString: @": "];
            [outputString appendString: [[inputDict objectForKey: key] description]];
        }
        [outputString appendString: @"\n"];
    }
    
    return [NSString stringWithString: outputString];
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
@end
