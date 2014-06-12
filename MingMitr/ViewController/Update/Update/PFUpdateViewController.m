//
//  PFUpdateViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadNews;
BOOL noDataNews;
BOOL refreshDataNews;

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
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notification_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
    
    self.navItem.leftBarButtonItem = leftButton;
    self.navItem.rightBarButtonItem = rightButton;
    
    loadNews = NO;
    noDataNews = NO;
    refreshDataNews = NO;
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    self.arrObj = [[NSMutableArray alloc] init];
    [self.mingmitrSDK getNews:@"5" next:@"NO"];
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = fv;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)PFMingMitrSDK:(id)sender getNewsResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataNews) {
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
        noDataNews = YES;
    } else {
        noDataNews = NO;
        self.paging = [[response objectForKey:@"paginate"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
    
}

- (void)PFMingMitrSDK:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataNews){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

- (void)account {
    
    if ([[self.mingmitrSDK getAuth] isEqualToString:@"Guest Login"] || [[self.mingmitrSDK getAuth] isEqualToString:@"NO"]){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.menu = @"account";
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView.view];
        
    }else{

        [self.delegate HideTabbar];
        
        PFAccountViewController *accountView = [[PFAccountViewController alloc] init];
        
        if(IS_WIDESCREEN){
            accountView = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
        } else {
            accountView = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
        }
        accountView.delegate = self;
        [self.navController pushViewController:accountView animated:YES];
        
    }
    
}
- (void)notify {
    
    if ([[self.mingmitrSDK getAuth] isEqualToString:@"Guest Login"] || [[self.mingmitrSDK getAuth] isEqualToString:@"NO"]){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.menu = @"notify";
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView.view];
        
    }else{
    
        [self.delegate HideTabbar];
        
        PFNotificationViewController *notifyView = [[PFNotificationViewController alloc] init];
        
        if(IS_WIDESCREEN){
            notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
        } else {
            notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
        }
        
        notifyView.delegate = self;
        [self.navController pushViewController:notifyView animated:YES];
        
    }
    
}

- (void)PFAccountViewController:(id)sender{

    [self.delegate HideTabbar];
    
    PFAccountViewController *accountView = [[PFAccountViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        accountView = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
    } else {
        accountView = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
    }
    accountView.delegate = self;
    [self.navController pushViewController:accountView animated:YES];
}

- (void)PFNotifyViewController:(id)sender{

    [self.delegate HideTabbar];
    
    PFNotificationViewController *notifyView = [[PFNotificationViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notifyView = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    notifyView.delegate = self;
    [self.navController pushViewController:notifyView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //NSLog(@"%@",[self.arrObj objectAtIndex:indexPath.row]);
    
    cell.titleNews.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailNews.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *thumbid = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb_id"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=800&height=600"];
    cell.thumbnails.imageURL = [[NSURL alloc] initWithString:urlimg];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.detailNewsView.layer setCornerRadius:5.0f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate HideTabbar];
    
    PFUpdateDetailViewController *mmdetail = [[PFUpdateDetailViewController alloc] init];
    
    if(IS_WIDESCREEN){
        mmdetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
    } else {
        mmdetail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
    }
    
    mmdetail.obj = [self.arrObj objectAtIndex:indexPath.row];
    mmdetail.delegate = self;
    [self.navController pushViewController:mmdetail animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f",scrollView.contentOffset.y);
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y < 0.0f ) {
        //NSLog(@"refreshData < 0.0f");
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha =1;
        self.statusLabel.text = @"";
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataNews = YES;
        
        self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
        self.mingmitrSDK.delegate = self;
        
        [self.mingmitrSDK getNews:@"5" next:@"NO"];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            self.statusLabel.text = @"No Update.";
            self.loadLabel.text = @"";
            self.act.alpha = 0;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        self.tableView.frame = CGRectMake(0, 60, 320, self.tableView.frame.size.height);
		[UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            self.statusLabel.text = @"No Update.";
            self.loadLabel.text = @"";
            self.act.alpha = 0;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataNews) {
            refreshDataNews = NO;
            
            self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
            self.mingmitrSDK.delegate = self;
            
            [self.mingmitrSDK getNews:@"NO" next:self.paging];
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFUpdateDetailViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFNotificationViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFAccountViewControllerBack {
    [self.delegate ShowTabbar];
}

@end