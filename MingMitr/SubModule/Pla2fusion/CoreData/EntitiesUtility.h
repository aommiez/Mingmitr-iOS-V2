//
//  EntitiesUtility.h
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthData.h"
#import "UserData.h"

@interface EntitiesUtility : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext       *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSArray *)getUserData;
- (NSArray *)getAuthData;
- (NSString *)setUserData;
- (void)setAuthData:(NSString *)loginStatus who:(NSString *)who guest_token:(NSString *)guest_token;
- (NSString *)removeAuthAllRecord;
- (NSString *)removeUserAllRecord;
- (NSString *)setUserIDAndToken:(NSString *)user_id token:(NSString *)token;



@end
