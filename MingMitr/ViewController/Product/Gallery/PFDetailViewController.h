//
//  PFDetailViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"
#import "UILabel+UILabelDynamicHeight.h"
#import "AsyncImageView.h"
#import "SDImageCache.h"
#import <Social/Social.h>

#import "PFMingMitrSDK.h"

@protocol PFDetailViewControllerDelegate <NSObject>

- (void)PFDetailViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *parent_id;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *urlimg;
@property (strong, nonatomic) NSString *shareimg;

@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSDictionary *objdetail;

@property (weak, nonatomic) IBOutlet AsyncImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *baht;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *productdetail;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

- (IBAction)fullimgTapped:(id)sender;

@end
