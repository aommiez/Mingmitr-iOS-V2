//
//  PFF2ViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFF2ViewController.h"

@interface PFF2ViewController ()

@end

@implementation PFF2ViewController

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
    self.navigationItem.title = self.titlename;
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    // Do any additional setup after loading the view from its nib.
    self.arrObj = [[NSMutableArray alloc] init];
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    [self.mingmitrSDK getLink:self.link];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.obj objectForKey:@"children_type"] isEqualToString:@"product"]) {
        
        PFDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFDetailCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFDetailCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.thumb.layer.masksToBounds = YES;
        cell.thumb.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *thumbid = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb_id"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=300&height=200"];
        cell.thumb.imageURL = [[NSURL alloc] initWithString:urlimg];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.price.text = [NSString stringWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"description"];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    } else {
        
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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"product_length"] intValue] == 0 && [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"folder_length"] intValue] == 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Mingmitr"
                                    message:@"Coming soon."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"product_length"] intValue] != 0 ) {
        
        PFD1ViewController *d1 =[[PFD1ViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            d1 =[[PFD1ViewController alloc] initWithNibName:@"PFD1ViewController_Wide" bundle:nil];
        } else {
            d1 =[[PFD1ViewController alloc] initWithNibName:@"PFD1ViewController" bundle:nil];
        }
        
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"node"] objectForKey:@"products"]];
        d1.delegate = self;
        d1.link = urlStr;
        d1.titlename = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:d1 animated:YES];
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"folder_length"] intValue] != 0) {
        
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
        [self.navigationController pushViewController:f1 animated:YES];
    }
}

- (void)PFMingMitrSDK:(id)sender getLinkResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    self.obj = response;
    //NSLog(@"%@",self.obj);
    
    [self.arrObj removeAllObjects];
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self reloadData:YES];
}

- (void)PFMingMitrSDK:(id)sender getLinkErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFF2ViewControllerBack)]){
            [self.delegate PFF2ViewControllerBack];
        }
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

@end
