//
//  PFNotificationViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"
#import "PFUpdateDetailViewController.h"
#import "PFNotificationCell.h"

#import "PFMingMitrSDK.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFNotificationViewControllerBack;
- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFNotificationViewController : UIViewController <PFUpdateDetailViewControllerDelegate>

@property AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (assign, nonatomic) id<PFNotificationViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSMutableArray *arrObjNotify;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSDictionary *objNotify;
@property (strong, nonatomic) NSString *nString;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) IBOutlet AMBlurView *blurView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
