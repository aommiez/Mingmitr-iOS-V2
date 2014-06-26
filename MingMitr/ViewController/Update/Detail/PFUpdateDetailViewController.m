//
//  PFUpdateDetailViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFUpdateDetailViewController.h"
#import "UIView+MTAnimation.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 4.0f
#define FONT_SIZE_COMMENT 14.0f

@interface PFUpdateDetailViewController ()

@end

@implementation PFUpdateDetailViewController

int maxH;
BOOL noDataDetail;
BOOL refreshDataDetail;
BOOL newMediaDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareupdatedetail)];
    self.navigationItem.rightBarButtonItem = shareButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    maxH = 0;
    noDataDetail = NO;
    refreshDataDetail = NO;
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    [self.detailView.layer setCornerRadius:5.0f];
    
    self.titlenews.text = [self.obj objectForKey:@"name"];
    
    self.detailnews.text = [self.obj objectForKey:@"content"];
    CGRect frame = self.detailnews.frame;
    frame.size = [self.detailnews sizeOfMultiLineLabel];
    [self.detailnews sizeOfMultiLineLabel];
    
    [self.detailnews setFrame:frame];
    int lines = self.detailnews.frame.size.height/15;
    self.detailnews.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.detailnews.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.detailnews.alpha = 0;
    [self.detailView addSubview:descText];
    
    NSString *thumbid = [self.obj objectForKey:@"thumb_id"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=800&height=600"];
    self.detailthumb.imageURL = [[NSURL alloc] initWithString:urlimg];
    
    //
    self.detailthumb.frame = CGRectMake(self.detailthumb.frame.origin.x, self.detailnews.frame.origin.y+self.detailnews.frame.size.height+20, self.detailthumb.frame.size.width, self.detailthumb.frame.size.height);
    
    self.detailthumb.layer.masksToBounds = YES;
    self.detailthumb.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.detailthumb setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.detailthumb addGestureRecognizer:singleTap];
    
    //
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.detailnews.frame.size.height-13);
    self.tableView.tableHeaderView = self.headerView;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    self.tableView.tableFooterView = fv;
    
    if (IS_WIDESCREEN) {
        self.textCommentView.frame = CGRectMake(0, 464+60, 320, 356);
    } else {
        self.textCommentView.frame = CGRectMake(0, 440, 320, 356);
    }
    
    self.textComment.delegate = self;
    [self.view addSubview:self.textCommentView];
    
    self.arrObj = [[NSMutableArray alloc] init];
    [self.mingmitrSDK getCommentObjId:[self.obj objectForKey:@"id"] padding:@"NO"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.textComment.text isEqualToString:@"Add Comment"]) {
        [self.textComment setTextColor:[UIColor blackColor]];
        self.textComment.text = @"";
    }
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.33 timingFunction:kMTEaseOutSine animations:^{
        self.textCommentView.frame = CGRectMake(0, 250+60, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
    } completion:^{
        
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height-215);
        //214
        if (IS_WIDESCREEN) {
            
            self.textCommentView.frame = CGRectMake(0, 250+60, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
            if ([self.arrObj count] > 0)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
            
            self.textCommentView.frame = CGRectMake(0, 220, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
            if ([self.arrObj count] > 0)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
	{
        if ( maxH < 3) {
            maxH += 1;
            float diff = (textView.frame.size.height - 30);
            CGRect r = self.textCommentView.frame;
            r.size.height += diff;
            r.origin.y -= 15;
            self.textCommentView.frame = r;
            CGRect a = self.textComment.frame;
            a.size.height += 15;
            self.textComment.frame = a;
            CGRect b = self.postBut.frame;
            b.origin.y += 15;
            self.postBut.frame = b;
            return YES;
        } else {
            [self.textComment scrollRangeToVisible:NSMakeRange([self.textComment.text length], 0)];
            return YES;
        }
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.textComment scrollRangeToVisible:NSMakeRange([self.textComment.text length], 0)];
}

- (IBAction)postCommentTapped:(id)sender {
    
    [self.tableView reloadData];
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self.textComment resignFirstResponder];
    
    if ([[self.mingmitrSDK getAuth] isEqualToString:@"Guest Login"] || [[self.mingmitrSDK getAuth] isEqualToString:@"NO"]){
        
        self.loginView = [PFLoginViewController alloc];
        [self.view addSubview:self.loginView.view];
        
    }else{
        if (![self.textComment.text isEqualToString:@""]) {
            
            [self.mingmitrSDK commentObjId:[self.obj objectForKey:@"id"] content:self.textComment.text];
            
        }else {
            
        }
    }
    
}
//
- (void)PFMingMitrSDK:(id)sender getCommentObjIdResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    if (!refreshDataDetail) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    if ( [[response objectForKey:@"paginate"] objectForKey:@"next"] == nil ) {
        noDataDetail = YES;
    } else {
        noDataDetail = NO;
        self.paging = [[response objectForKey:@"paginate"] objectForKey:@"next"];
    }
    NSString *stpage = [[response objectForKey:@"paginate"] objectForKey:@"page"];
    int number = [stpage intValue];
    int itpage = 1+number;
    NSString *strFromInt = [NSString stringWithFormat:@"%d",itpage];
    
    self.prevString = [[NSString alloc]initWithFormat:@"View previous comments %@ total %@",strFromInt,[[response objectForKey:@"paginate"] objectForKey:@"length"]];
    
    [self reloadData:YES];
}

- (void)PFMingMitrSDK:(id)sender getCommentObjIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}
//----------------------------
- (void)PFMingMitrSDK:(id)sender commentObjIdResponse:(NSDictionary *)response {
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
    [self.arrObj insertObject:response atIndex:[self.arrObj count]];
    [self.tableView reloadData];
    [self.textComment setTextColor:[UIColor lightGrayColor]];
    self.textComment.text = @"Add Comment";
    if ([self.arrObj count] > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
}
- (void)PFMingMitrSDK:(id)sender commentObjIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}
//----------------------------
- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.5];
        [[self.tableView layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.arrObj count] < 4 ) {
        return 0;
    } else {
        return 44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UIImageView *imgViewPrev = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 3)];
    UIImageView *imgViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 300, 3)];
    imgViewLine.image = [UIImage imageNamed:@"LineCommentBoxIp5.png"];
    imgViewPrev.image = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(loadComment)
     forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:self.prevString forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 3, 300, 40);
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"linePrev.png"] forState:UIControlStateNormal];
    //headerView.backgroundColor = [UIColor redColor];
    [headerView addSubview:button];
    [headerView addSubview:imgViewPrev];
    [headerView addSubview:imgViewLine];
    return headerView;
}

- (void)loadComment {
    if (!noDataDetail){
        refreshDataDetail = NO;
        [self.mingmitrSDK getCommentObjId:[self.obj objectForKey:@"id"] padding:self.paging];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [[NSString alloc] init];
    str =  [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    NSString *text = str;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_COMMENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 24.0f) + 10;
    
    NSString *h = [[NSString alloc] initWithFormat:@"%f",height + (CELL_CONTENT_MARGIN * 2)];
    
    int lineValue = [h intValue]/16;
    int heightLable = 20*lineValue;
    return heightLable+40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFUpdateCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCommentCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCommentCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //
    NSString *str = [[NSString alloc] init];
    str =  [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    NSString *text = str;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_COMMENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 24.0f) + 10;
    
    NSString *h = [[NSString alloc] initWithFormat:@"%f",height + (CELL_CONTENT_MARGIN * 2)];
    
    int lineValue = [h intValue]/16;
    cell.commentLabel.numberOfLines = 0;
    int heightLable = 20*lineValue;
    
    cell.delegate = self;
    cell.commentLabel.frame = CGRectMake(cell.commentLabel.frame.origin.x, cell.commentLabel.frame.origin.y, cell.commentLabel.frame.size.width, heightLable);
    
    cell.timeComment.frame = CGRectMake(cell.timeComment.frame.origin.x,heightLable + 14, cell.timeComment.frame.size.width, cell.timeComment.frame.size.height);
    cell.timeComment.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"updated_at"] objectForKey:@"date"];
    //cell.timeComment.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_text"];
    
    cell.imgBut.tag = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    cell.commentLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"content"];
    cell.nameLabel.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"display_name"];
    
    NSString *urlStr = [[NSString alloc] initWithString:[[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"picture"] objectForKey:@"link"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    cell.myImageView.imageURL = url;
    
    NSInteger sectionsAmount = [tableView numberOfSections];
    NSInteger rowsAmount = [tableView numberOfRowsInSection:[indexPath section]];
    
    if ([self.arrObj count] < 4 ) {
        if (indexPath.row == 0 ) {
            if ([self.arrObj count] > 1 ) {
                UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];
                cell.lineImg.image = [UIImage imageNamed:@"LineCommentBoxIp5"];
                //cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
                cell.headImg.image = image2;
            } else {
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
                cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
                UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5"] deg:180];
                cell.headImg.image = image2;
            }
        } else if ([indexPath section] == sectionsAmount - 1 && [indexPath row] == rowsAmount - 1) {
            cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        } else {
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        }
    } else {
        if (indexPath.row == 0 ) {
            if ([self.arrObj count] > 1 ) {
                //UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];
                cell.lineImg.image = [UIImage imageNamed:@"LineCommentBoxIp5"];
                cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
            } else {
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
                cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
                //UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5"] deg:180];
                cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
            }
        } else if ([indexPath section] == sectionsAmount - 1 && [indexPath row] == rowsAmount - 1) {
            cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        } else {
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        }
    }
    //
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//--------------------------
- (void)shareupdatedetail {
    
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.0 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.0
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
    
    NSString *urlString = [[NSString alloc]init];
    urlString = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"node"] objectForKey:@"share_url"]];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addURL:[NSURL URLWithString:urlString]];
        [self presentViewController:controller animated:YES completion:Nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Mingmitr"
                                    message:@"Please login facebook on Settings."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    NSString *picStr = [[self.obj objectForKey:@"thumb"] objectForKey:@"link"];
    [self.delegate PFUpdateDetailViewController:self viewPicture:picStr];
    
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.0 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.0
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFUpdateDetailViewControllerBack)]){
            [self.delegate PFUpdateDetailViewControllerBack];
        }
    }
}

@end
