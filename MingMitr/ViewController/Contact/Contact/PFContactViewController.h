//
//  PFContactViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFMingMitrSDK.h"

#import "PFContactCell.h"
#import "PFWebViewController.h"
#import "PFAllMapViewController.h"
#import "PFMapViewController.h"

#import "CRGradientNavigationBar.h"
#import "DLImageLoader.h"
#import "AsyncImageView.h"
#import <MessageUI/MessageUI.h>

@protocol MMContactViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFContactViewController : UIViewController <MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,PFWebViewControllerDelegate,PFAllmapViewControllerDelegate,PFMapViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic  ) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *imgscrollview;
@property (nonatomic, assign) NSInteger countrow;

@property (weak, nonatomic) IBOutlet AsyncImageView *mapImage;
@property (strong, nonatomic) IBOutlet UILabel *locationinfo;

- (IBAction)emailTapped:(id)sender;
- (IBAction)webTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;
- (IBAction)powerbyTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (strong, nonatomic) NSString *cellSize;
@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;

@property (strong, nonatomic) IBOutlet UIView *footView;

@property (retain, nonatomic) NSMutableArray *arrcontactimg;
@property (strong, nonatomic) NSString *current;

@end
