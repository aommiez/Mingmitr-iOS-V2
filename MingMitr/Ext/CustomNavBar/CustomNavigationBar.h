//
//  CustomNavigationBar.h
//  ONLY
//
//  Created by Soemsak Loetphornphisit on 2/16/12.
//  Copyright (c) 2012 EVERFID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CustomNavigationBar : UINavigationBar

@property (nonatomic, retain) UIImageView *navigationBarBackgroundImage;

-(void) setBackgroundWith:(UIImage*)backgroundImage;
-(void) clearBackground;

-(UIButton*) backButtonWith:(UIImage*)backButtonImage
                  highlight:(UIImage*)backButtonHighlightImage
               leftCapWidth:(CGFloat)capWidth;

-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;

- (UIButton*)backButtonWith:(UIImage*)backButtonImage
                  highlight:(UIImage*)backButtonHighlightImage
               leftCapWidth:(CGFloat)capWidth
                    setText:(NSString*)text
                  addTarget:(id)target
                     action:(SEL)action
        forControlEvents:(UIControlEvents)controlEvents;

@end
