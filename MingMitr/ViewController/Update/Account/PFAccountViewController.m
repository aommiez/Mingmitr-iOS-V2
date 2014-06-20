//
//  PFAccountViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFAccountViewController.h"

@interface PFAccountViewController ()

@end

@implementation PFAccountViewController

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
    
    self.navigationItem.title = @"Profile Setting";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.scrollView.contentSize = CGSizeMake(self.formView.frame.size.width, self.formView.frame.size.height+20);
    self.formView.frame = CGRectMake(10, 10, self.formView.frame.size.width,self.formView.frame.size.height);
    [self.scrollView addSubview:self.formView];
    
    CALayer *formViewradius = [self.formView layer];
    [formViewradius setMasksToBounds:YES];
    [formViewradius setCornerRadius:5.0f];
    
    CALayer *thumUser = [self.thumUser layer];
    [thumUser setMasksToBounds:YES];
    [thumUser setCornerRadius:7.0f];
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    self.arrObj = [[NSMutableArray alloc] init];
    [self.mingmitrSDK getMe];
    [self.mingmitrSDK getSetting];
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

- (void)PFMingMitrSDK:(id)sender getMeResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"link"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    self.thumUser.imageURL = [[NSURL alloc] initWithString:picStr];
    
    self.displayname.text = [response objectForKey:@"display_name"];
    self.facebook.text = [response objectForKey:@"display_name"];
    self.email.text = [response objectForKey:@"email"];
    self.phone.text = [response objectForKey:@"mobile_phone"];
    
}

- (void)PFMingMitrSDK:(id)sender getMeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFMingMitrSDK:(id)sender getSettingResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    if ([[response objectForKey:@"notify_news"] intValue] == 1) {
        self.switchNews.on = YES;
    } else {
        self.switchNews.on = NO;
    }
    
    if ([[response objectForKey:@"notify_message"] intValue] == 1) {
        self.switchMessage.on = YES;
    } else {
        self.switchMessage.on = NO;
    }
    
}

- (void)PFMingMitrSDK:(id)sender getSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)switchNewsonoff:(id)sender{
    
    if(self.switchNews.on) {
        NSLog(@"NewsOn");
        [self.mingmitrSDK settingNews:@"1"];
    } else {
        NSLog(@"NewsOff");
        [self.mingmitrSDK settingNews:@"0"];
    }
    
}

- (IBAction)switchMessageonoff:(id)sender{
    
    if(self.switchMessage.on) {
        NSLog(@"MessageOn");
        [self.mingmitrSDK settingMessage:@"1"];
    } else {
        NSLog(@"MessageOff");
        [self.mingmitrSDK settingMessage:@"0"];
    }
    
}

- (void)PFMingMitrSDK:(id)sender settingNewsResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
}

- (void)PFMingMitrSDK:(id)sender settingNewsErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)fullimgTapped:(id)sender {
    
    NSString *picStr = [[NSString alloc] initWithString:[[self.obj objectForKey:@"picture"] objectForKey:@"link"]];
    [self.delegate PFAccountViewController:self viewPicture:picStr];
}

- (void)edit {
    
    PFEditViewController *editView = [[PFEditViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        editView = [[PFEditViewController alloc] initWithNibName:@"PFEditViewController_Wide" bundle:nil];
    } else {
        editView = [[PFEditViewController alloc] initWithNibName:@"PFEditViewController" bundle:nil];
    }
    
    editView.delegate = self;
    [self.navigationController pushViewController:editView animated:YES];
}

- (IBAction)logoutTapped:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.mingmitrSDK logOut];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) PFEditViewControllerBack {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFAccountViewControllerBack)]){
            [self.delegate PFAccountViewControllerBack];
        }
    }
    
}

@end
