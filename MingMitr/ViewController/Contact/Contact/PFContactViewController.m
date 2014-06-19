//
//  PFContactViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFContactViewController.h"
#import "PagedImageScrollView.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

BOOL loadContact;
BOOL noDataContact;
BOOL refreshDataContact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    
    CALayer *mapbutton = [self.mapButton layer];
    [mapbutton setMasksToBounds:YES];
    [mapbutton setCornerRadius:6.7f];
    
    CALayer *mapradius = [self.mapImage layer];
    [mapradius setMasksToBounds:YES];
    [mapradius setCornerRadius:7.0f];
    
    loadContact = NO;
    noDataContact = NO;
    refreshDataContact = NO;
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    self.arrObj = [[NSMutableArray alloc] init];
    [self.mingmitrSDK getContact];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.imgscrollview addGestureRecognizer:singleTap];
    
    self.current = @"0";

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

- (void)PagedImageScrollView:(id)sender current:(NSString *)current{
    self.current = current;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    int sum;
    sum = [self.current intValue]/32;
    NSString *num = [NSString stringWithFormat:@"%d",sum];
    [self.delegate PFGalleryViewController:self sum:self.arrcontactimg current:num];
    
}

- (NSArray *)imageToArray:(NSDictionary *)images {
    NSMutableArray *ArrImgs = [[NSMutableArray alloc] init];
    int countPicture = [[images objectForKey:@"pictures"] count];
    for (int i = 0; i < countPicture; i++) {
        
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[[images objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"link"]];
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        
        NSData *data = [NSData dataWithContentsOfURL : url];
        UIImage *image = [UIImage imageWithData: data];
        [ArrImgs addObject:image];
    }
    return ArrImgs;
}

- (void)PFMingMitrSDK:(id)sender getContactResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    if ( [response objectForKey:@"email"] == [NSNull null]){
        
    } else {
        NSString *email = [response objectForKey:@"email"];
        [self.emailButton setTitle:email forState:UIControlStateNormal];
        
        NSString *website = [response objectForKey:@"website"];
        [self.webButton setTitle:website forState:UIControlStateNormal];
        
        self.locationinfo.text = [response objectForKey:@"location_info"];
        
        self.arrcontactimg = [[NSMutableArray alloc] init];
        for (int i=0; i<[[response objectForKey:@"pictures"] count]; ++i) {
            [self.arrcontactimg addObject:[[[[response objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"link"]];
        }
        
        PagedImageScrollView *pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        pageScrollView.delegate = self;
        [pageScrollView setScrollViewContents:[self imageToArray:response]];
        pageScrollView.pageControlPos = PageControlPositionCenterBottom;
        [self.imgscrollview addSubview:pageScrollView];
        
        self.tableView.tableHeaderView = self.headerView;
        
        self.tableView.tableFooterView = self.footView;
        
        NSString *urlmap1 = @"http://maps.googleapis.com/maps/api/staticmap?center=";
        
        NSMutableArray *pointmap = [[NSMutableArray alloc] initWithCapacity:[[response objectForKey:@"locations"] count]];
        for (int i=0; i < [[response objectForKey:@"locations"] count]; i++) {
            NSString *pointchar = [NSString alloc];
            if (i == [[response objectForKey:@"locations"] count]-1) {
                pointchar  = [NSString stringWithFormat:@"%@%@%@", [[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lat"],@",",[[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lng"]];
            } else {
                pointchar  = [NSString stringWithFormat:@"%@%@%@%@", [[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lat"],@",",[[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lng"],@","];
            }
            [pointmap addObject:pointchar];
        }
        
        NSMutableString * resultpoint = [[NSMutableString alloc] init];
        for (NSObject * obj in pointmap)
        {
            [resultpoint appendString:[obj description]];
        }
        
        NSString *urlmap2 = resultpoint;
        
        NSString *urlmap3 = @"&zoom=13&size=600x300&sensor=false";
        
        NSMutableArray *locationmap = [[NSMutableArray alloc] initWithCapacity:[[response objectForKey:@"locations"] count]];
        for (int i=0; i < [[response objectForKey:@"locations"] count]; i++) {
            NSString *locationchar = [NSString alloc];
            
            locationchar  = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"&markers=color:0x",[[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"color"],@"%7C",[[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lat"],@",",[[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lng"]];
            
            [locationmap addObject:locationchar];
        }
        
        NSMutableString * resultlocation = [[NSMutableString alloc] init];
        for (NSObject * obj in locationmap)
        {
            [resultlocation appendString:[obj description]];
        }
        NSString *urlmap4 = resultlocation;
        
        NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@",urlmap1,urlmap2,urlmap3,urlmap4];
        
        [DLImageLoader loadImageFromURL:urlmap
                              completed:^(NSError *error, NSData *imgData) {
                                  self.mapImage.image = [UIImage imageWithData:imgData];
                              }];
        
        if (!refreshDataContact) {
            for (int i=0; i<[[response objectForKey:@"locations"] count]; ++i) {
                [self.arrObj addObject:[[response objectForKey:@"locations"] objectAtIndex:i]];
            }
        } else {
            [self.arrObj removeAllObjects];
            for (int i=0; i<[[response objectForKey:@"locations"] count]; ++i) {
                [self.arrObj addObject:[[response objectForKey:@"locations"] objectAtIndex:i]];
            }
        }
        
        [self reloadData:YES];
    }
    
    
}
- (void)PFMingMitrSDK:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFContactCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.img.layer.masksToBounds = YES;
    cell.img.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *thumbid = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb_id"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=100&height=100"];
    cell.img.imageURL = [[NSURL alloc] initWithString:urlimg];
    
    cell.name.text = [[NSString alloc] initWithString:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    if (indexPath.row == 0) {
        cell.bg.image = [UIImage imageNamed:@"chapter_branch_01.png"];
    } else if (indexPath.row == [self.arrObj count]-1) {
        cell.bg.image = [UIImage imageNamed:@"chapter_branch_03.png"];
    } else {
        cell.bg.image = [UIImage imageNamed:@"chapter_branch_02.png"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate HideTabbar];
    
    PFMapViewController *mmmap = [[PFMapViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        
        mmmap = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
        
    } else {
        
        mmmap = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController" bundle:nil];
        
    }
    
    mmmap.locationname = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    mmmap.lat = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"lat"];
    mmmap.lng = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"lng"];
    mmmap.delegate = self;
    [self.navController pushViewController:mmmap animated:YES];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataContact){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}


- (IBAction)emailTapped:(id)sender {
    //if (![self.emailButton.titleLabel isEqual:nil]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Select Menu"
                                      delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Send Email", nil];
        [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    //}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        
        // Email Subject
        NSString *emailTitle = @"Mingmitr Email";
        // Email Content
        NSString *messageBody = @"Mingmitr!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"mingmitrcoffee@gmail.com"];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        //NSLog(@"Cancel");
    }
}

- (IBAction)webTapped:(id)sender {
    
    [self.delegate HideTabbar];
    
    PFWebViewController *webView = [[PFWebViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController_Wide" bundle:nil];
        
    } else {
        
        webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController" bundle:nil];
        
    }
    
    NSString *getweb = [self.obj objectForKey:@"website"];
    webView.url = getweb;
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];
}

- (IBAction) mapTapped:(id)sender {
    
    [self.delegate HideTabbar];
    
    PFAllMapViewController *mapView = [[PFAllMapViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        
        mapView = [[PFAllMapViewController alloc] initWithNibName:@"PFAllMapViewController_Wide" bundle:nil];
        
    } else {
        
        mapView = [[PFAllMapViewController alloc] initWithNibName:@"PFAllMapViewController" bundle:nil];
        
    }
    
    mapView.delegate = self;
    [self.navController pushViewController:mapView animated:YES];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)powerbyTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        [self.tableView reloadData];
    }
}

- (void) PFWebViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void) PFAllmapViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void) PFMapViewControllerBack {
    [self.delegate ShowTabbar];
}

@end
