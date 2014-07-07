//
//  PFF2ViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFMingMitrSDK.h"

#import "PFMenuCell.h"
#import "PFDetailCell.h"
#import "PFF1ViewController.h"
#import "PFD1ViewController.h"

@protocol PFF2ViewControllerBackDelegate <NSObject>

- (void)PFF2ViewControllerBack;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;

@end

@interface PFF2ViewController : UIViewController < UITableViewDelegate,UITableViewDataSource >

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
