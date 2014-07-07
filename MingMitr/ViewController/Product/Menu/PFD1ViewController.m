//
//  PFD1ViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFD1ViewController.h"

@interface PFD1ViewController ()

@end

@implementation PFD1ViewController

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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.parent_id isEqualToString:@"20"]) {
        PFFranchiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFranchiseCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFranchiseCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.image.layer.masksToBounds = YES;
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *thumbid = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb_id"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitrapi.pla2api.com/picture/",thumbid,@"?width=300&height=200"];
        cell.image.imageURL = [[NSURL alloc] initWithString:urlimg];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"description"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  push หน้าโปรดักแกลอลี่ เข้ามา
     */
    //NSLog(@"%@",[self.arrObj objectAtIndex:indexPath.row]);
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"picture_length"] intValue] <= 1) {
        
        PFDetailViewController *d1 =[[PFDetailViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            d1 =[[PFDetailViewController alloc] initWithNibName:@"PFDetailViewController_Wide" bundle:nil];
        } else {
            d1 =[[PFDetailViewController alloc] initWithNibName:@"PFDetailViewController" bundle:nil];
        }
        
        d1.delegate = self;
        d1.titlename = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        d1.parent_id = self.parent_id;
        d1.product_id = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"];
        d1.objdetail = [self.arrObj objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:d1 animated:YES];
        
    } else {
        
        PFGalleryViewController *g1 =[[PFGalleryViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            g1 =[[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController_Wide" bundle:nil];
        } else {
            g1 =[[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController" bundle:nil];
        }
        
        g1.delegate = self;
        g1.titlename = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        g1.parent_id = self.parent_id;
        g1.product_id = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"];
        g1.objdetail = [self.arrObj objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:g1 animated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFD1ViewControllerBack)]){
            [self.delegate PFD1ViewControllerBack];
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
