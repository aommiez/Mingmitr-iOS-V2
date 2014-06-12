//
//  AuthData.h
//  MingMitr
//
//  Created by MRG on 4/30/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AuthData : NSManagedObject

@property (nonatomic, retain) NSString * login_status;
@property (nonatomic, retain) NSString * who;
@property (nonatomic, retain) NSString * guest_token;

@end
