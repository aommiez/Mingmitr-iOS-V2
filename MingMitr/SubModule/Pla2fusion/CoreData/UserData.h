//
//  UserData.h
//  MingMitr
//
//  Created by MRG on 4/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSString * birth_date;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * email_show;
@property (nonatomic, retain) NSString * facebook_id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * guest_token;
@property (nonatomic, retain) NSString * ios_device_token;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * member_timeout;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * phone_show;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * username;

@end
