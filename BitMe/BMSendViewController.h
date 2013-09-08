//
//  BMSendViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMSendViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *UID;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (nonatomic, retain) FAUser *user;
@property (nonatomic,retain) NSString *address;
- (IBAction)send:(id)sender;
-(void)setAddressField:(NSString *)UID;

@end
