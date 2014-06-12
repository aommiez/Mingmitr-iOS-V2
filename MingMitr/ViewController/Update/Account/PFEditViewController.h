//
//  PFEditViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMingMitrSDK.h"

@protocol PFEditViewControllerDelegate <NSObject>

- (void)PFEditViewControllerBack;

@end

@interface PFEditViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *token;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSString *url;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
