//
//  PFMemberViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIERealTimeBlurView.h"
#import "CRGradientNavigationBar.h"
#import "DLImageLoader.h"

#import "PFLoginViewController.h"
#import "PFRewardViewController.h"

#import "PFMingMitrSDK.h"

@protocol PFMemberViewControllerDelegate <NSObject>

- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFMemberViewController : UIViewController <UINavigationControllerDelegate,PFRewardViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic  ) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (retain, nonatomic) PFLoginViewController *loginView;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *addPointView;
@property (strong, nonatomic) IBOutlet UIView *amountFinishView;
@property (strong, nonatomic) IBOutlet UIView *amountFailView;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIButton *addPointButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *amountFinishButton;
@property (strong, nonatomic) IBOutlet UIButton *rewardButton;

@property (strong, nonatomic) IBOutlet UIButton *removeAmountButton;
@property (strong, nonatomic) IBOutlet UIButton *addAmountButton;

- (IBAction)bgTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)addPointTapped:(id)sender;
- (IBAction)removeAmountTapped:(id)sender;
- (IBAction)addAmountTapped:(id)sender;
- (IBAction)confirmTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)amountFinishOkTapped:(id)sender;
- (IBAction)FailTapped:(id)sender;
- (IBAction)rewardTapped:(id)sender;

- (IBAction)hideKeyboard:(id)sender;

@property (strong, nonatomic) NSString *sumamount;

@property (strong, nonatomic) IBOutlet UILabel *point;
@property (strong, nonatomic) IBOutlet UILabel *showpoint;
@property (strong, nonatomic) IBOutlet UILabel *finishamount;

@property (retain, nonatomic) IBOutlet UIView *bgpoint;
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIImageView *poster;

@property (strong, nonatomic) NSString *stampurl;

@property (strong, nonatomic) IBOutlet UIImageView *stamp1;
@property (strong, nonatomic) IBOutlet UIImageView *stamp2;
@property (strong, nonatomic) IBOutlet UIImageView *stamp3;
@property (strong, nonatomic) IBOutlet UIImageView *stamp4;
@property (strong, nonatomic) IBOutlet UIImageView *stamp5;
@property (strong, nonatomic) IBOutlet UIImageView *stamp6;
@property (strong, nonatomic) IBOutlet UIImageView *stamp7;
@property (strong, nonatomic) IBOutlet UIImageView *stamp8;
@property (strong, nonatomic) IBOutlet UIImageView *stamp9;
@property (strong, nonatomic) IBOutlet UIImageView *stamp10;

@property (strong, nonatomic) IBOutlet UIImageView *light1;
@property (strong, nonatomic) IBOutlet UIImageView *light2;
@property (strong, nonatomic) IBOutlet UIImageView *light3;
@property (strong, nonatomic) IBOutlet UIImageView *light4;
@property (strong, nonatomic) IBOutlet UIImageView *light5;
@property (strong, nonatomic) IBOutlet UIImageView *light6;
@property (strong, nonatomic) IBOutlet UIImageView *light7;
@property (strong, nonatomic) IBOutlet UIImageView *light8;
@property (strong, nonatomic) IBOutlet UIImageView *light9;
@property (strong, nonatomic) IBOutlet UIImageView *light10;

@property (strong, nonatomic) IBOutlet UILabel *num1;
@property (strong, nonatomic) IBOutlet UILabel *num2;
@property (strong, nonatomic) IBOutlet UILabel *num3;
@property (strong, nonatomic) IBOutlet UILabel *num4;
@property (strong, nonatomic) IBOutlet UILabel *num5;
@property (strong, nonatomic) IBOutlet UILabel *num6;
@property (strong, nonatomic) IBOutlet UILabel *num7;
@property (strong, nonatomic) IBOutlet UILabel *num8;
@property (strong, nonatomic) IBOutlet UILabel *num9;
@property (strong, nonatomic) IBOutlet UILabel *num10;

@end
