//
//  PFNotificationViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFNotificationViewController.h"

@interface PFNotificationViewController ()

@end

@implementation PFNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    [self.mingmitrSDK userGetNotifly];
    self.navigationItem.title = @"Notifications";
    
    [self.blurView setBlurTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:5]];
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.arrObjNotify = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];

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

- (void)PFMingMitrSDK:(id)sender userGetNotiflyResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];

    }
    
    [self.tableView reloadData];
}

- (void)PFMingMitrSDK:(id)sender userGetNotiflyErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getNewsByIdResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    PFUpdateDetailViewController *mmdetail = [[PFUpdateDetailViewController alloc] init];
    
    if(IS_WIDESCREEN){
        mmdetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
    } else {
        mmdetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
    }
    
    mmdetail.obj = response;
    mmdetail.delegate = self;
    
    [self.navigationController pushViewController:mmdetail animated:YES];
}

- (void)PFMingMitrSDK:(id)sender getNewsByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFNotificationCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.topicLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_header"];
    
    NSString *myDate = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_at"] objectForKey:@"date"];
    NSString *mySmallerDate = [myDate substringToIndex:16];
    cell.timeLabel.text = mySmallerDate;
    
    cell.msgLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"preview_content"];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"opened"] intValue] == 0) {
        cell.bg.image = [UIImage imageNamed:@"NotBoxNoReadIp5"];
    } else {
        cell.bg.image = [UIImage imageNamed:@"NotBoxReadedIp5"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    if ( [type isEqualToString:@"news"]) {
        [self.mingmitrSDK getNewsById:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"object_id"]];
    }
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@notify/user/opened/%@",API_URL,[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFUpdateDetailViewController:self viewPicture:link];
}

- (void)PFUpdateDetailViewControllerBack {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFNotificationViewControllerBack)]){
            [self.delegate PFNotificationViewControllerBack];
        }
    }
}

@end
