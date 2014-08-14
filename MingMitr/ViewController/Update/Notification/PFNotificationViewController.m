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
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = footView;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFNotificationCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.topicLabel.text = @"Joe Smith";
    cell.timeLabel.text = @"2014-05-24 4:22 PM";
    cell.msgLabel.text = @"This is a notification. This is a notification. This is a notification. This is a notification. This is a notification. This is a notification. This is a notification.";
    return cell;
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
- (void)PFMingMitrSDK:(id)sender userGetNotiflyResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
}
- (void)PFMingMitrSDK:(id)sender userGetNotiflyErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}
@end
