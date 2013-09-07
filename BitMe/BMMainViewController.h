//
//  BMMainViewController.h
//  BitMe
//
//  Created by Josh Pearlstein on 9/7/13.
//
//

#import <UIKit/UIKit.h>

@interface BMMainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (nonatomic, retain) FAUser *user;
@property (weak, nonatomic) IBOutlet UILabel *myUID;

@end
