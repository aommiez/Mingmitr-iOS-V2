//
//  PFUpdateCell.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PFUpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *detailNewsView;
@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UILabel *detailNews;

@property (weak, nonatomic) IBOutlet AsyncImageView *thumbnails;

@end
