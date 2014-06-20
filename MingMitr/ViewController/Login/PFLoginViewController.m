//
//  PFLoginViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFLoginViewController.h"

@interface PFLoginViewController ()

@end

@implementation PFLoginViewController

NSString *password;

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
    
    self.pick = [[UIDatePicker alloc] init];
    self.pickDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickDone setFrame:CGRectMake(50, 370, 200, 44)];
    self.pickDone.alpha = 0;
    [self.pick setFrame:CGRectMake(0,200,320,120)];
    self.pick.alpha = 0;
    
    // Do any additional setup after loading the view from its nib.
    self.loginView.layer.masksToBounds = NO;
    self.loginView.layer.cornerRadius = 4; // if you like rounded corners
    self.loginView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.loginView.layer.shadowRadius = 5;
    self.loginView.layer.shadowOpacity = 0.5;
    
    self.registerView.layer.masksToBounds = NO;
    self.registerView.layer.cornerRadius = 4; // if you like rounded corners
    self.registerView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.registerView.layer.shadowRadius = 5;
    self.registerView.layer.shadowOpacity = 0.5;
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    
    FBLoginView *fbView = [[FBLoginView alloc] init];
    fbView.delegate = self;
    fbView.frame = CGRectMake(20, 123, 240, 60);
    fbView.readPermissions = @[@"basic_info", @"email"];
    FBSession *session = [[FBSession alloc] initWithPermissions:@[@"basic_info", @"email"]];
    [FBSession setActiveSession:session];
    [self.loginView addSubview:fbView];
    
    self.registerView.frame = CGRectMake(20, 600, self.registerView.frame.size.width, self.registerView.frame.size.height);
    
    self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    scrollview.contentSize = CGSizeMake(320, 700);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollview addGestureRecognizer:singleTap];
    
    [scrollview addSubview:self.loginView];
    [self.view addSubview:scrollview];
    
    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 80, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        //NSLog(@"animation ok");
    }];

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

#pragma mark - function helper
- (void)delView {
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{self.blurView.alpha = 0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
    
}
- (void)hideKeyboard {
    
    [self.emailSignIn resignFirstResponder];
    [self.passwordSignIn resignFirstResponder];
    [self.username resignFirstResponder];
    [self.emailSignUp resignFirstResponder];
    [self.passwordSignUp resignFirstResponder];
    [self.confirmSignUp resignFirstResponder];
}
-(void)dateBirthButtonClicked {
    self.registerView.alpha = 1;
    self.blurView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.0
                          delay:0.0  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         
                         NSDateFormatter *date = [[NSDateFormatter alloc] init];
                         date.dateFormat = @"yyyy/MM/dd";
                         NSArray *temp = [[NSString stringWithFormat:@"%@",[date stringFromDate:self.pick.date]] componentsSeparatedByString:@""];
                         NSString *dateString = [[NSString alloc] init];
                         dateString = [[NSString alloc] initWithString:[temp objectAtIndex:0]];
                         
                         [self.dateOfBirthSignUp setText:dateString];
                         self.pick.alpha = 0;
                         self.pickDone.alpha = 0;
                         [self.pickDone removeFromSuperview];
                         [self.pick removeFromSuperview];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (void)closeBox {
    [self hideKeyboard];
    
    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        //[self.view removeFromSuperview];
    }];
    [UIView mt_animateViews:@[self.registerView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.registerView.frame = CGRectMake(20, 600, self.registerView.frame.size.width, self.registerView.frame.size.height);
    } completion:^{
        //[self.view removeFromSuperview];
    }];
    [self performSelector:@selector(delView) withObject:self afterDelay:0.0 ];
    
}
#pragma - action
- (IBAction)signupTapeed:(id)sender {
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    scrollview.contentSize = CGSizeMake(320, 700);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollview addGestureRecognizer:singleTap];
    
    [scrollview addSubview:self.registerView];
    [self.view addSubview:scrollview];
    
    //0.7
    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        [UIView mt_animateViews:@[self.registerView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
            self.registerView.frame = CGRectMake(20, 70, self.registerView.frame.size.width, self.registerView.frame.size.height);
        } completion:^{
            //NSLog(@"animation ok");
        }];
    }];
    
}

- (IBAction)bgTapped:(id)sender {
    [self closeBox];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self closeBox];
}

- (IBAction)signinTapped:(id)sender {
    
    [self hideKeyboard];
    [self.mingmitrSDK LoginWithUsername:self.emailSignIn.text password:self.passwordSignIn.text];
    
}
- (IBAction)dateBTapped:(id)sender {
    [self hideKeyboard];
    self.registerView.alpha = 0;
    self.blurView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.0
                          delay:0.0  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         [self.pickDone setFrame:CGRectMake(50, 370, 200, 44)];
                         [self.pickDone setTintColor:[UIColor whiteColor]];
                         [self.pickDone setTitle:@"Ok !" forState:UIControlStateNormal];
                         [self.pickDone addTarget:self action:@selector(dateBirthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                         self.pickDone.alpha = 1;
                         [self.view addSubview:self.pickDone];
                         self.pick.alpha = 1;
                         [self.pick setFrame:CGRectMake(0,200,320,120)];
                         self.pick.backgroundColor = [UIColor whiteColor];
                         self.pick.hidden = NO;
                         self.pick.datePickerMode = UIDatePickerModeDate;
                         self.pick.tintColor = [UIColor whiteColor];
                         [self.view addSubview:self.pick];
                         //[self.scrollView setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (IBAction)genderTapped:(id)sender {
    [self hideKeyboard];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr"
                                                      message:@"Select gender."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Male", @"Female", nil];
    [message show];
}
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.gender.text = @"Male";
    } else if (buttonIndex == 2) {
        self.gender.text = @"Female";
    }
}
- (IBAction)closedateTapped:(id)sender {
    self.dateOfBirthSignUp.text = @"";
}
- (IBAction)closegenderTapped:(id)sender {
    self.gender.text = @"";
}
- (IBAction)sumitTapped:(id)sender {
    
    password = self.passwordSignUp.text;
    
    if ( [self.username.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                                          message:@"Username Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( [self.emailSignUp.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                                          message:@"Email Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( ![self validateEmail:[self.emailSignUp text]] ) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                                          message:@"Enter a valid email address"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( [self.passwordSignUp.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr"
                                                          message:@"Password Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if (![self.passwordSignUp.text isEqualToString:self.confirmSignUp.text]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                                          message:@"And password do not match."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else {
        [self.mingmitrSDK registerWithUsername:self.username.text password:self.passwordSignUp.text email:self.emailSignUp.text gender:self.gender.text birth_date:self.dateOfBirthSignUp.text];
    }
}
#pragma mark - Satit Api Delegate
- (void)PFMingMitrSDK:(id)sender LoginWithUsernameResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([[[response objectForKey:@"error"] objectForKey:@"code"] intValue] == 401 ) {
        [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[response objectForKey:@"access_token"] forKey:@"access_token"];
        [defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
        [defaults synchronize];
        
        [self closeBox];
        
        if ([self.menu isEqualToString:@"account"]) {
            self.menu = @"";
            [self.delegate PFAccountViewController:self];
            
        } else if ([self.menu isEqualToString:@"notify"]) {
            self.menu = @"";
            [self.delegate PFNotifyViewController:self];
            
        } else if ([self.menu isEqualToString:@"member"]) {
            self.menu = @"";
            [self.delegate PFMemberViewController:self];
            
        }
    }
}
- (void)PFMingMitrSDK:(id)sender LoginWithUsernameErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (void)PFMingMitrSDK:(id)sender registerWithUsernameResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    if ([response objectForKey:@"error"] != nil ) {
        [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        
        [self closeBox];
        
        [self hideKeyboard];
        [self.mingmitrSDK LoginWithUsername:[response objectForKey:@"username"] password:password];
    }
}
- (void)PFMingMitrSDK:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (void)PFMingMitrSDK:(id)sender LoginWithFacebookResponse:(NSDictionary *)response {
    NSLog(@"%@",response);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"access_token"] forKey:@"access_token"];
    [defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
    [defaults synchronize];
    
    [self closeBox];
    
    if ([self.menu isEqualToString:@"account"]) {
        self.menu = @"";
        [self.delegate PFAccountViewController:self];
        
    } else if ([self.menu isEqualToString:@"notify"]) {
        self.menu = @"";
        [self.delegate PFNotifyViewController:self];
        
    } else if ([self.menu isEqualToString:@"member"]) {
        self.menu = @"";
        [self.delegate PFMemberViewController:self];
        
    }
}
- (void)PFMingMitrSDK:(id)sender LoginWithFacebookErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - Facebook Delegate
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[defaults objectForKey:@"deviceToken"]);
    NSString *devicetoken = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"deviceToken"]];
    
    if ([devicetoken isEqualToString:@""]) {
        [self.mingmitrSDK LoginWithFacebook:fbAccessToken ios_device_token:@""];
    } else {
        [self.mingmitrSDK LoginWithFacebook:fbAccessToken ios_device_token:[defaults objectForKey:@"deviceToken"]];
    }
    
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"You're logged in as");
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"You're not logged in!");
}
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField  {
    [self.emailSignIn resignFirstResponder];
    [self.passwordSignIn resignFirstResponder];
    
    [self.username resignFirstResponder];
    [self.emailSignUp resignFirstResponder];
    [self.passwordSignUp resignFirstResponder];
    [self.confirmSignUp resignFirstResponder];
    
    return YES;
}

@end
