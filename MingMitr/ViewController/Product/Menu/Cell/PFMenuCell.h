//
//  PFMenuCell.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PFMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *thumbmenu;
@property (weak, nonatomic) IBOutlet UILabel *namemenu;

@end
