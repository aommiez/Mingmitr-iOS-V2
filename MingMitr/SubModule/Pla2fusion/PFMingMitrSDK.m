//
//  PFMingMitrSDK.m
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFMingMitrSDK.h"

@implementation PFMingMitrSDK

#pragma mark - Setup logger

- (void)initializeLogger
{

    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setLogFormatter:[NXVLogFormatter new]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
#if TARGET_OS_IPHONE
    UIColor *pink = [UIColor colorWithRed:(36/255.0) green:(135/255.0) blue:(63/255.0) alpha:1.0];
#else
    NSColor *pink = [NSColor colorWithCalibratedRed:(36/255.0) green:(135/255.0) blue:(63/255.0) alpha:1.0];
#endif
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_INFO];
    
    
}
- (id) init
{
    if (self = [super init])
    {
        [self initializeLogger];
        self.en = [[EntitiesUtility alloc] init];
        self.manager = [AFHTTPRequestOperationManager manager];
        self.hp = [[PFHelper alloc] init];
    }
    return self;
}

#pragma mark - Core Apps
- (NSString *)getAuth {
    NSArray *re = [self.en getAuthData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (re == NULL) {
        [self.en setAuthData:@"NO" who:@"Guest" guest_token:[self.hp genRandStringLength:256]];
        return @"NO";
    } else {
        /*
        if ([[[re objectAtIndex:0] objectForKey:@"who"] isEqualToString:@"Guest"]) {
            return @"Guest Login";
        } else {
            return @"User Login";
        }*/
        
        if ([defaults objectForKey:@"user_id"] == nil) {
            return @"Guest Login";
        } else {
            return @"User Login";
        }
    }
    return @"NO";
}
- (NSString *)getUserToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"access_token"];
}
- (NSString *)getGuestToken {
    return  @"aaa";
}
- (NSString *)getUserId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"user_id"];
}
- (void)getLink:(NSString *)link {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",link];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getLinkResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getLinkErrorResponse:[error localizedDescription]];
    }];
}
#pragma mark - User

- (void)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email gender:(NSString *)gender  birth_date:(NSString *)birth_date {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/register",API_URL];
    NSDictionary *parameters = @{@"username":username , @"password":password ,@"display_name":username,@"email":email,@"gender":gender,@"birth_date":birth_date };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self registerWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self registerWithUsernameErrorResponse:[error localizedDescription]];
    }];
}

- (void)LoginWithFacebook:(NSString *)facebook_token ios_device_token:(NSString *)ios_device_token {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@oauth/facebook",API_URL];
    NSDictionary *parameters = @{@"facebook_token":facebook_token , @"android_device_token":@"" ,@"ios_device_token":ios_device_token};
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self LoginWithFacebookResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self LoginWithFacebookErrorResponse:[error localizedDescription]];
    }];
}
- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
    //NSString *urlStr = [[NSString alloc] initWithFormat:@"%@oauth/password",API_URL];
    
}
- (void)LoginWithUsername:(NSString *)username password:(NSString *)password {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@oauth/password",API_OAUTH];
    NSDictionary *parameters = @{@"username":username , @"password":password};
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self LoginWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self LoginWithUsernameErrorResponse:[error localizedDescription]];
    }];
}

- (void)getMe {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@me?access_token=%@",API_URL,[self getUserToken]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getMeResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getMeErrorResponse:[error localizedDescription]];
    }];
}
- (void)getSetting {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/update/%@?access_token=%@",API_URL,[self getUserId],[self getUserToken]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getSettingErrorResponse:[error localizedDescription]];
    }];
}
- (void)settingNews:(NSString *)status {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/update/%@?access_token=%@",API_URL,[self getUserId],[self getUserToken]];
    NSDictionary *parameters = @{@"notify_news":status };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self settingNewsResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self settingNewsErrorResponse:[error localizedDescription]];
    }];
}
- (void)settingMessage:(NSString *)status {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/update/%@?access_token=%@",API_URL,[self getUserId],[self getUserToken]];
    NSDictionary *parameters = @{@"notify_message":status };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self settingNewsResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self settingNewsErrorResponse:[error localizedDescription]];
    }];
}
- (void)getUserById:(NSString *)user_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,user_id];
    [self.manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getUserByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getUserByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)updateUserById:(NSString *)user_id display_name:(NSString *)display_name picture:(NSString *)picture_base64 mobile_phone:(NSString *)mobile_phone website:(NSString *)website gender:(NSString *)gender birth_date:(NSString *)birth_date {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/update/%@",API_URL,user_id];
    NSDictionary *parameters = @{@"display_name":display_name , @"picture":picture_base64  ,@"mobile_phone":mobile_phone , @"website":website , @"gender":gender ,@"birth_date":birth_date };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self updateUserByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self updateUserByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)setUserIdAndTokenToCoreData:(NSString *)user_id token:(NSString *)token {
    NSArray *re = [self.en getUserData];
    if (re == NULL) {
        [self.en setUserIDAndToken:user_id token:token];
    } else {
        NSLog(@"meeeee");
    }
}
- (void)logOut {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
}
#pragma mark - News
/**
 *  Get News
 *
 *  @param limit @"5"
 *  @param next  @NO" or @"http://www.google.co.th"
 */
- (void)getNews:(NSString *)limit next:(NSString *)next {
    NSString *urlStr = [[NSString alloc] init];
    if (![limit isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@news?limit=%@",API_URL,limit];
    } else if (![next isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",next];
    } else {
        urlStr = [[NSString alloc] initWithFormat:@"%@news",API_URL];
    }
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getNewsResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getNewsErrorResponse:[error localizedDescription]];
    }];
}
- (void)getNewsById:(NSString *)news_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@",API_URL,news_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getNewsByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getNewsByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getCommentObjId:(NSString *)obj_id padding:(NSString *)padding{
    NSString *urlStr = [[NSString alloc] init];
    if ([padding isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@news/comment?object_id=%@&order_type=asc&limit=5",API_URL,obj_id];
    } else {
        urlStr = [[NSString alloc] initWithFormat:@"%@",padding];
    }
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getCommentObjIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getCommentObjIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)commentObjId:(NSString *)obj_id content:(NSString *)content {
    NSDictionary *parameters = @{@"object_id":obj_id , @"content":content  , @"access_token":[self getUserToken]};
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/comment/create",API_URL];
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self commentObjIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self commentObjIdErrorResponse:[error localizedDescription]];
    }];
}
#pragma mark - Product Folder
- (void)getFolderList:(NSString *)limit padding:(NSString *)padding {
    NSString *urlStr = [[NSString alloc] init];
    if (![limit isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=0&limit=%@",API_URL,limit];
    } else if (![padding isEqualToString:@"NO"]) {
        urlStr = [[NSString alloc] initWithFormat:@"%@",padding];
    } else {
        urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=0",API_URL];
    }
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getFolderListResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getFolderListErrorResponse:[error localizedDescription]];
    }];
}

- (void)getFolderById:(NSString *)folder_id {
    //NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product?folder_id=%@",API_URL,folder_id];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=%@",API_URL,folder_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getFolderByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getFolderByIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getProductListByParentId:(NSString *)limit parent_id:(NSString *)parent_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product?folder_id=%@&limit=%@",API_URL,parent_id,limit];
    //NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=%@&limit=%@",API_URL,parent_id,limit];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getProductListByParentIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getProductListByParentIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getProductId:(NSString *)product_id {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/%@",API_URL,product_id];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getProductIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getProductIdErrorResponse:[error localizedDescription]];
    }];
}
- (void)getDrinkList {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=529&limit=999",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getDrinkListResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getDrinkListErrorResponse:[error localizedDescription]];
    }];
}
- (void)getDessertList {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=516&limit=999",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getDessertListResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getDessertListErrorResponse:[error localizedDescription]];
    }];
}
- (void)getBeensList {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=500&limit=999",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getBeensListResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getBeensListErrorResponse:[error localizedDescription]];
    }];
}
- (void)getFranchiseList {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@product/folder?parent_id=20&limit=999",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getFranchiseListResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getFranchiseListErrorResponse:[error localizedDescription]];
    }];
}

//product?folder_id=20

#pragma mark - Stamp
- (void)getStamp {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/stamp/%@",API_URL,[self getUserId]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getStampResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getStampErrorResponse:[error localizedDescription]];
    }];
}
- (void)stampAddPoint:(NSString *)point password:(NSString *)password {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/stamp/add_point/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"add_point":point , @"password":password  };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self stampAddPointResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self stampAddPointErrorResponse:[error localizedDescription]];
    }];
}
- (void)getStampStyle {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@stamp/style",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getStampStyleResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getStampStyleErrorResponse:[error localizedDescription]];
    }];
}
#pragma mark - contact
- (void)getContact {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@contact",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFMingMitrSDK:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFMingMitrSDK:self getContactErrorResponse:[error localizedDescription]];
    }];
}
#pragma mark - CoreData

/**
 *  Get User Enitites From Core Data
 */
- (void)getUserEnitites {
    
}
/**
 *  Get Auth Enitites From Core Data
 */
- (void)getAuthEnitites {
    
}

- (void)setAuthEnitiesField:(NSString *)field value:(NSString *)value {
    
}
//!!!: Test SDK
- (void)testSDK {
    //EntitiesUtility *en = [[EntitiesUtility alloc] init];
    
    //DDLogInfo(@"%@",[en removeAuthAllRecord]);
    //DDLogInfo(@"%@",[en setAuthData]);
    //DDLogInfo(@"%@",[en getAuthData]);
    
    /*
    DDLogError(@"This is an error.");
    DDLogWarn(@"This is a warning.");
    DDLogInfo(@"This is just a message.");
    DDLogVerbose(@"This is a verbose message.");
     */
}
@end
