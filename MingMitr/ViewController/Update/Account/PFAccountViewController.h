//
//  PFAccountViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIERealTimeBlurView.h"
#import "AsyncImageView.h"
#import "SDImageCache.h"
#import "PFEditViewController.h"

#import "PFMingMitrSDK.h"

@protocol PFAccountViewControllerDelegate <NSObject>

- (void)PFAccountViewControllerBack;
- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFAccountViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *formView;
@property UIERealTimeBlurView *blur;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet AsyncImageView *thumUser;

@property (strong, nonatomic) IBOutlet UITextField *displayname;
@property (strong, nonatomic) IBOutlet UILabel *facebook;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *phone;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

- (IBAction)fullimgTapped:(id)sender;
- (IBAction)logoutTapped:(id)sender;

- (IBAction)switchNewsonoff:(id)sender;
- (IBAction)switchMessageonoff:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *switchNews;
@property (strong, nonatomic) IBOutlet UISwitch *switchMessage;

@end
