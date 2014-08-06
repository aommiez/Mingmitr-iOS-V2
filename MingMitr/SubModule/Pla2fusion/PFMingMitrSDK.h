//
//  PFMingMitrSDK.h
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AFNetworking.h"
#import "PFHelper.h"
// first, you need to import CocoaLumberjack files
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
// then, you could also add NXVLogFormatter whenever you need it
#import "NXVLogFormatter.h"
// Enitites
#import "EntitiesUtility.h"


@protocol PFMingMitrSDKDelegate <NSObject>

#pragma mark - Core Protocal Delegate
- (void)PFMingMitrSDK:(id)sender getLinkResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getLinkErrorResponse:(NSString *)errorResponse;

#pragma mark - User Protocal Delegate
- (void)PFMingMitrSDK:(id)sender registerWithUsernameResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender LoginWithFacebookResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender LoginWithFacebookErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getMeResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getMeErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getSettingResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getSettingErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender settingNewsResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender settingNewsErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender settingMessageResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender settingMessageErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getUserByIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getUserByIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender updateUserByIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender updateUserByIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender LoginWithUsernameResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender LoginWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - News Protocal Delegate
- (void)PFMingMitrSDK:(id)sender getNewsResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getNewsErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getNewsByIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getNewsByIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getCommentObjIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getCommentObjIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender commentObjIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender commentObjIdErrorResponse:(NSString *)errorResponse;

#pragma mark - Product Folder Protocal Delegate
- (void)PFMingMitrSDK:(id)sender getFolderListResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getFolderListErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getFolderByIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getFolderByIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getProductListByParentIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getProductListByParentIdErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getProductIdResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getProductIdErrorResponse:(NSString *)errorResponse;

- (void)PFMingMitrSDK:(id)sender getDrinkListResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getDrinkListErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getDessertListResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getDessertListErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getBeensListResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getBeensListErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getFranchiseListResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getFranchiseListErrorResponse:(NSString *)errorResponse;


#pragma mark - Stamp Protocal Delegate
- (void)PFMingMitrSDK:(id)sender getStampResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getStampErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender stampAddPointResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender stampAddPointErrorResponse:(NSString *)errorResponse;
- (void)PFMingMitrSDK:(id)sender getStampStyleResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getStampStyleErrorResponse:(NSString *)errorResponse;


#pragma mark - Contact Protocal Delegate
- (void)PFMingMitrSDK:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PFMingMitrSDK:(id)sender getContactErrorResponse:(NSString *)errorResponse;


@end

@interface PFMingMitrSDK : NSObject



#pragma mark - Property
@property PFHelper *hp;
@property EntitiesUtility *en;
@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property (assign, nonatomic) id delegate;

#pragma mark - Core Apps 
- (NSString *)getAuth;
- (NSString *)getUserToken;
- (NSString *)getGuestToken;
- (void)getLink:(NSString *)link;

#pragma mark - User
- (void)getMe;
- (void)getSetting;
- (void)settingNews:(NSString *)status;
- (void)settingMessage:(NSString *)status;
- (void)getUserById:(NSString *)user_id;
- (void)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email gender:(NSString *)gender  birth_date:(NSString *)birth_date;
- (void)LoginWithFacebook:(NSString *)facebook_token ios_device_token:(NSString *)ios_device_token;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password;
- (void)updateUserById:(NSString *)user_id display_name:(NSString *)display_name picture:(NSString *)picture_base64 mobile_phone:(NSString *)mobile_phone website:(NSString *)website gender:(NSString *)gender birth_date:(NSString *)birth_date;
- (void)LoginWithUsername:(NSString *)username password:(NSString *)password ios_device_token:(NSString *)ios_device_token;
- (void)setUserIdAndTokenToCoreData:(NSString *)user_id token:(NSString *)token;
- (void)logOut;
#pragma mark - News
- (void)getNews:(NSString *)limit next:(NSString *)next;
- (void)getNewsById:(NSString *)news_id;
- (void)getCommentObjId:(NSString *)obj_id padding:(NSString *)padding;
- (void)commentObjId:(NSString *)obj_id content:(NSString *)content;

#pragma mark - Product & Folder
- (void)getFolderList:(NSString *)limit padding:(NSString *)padding;
- (void)getFolderById:(NSString *)folder_id;
- (void)getProductListByParentId:(NSString *)limit parent_id:(NSString *)parent_id;
- (void)getProductId:(NSString *)product_id;
- (void)getDrinkList;
- (void)getDessertList;
- (void)getBeensList;
- (void)getFranchiseList;
#pragma mark - Stamp
- (void)getStamp;
- (void)stampAddPoint:(NSString *)point password:(NSString *)password;
- (void)getStampStyle;


#pragma mark - Contact
- (void)getContact;

#pragma mark - Core Data
- (void)getUserEnitites;
- (void)getAuthEnitites;
- (void)setAuthEnitiesField:(NSString *)field value:(NSString *)value;
//!!!: Test SDK
- (void)testSDK;
@end
