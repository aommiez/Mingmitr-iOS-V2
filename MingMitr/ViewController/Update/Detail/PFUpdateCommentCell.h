//
//  PFUpdateCommentCell.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol PFUpdateCommentCellDelegate <NSObject>

- (void)DidUserId:(NSString *)userId;

@end

@interface PFUpdateCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIButton *imgBut;
@property (assign, nonatomic) id <PFUpdateCommentCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet AsyncImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgComment;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *timeComment;

@end
