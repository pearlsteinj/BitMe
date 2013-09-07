//
//  BMAddressViewController.h
//  BitMe
//
//  Created by Peter Bryan on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (nonatomic,retain) NSString *address;
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (nonatomic,retain) NSString *bal;
@property (nonatomic,retain) NSString *old_bal;
- (IBAction)copy:(id)sender;
- (IBAction)refreshBalance:(id)sender;

@end
