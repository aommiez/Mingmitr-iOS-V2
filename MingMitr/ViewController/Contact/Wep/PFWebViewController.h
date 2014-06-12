//
//  PFWebViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFWebViewControllerDelegate <NSObject>

- (void) PFWebViewControllerBack;

@end

@interface PFWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) id<PFWebViewControllerDelegate> delegate;
@property NSString *url;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
