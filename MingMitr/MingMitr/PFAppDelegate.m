//
//  PFAppDelegate.m
//  MingMitr
//
//  Created by MRG on 6/11/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PFLoginViewController.h"

@implementation PFAppDelegate

BOOL newMedia;

- (void)initializeLogger
{
    // required, setup DDLog
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // use NXVLogFormatter as custom log formmater
    [[DDTTYLogger sharedInstance] setLogFormatter:[NXVLogFormatter new]];
    
    // optional, enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    [FBLoginView class];
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    //[self.mingmitrSDK logOut];
    NSLog(@"%@",[self.mingmitrSDK getAuth]);
    self.mingmitrSDK.delegate = self;
    
    if ([[self.mingmitrSDK getAuth] isEqualToString:@"Guest Login"] || [[self.mingmitrSDK getAuth] isEqualToString:@"NO"]) {
        //[self.mingmitrSDK LoginWithUsername:@"a@a.com" password:@"123456"];
    } else {
        [self.mingmitrSDK checkBadge];
        //NSLog(@"Login");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.update = [[PFUpdateViewController alloc] init];
    self.menu = [[PFMenuViewController alloc] init];
    self.member = [[PFMemberViewController alloc] init];
    self.contact = [[PFContactViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        self.update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController_Wide" bundle:nil];
        self.menu = [[PFMenuViewController alloc] initWithNibName:@"PFMenuViewController_Wide" bundle:nil];
        self.member = [[PFMemberViewController alloc] initWithNibName:@"PFMemberViewController_Wide" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController_Wide" bundle:nil];
        
    } else {
        self.update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController" bundle:nil];
        self.menu = [[PFMenuViewController alloc] initWithNibName:@"PFMenuViewController" bundle:nil];
        self.member = [[PFMemberViewController alloc] initWithNibName:@"PFMemberViewController" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController" bundle:nil];
        
    }
    
    self.tabBarViewController = [[PFTabBarViewController alloc] initWithBackgroundImage:nil viewControllers:self.update,self.menu,self.member,self.contact,nil];
    
    self.update.delegate = self;
    self.menu.delegate = self;
    self.member.delegate = self;
    self.contact.delegate = self;
    
    if(IS_WIDESCREEN){
        
        PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
        [item0 setHighlightedImage:[UIImage imageNamed:@"update_light"]];
        [item0 setStanbyImage:[UIImage imageNamed:@"update_standby"]];
        
        PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
        [item1 setHighlightedImage:[UIImage imageNamed:@"menu_light"]];
        [item1 setStanbyImage:[UIImage imageNamed:@"menu_standby"]];
        
        PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
        [item2 setHighlightedImage:[UIImage imageNamed:@"member_light"]];
        [item2 setStanbyImage:[UIImage imageNamed:@"member_standby"]];
        
        PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
        [item3 setHighlightedImage:[UIImage imageNamed:@"contact_light"]];
        [item3 setStanbyImage:[UIImage imageNamed:@"contact_standby"]];
        
    }else{
        
        PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
        [item0 setHighlightedImage:[UIImage imageNamed:@"update_light"]];
        [item0 setStanbyImage:[UIImage imageNamed:@"update_standby"]];
        
        PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
        [item1 setHighlightedImage:[UIImage imageNamed:@"menu_light"]];
        [item1 setStanbyImage:[UIImage imageNamed:@"menu_standby"]];
        
        PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
        [item2 setHighlightedImage:[UIImage imageNamed:@"member_light"]];
        [item2 setStanbyImage:[UIImage imageNamed:@"member_standby"]];
        
        PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
        [item3 setHighlightedImage:[UIImage imageNamed:@"contact_light"]];
        [item3 setStanbyImage:[UIImage imageNamed:@"contact_standby"]];
        
    }
    
    [self.tabBarViewController setSelectedIndex:1];
    [self.tabBarViewController setSelectedIndex:2];
    [self.tabBarViewController setSelectedIndex:3];
    [self.tabBarViewController setSelectedIndex:0];
    [self.window setRootViewController:self.tabBarViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"deviceToken"];
    [defaults synchronize];
    
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] forKey:@"badge"];
    [defaults synchronize];
	NSLog(@"Received notification: %@", [[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskAll);
}

- (void)HideTabbar {
    [self.tabBarViewController hideTabBarWithAnimation:YES];
}

- (void)ShowTabbar {
    [self.tabBarViewController showTabBarWithAnimation:YES];
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:link]];
    [photos addObject:photo];
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    
    for (int i=0; i<[sum count]; i++) {
        NSString *t = [[NSString alloc] initWithFormat:@"%@",[sum objectAtIndex:i]];
        photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:t]];
        [photos addObject:photo];
    }
    
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:[current intValue]];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser DoneTappedDelegate:(NSUInteger)index {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //[self showTabbar];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser uploadTappedDelegate:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Profile Picture"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Camera Roll", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        [self useCamera];
    } else if ( buttonIndex == 1 ) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            [self useCameraRoll];
        }];
        
    }
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:   UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        imagePicker.navigationBarHidden=YES;
        imagePicker.view.userInteractionEnabled=YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    image = [self squareImageWithImage:image scaledToSize:CGSizeMake(640, 640)];
    [picker dismissViewControllerAnimated:YES completion:^{
        //accView.thumUser.image = image;
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)PFMingMitrSDK:(id)sender checkBadgeResponse:(NSDictionary *)response {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
    [defaults synchronize];
}
- (void)PFMingMitrSDK:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

@end
