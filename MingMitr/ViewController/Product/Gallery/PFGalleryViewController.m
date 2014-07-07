//
//  PFGalleryViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFGalleryViewController.h"

@interface PFGalleryViewController ()

@end

@implementation PFGalleryViewController

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
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareupdatedetail)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    images = [[NSMutableArray alloc]init];
    
    NSString *productid = [NSString stringWithFormat:@"pictures?product_id=%@",self.product_id];
    [self.mingmitrSDK getProductId:productid];
    
    self.name.text = [self.objdetail objectForKey:@"name"];
    
    if ([self.parent_id isEqualToString:@"20"]) {
        self.price.hidden = YES;
        self.baht.hidden = YES;
    } else {
        self.price.text = [NSString stringWithFormat:@"%@",[self.objdetail objectForKey:@"price"]];
    }
    
    //nproduct detail
    
    self.productdetail.text = [self.objdetail objectForKey:@"description"];
    CGRect frame = self.productdetail.frame;
    frame.size = [self.productdetail sizeOfMultiLineLabel];
    [self.productdetail sizeOfMultiLineLabel];
    
    [self.productdetail setFrame:frame];
    int lines = self.productdetail.frame.size.height/15;
    self.productdetail.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.productdetail.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.productdetail.alpha = 0;
    [self.detailView addSubview:descText];
    
    self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.detailView.frame.size.width, self.productdetail.frame.size.height + self.productdetail.frame.origin.y+10);
    
    self.tableView.tableHeaderView = self.detailView;
    //
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
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

- (void)shareupdatedetail {
    
    NSString *urlString = [[NSString alloc]init];
    urlString = [[NSString alloc] initWithFormat:@"http://pla2app.com/mingmitr/webview/share/product.php?id=%@",self.product_id];

    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller addURL:[NSURL URLWithString:urlString]];
    [self presentViewController:controller animated:YES completion:Nil];
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], touchPoint))
		{
            self.current = [NSString stringWithFormat:@"%d",index];
			[self ShowDetailView:imgView];
			break;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch * touch = [[event allTouches] anyObject];
	
	for(int index=0;index<[images count];index++)
	{
		UIImageView *imgView = [images objectAtIndex:index];
		
		if(CGRectContainsPoint([imgView frame], [touch locationInView:scrollView]))
		{
			[self ShowDetailView:imgView];
			break;
		}
	}
}

-(void)ShowDetailView:(UIImageView *)imgView
{
	imageView.image = imgView.image;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)PFMingMitrSDK:(id)sender getProductIdResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",self.obj);
    
    [self.waitView removeFromSuperview];
    
    scrollView.delegate = self;
	scrollView.scrollEnabled = YES;
	int scrollWidth = 70;
	scrollView.contentSize = CGSizeMake(scrollWidth,70);
    
    int xOffset = 0;
    
    NSString *thumbid = [[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"picture"] objectForKey:@"id"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=800&height=600"];
    imageView.imageURL = [NSURL URLWithString:urlimg];
    
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.arrgalleryimg = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        //
		AsyncImageView *img = [[AsyncImageView alloc] init];
        
        img.layer.masksToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        
		img.frame = CGRectMake(xOffset, 0, 70, 70);
        
		//img.imageURL = [NSURL URLWithString:[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"link"]];
        
        NSString *thumbid = [[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"id"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://mingmitr-api.pla2app.com/picture/",thumbid,@"?width=800&height=600"];
        img.imageURL = [[NSURL alloc] initWithString:urlimg];
        
		[images insertObject:img atIndex:i];
        
        [self.arrgalleryimg addObject:[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"link"]];
        
		scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
		[scrollView addSubview:[images objectAtIndex:i]];
		
		xOffset += 70;
    }
    
}

- (void)PFMingMitrSDK:(id)sender getProductIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)fullimgalbumTapped:(id)sender {
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];    
}

@end
