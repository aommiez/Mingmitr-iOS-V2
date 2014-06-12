//
//  PFMenuViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "UIERealTimeBlurView.h"
#import "CustomNavigationBar.h"
#import "AMBlurView.h"

#import "PFMenuCell.h"
#import "PFDetailCell.h"
#import "PFFranchiseCell.h"
#import "PFF1ViewController.h"
#import "PFD1ViewController.h"

#import "PFMingMitrSDK.h"

@protocol PFMenuViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFMenuViewController : UIViewController <UINavigationControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic  ) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;
@property (strong, nonatomic) IBOutlet UIView *MenuTop;
@property (strong, nonatomic) IBOutlet UIView *footview;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;

@property (retain, nonatomic) NSString *paging;

@end
