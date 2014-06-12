//
//  PFMenuViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFMenuViewController.h"

@interface PFMenuViewController ()

@end

@implementation PFMenuViewController

BOOL loadMenu;
BOOL noDataMenu;
BOOL refreshDataMenu;

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
    
    AMBlurView *backgroundView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navController.navigationBar.frame), 64)];
    [backgroundView setBlurTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
    [self.navController.view insertSubview:backgroundView belowSubview:self.navController.navigationBar];
    
    [self.view addSubview:self.navController.view];
    
    [self.segmented setBackgroundColor:RGB(230, 230, 230)];
    [self.segmented setTintColor:RGB(102,102,102)];
    CALayer *segmented = [self.segmented layer];
    [segmented setMasksToBounds:YES];
    [segmented setCornerRadius:5.0f];
    
    [self.segmented addTarget:self
                       action:@selector(segmentselect:)
             forControlEvents:UIControlEventValueChanged];
    
    loadMenu = NO;
    noDataMenu = NO;
    refreshDataMenu = NO;
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    self.arrObj = [[NSMutableArray alloc] init];
    [self.mingmitrSDK getDrinkList];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = hv;

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

- (void)PFMingMitrSDK:(id)sender getFolderListResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self reloadData:YES];
    
}

- (void)PFMingMitrSDK:(id)sender getFolderListErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataMenu){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

- (void)segmentselect:(id)sender {
    if (self.segmented.selectedSegmentIndex == 0) {
        
        [self.view addSubview:self.waitView];
        
        CALayer *popup = [self.popupwaitView layer];
        [popup setMasksToBounds:YES];
        [popup setCornerRadius:7.0f];
        
        [self.arrObj removeAllObjects];
        [self.mingmitrSDK getDrinkList];
        
    } else if (self.segmented.selectedSegmentIndex == 1) {
        
        [self.view addSubview:self.waitView];
        
        CALayer *popup = [self.popupwaitView layer];
        [popup setMasksToBounds:YES];
        [popup setCornerRadius:7.0f];
        
        [self.arrObj removeAllObjects];
        [self.mingmitrSDK getDessertList];
        
    } else if (self.segmented.selectedSegmentIndex == 2) {
        
        [self.view addSubview:self.waitView];
        
        CALayer *popup = [self.popupwaitView layer];
        [popup setMasksToBounds:YES];
        [popup setCornerRadius:7.0f];
        
        [self.arrObj removeAllObjects];
        [self.mingmitrSDK getBeensList];
        
    } else if (self.segmented.selectedSegmentIndex == 3) {
        
        [self.view addSubview:self.waitView];
        
        CALayer *popup = [self.popupwaitView layer];
        [popup setMasksToBounds:YES];
        [popup setCornerRadius:7.0f];
        
        [self.arrObj removeAllObjects];
        [self.mingmitrSDK getFranchiseList];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFMenuCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFMenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.namemenu.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.thumbmenu.layer.masksToBounds = YES;
    cell.thumbmenu.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *thumbid = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb_id"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=300&height=200"];
    cell.thumbmenu.imageURL = [[NSURL alloc] initWithString:urlimg];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Primary if -> Product -> Folder -> empty
    // if product_length == 0 AND folder_length == 0  no action
    // if product_length != 0 push product view
    // if folder_length != 0 push folder view
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"product_length"] intValue] == 0 && [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"folder_length"] intValue] == 0) {
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"product_length"] intValue] != 0 ) {
        
        [self.delegate HideTabbar];
        
        PFD1ViewController *d1 =[[PFD1ViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            d1 =[[PFD1ViewController alloc] initWithNibName:@"PFD1ViewController_Wide" bundle:nil];
        } else {
            d1 =[[PFD1ViewController alloc] initWithNibName:@"PFD1ViewController" bundle:nil];
        }
        
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"node"] objectForKey:@"products"]];
        NSString *parent = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"parent_id"]];
        d1.delegate = self;
        d1.parent_id = parent;
        d1.link = urlStr;
        d1.titlename = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        d1.delegate = self;
        [self.navController pushViewController:d1 animated:YES];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"folder_length"] intValue] != 0) {
        
        [self.delegate HideTabbar];
        
        PFF1ViewController *f1 = [[PFF1ViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            f1 = [[PFF1ViewController alloc] initWithNibName:@"PFF1ViewController_Wide" bundle:nil];
        } else {
            f1 = [[PFF1ViewController alloc] initWithNibName:@"PFF1ViewController" bundle:nil];
        }
        
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"node"] objectForKey:@"children"]];
        f1.delegate = self;
        f1.link = urlStr;
        f1.titlename = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        f1.delegate = self;
        [self.navController pushViewController:f1 animated:YES];
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFF1ViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void) PFD1ViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void) PFF1ViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void) PFF2ViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFMingMitrSDK:(id)sender getDrinkListResponse:(NSDictionary *)response {
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    
    [self reloadData:YES];
}
- (void)PFMingMitrSDK:(id)sender getDrinkListErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getDessertListResponse:(NSDictionary *)response {
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self reloadData:YES];
}
- (void)PFMingMitrSDK:(id)sender getDessertListErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getBeensListResponse:(NSDictionary *)response {
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self reloadData:YES];
}
- (void)PFMingMitrSDK:(id)sender getBeensListErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getFranchiseListResponse:(NSDictionary *)response {
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[response objectForKey:@"data"] count] == 0) {
        //NSLog(@"product");
    }
    
    [self reloadData:YES];
}
- (void)PFMingMitrSDK:(id)sender getFranchiseListErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getLinkResponse:(NSDictionary *)response {
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    [self.arrObj removeAllObjects];
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self reloadData:YES];
}
- (void)PFMingMitrSDK:(id)sender getLinkErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}


@end
