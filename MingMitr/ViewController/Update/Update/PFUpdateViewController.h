//
//  PFUpdateViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "BBBadgeBarButtonItem.h"
#import "UIERealTimeBlurView.h"
#import "MWPhotoBrowser.h"
#import "AFNetworking.h"

#import "PFUpdateCell.h"
#import "PFLoginViewController.h"
#import "PFUpdateDetailViewController.h"
#import "PFNotificationViewController.h"
#import "PFAccountViewController.h"

#import "PFMingMitrSDK.h"

@protocol PFUpdateViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFUpdateViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,PFNotificationViewControllerDelegate,PFUpdateDetailViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic  ) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIERealTimeBlurView *blur;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@property (retain, nonatomic) PFLoginViewController *loginView;

@property (retain, nonatomic) NSString *paging;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
