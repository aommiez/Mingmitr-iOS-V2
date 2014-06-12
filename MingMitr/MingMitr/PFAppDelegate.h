//
//  PFAppDelegate.h
//  MingMitr
//
//  Created by MRG on 6/11/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFTabBarViewController.h"

#import "PFMingMitrSDK.h"

#import "PFUpdateViewController.h"
#import "PFMenuViewController.h"
#import "PFMemberViewController.h"
#import "PFContactViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface PFAppDelegate : UIResponder < UIApplicationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate >

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PFTabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFMenuViewController *menu;
@property (strong, nonatomic) PFMemberViewController *member;
@property (strong, nonatomic) PFContactViewController *contact;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;

@end
