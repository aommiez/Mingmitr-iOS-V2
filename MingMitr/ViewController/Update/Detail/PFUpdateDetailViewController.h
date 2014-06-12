//
//  PFUpdateDetailViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"
#import "AsyncImageView.h"
#import "PFUpdateCommentCell.h"
#import "PFLoginViewController.h"
#import <Social/Social.h>

#import "PFMingMitrSDK.h"

@protocol PFUpdateDetailViewControllerDelegate <NSObject>

- (void)PFUpdateDetailViewControllerBack;
- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFUpdateDetailViewController : UIViewController < UITableViewDelegate,UITableViewDataSource,UITextViewDelegate >

@property (assign, nonatomic) id <PFUpdateDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *textCommentView;

@property (retain, nonatomic) PFLoginViewController *loginView;

@property (weak, nonatomic) IBOutlet UILabel *titlenews;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detailnews;
@property (weak, nonatomic) IBOutlet AsyncImageView *detailthumb;

@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;

@property (weak, nonatomic) IBOutlet UIButton *postBut;
@property (weak, nonatomic) IBOutlet UITextView *textComment;

- (IBAction)postCommentTapped:(id)sender;

@end
