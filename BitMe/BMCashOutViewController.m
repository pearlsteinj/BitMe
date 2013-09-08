//
//  BMCashOutViewController.m
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import "BMCashOutViewController.h"
#import "ZBarSDK.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>

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
    UIColor* mainColor = [UIColor colorWithRed:52.0/255 green:73.0/255 blue:100.0/255 alpha:1.0f];
    UIColor* secondaryColor = [UIColor colorWithRed:22.0/255 green:160.0/255 blue:133.0/255 alpha:1.0f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    self.navigationController.navigationBar.tintColor = secondaryColor;
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://bitme.firebaseIO.com/users"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs objectForKey:@"UID"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        available_balance = snapshot.value[user][@"balance"];
        NSLog(@"%@",available_balance);
        available.text = available_balance;
    }];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    //self. tabBarController.selectedViewController = 10;
}

- (void) imagePickerController: (UIImagePickerController *) picker

 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage, *imageToSave;
    
    
    
    // Handle a still image capture
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        
        == kCFCompareEqualTo) {
        
        
        
        editedImage = (UIImage *) [info objectForKey:
                                   
                                   UIImagePickerControllerEditedImage];
        
        originalImage = (UIImage *) [info objectForKey:
                                     
                                     UIImagePickerControllerOriginalImage];
        
        
        
        if (editedImage) {
            
            imageToSave = editedImage;
            
        } else {
            
            imageToSave = originalImage;
            
        }
        
        
        
    }
    
    
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.readerDelegate = self;
    
    //... code to get image
    
    CGImageRef imgCG = imageToSave.CGImage;
    
    id<NSFastEnumeration> results = [reader scanImage:imgCG];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    _address.text = symbol.data;
    
    
    [picker dismissModalViewControllerAnimated: YES];
    
    
}



-(IBAction)takePicture:(id)sender{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller

                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   
                                                   UINavigationControllerDelegate>) delegate {
    
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    
    
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    
    // Displays a control that allows the user to choose picture or
    
    // movie capture, if both are available:
    
    
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_amount resignFirstResponder];
        [_address resignFirstResponder];
    }
}
@end
