//
//  PFRewardViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMingMitrSDK.h"

@protocol PFRewardViewControllerDelegate <NSObject>

- (void) PFRewardViewControllerBack;

@end

@interface PFRewardViewController : UIViewController

@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;

@property (assign, nonatomic) id<PFRewardViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
