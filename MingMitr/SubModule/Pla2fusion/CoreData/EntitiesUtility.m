//
//  EntitiesUtility.m
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "EntitiesUtility.h"

@implementation EntitiesUtility

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Entities Setup

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"CoreData.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Entities method

-(NSArray*)getUserData {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntities"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedRecords count] == 0){
        return  false;
    } else {
        return fetchedRecords;
    }
    
    // Returning Fetched Records
    return false;
}

- (NSArray *)getAuthData {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AuthEntities"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%@",[[fetchedRecords objectAtIndex:0] objectForKey:@"who"]);
    //NSLog(@"%@",fetchedRecords);
    // Returning Fetched Records
    if ([fetchedRecords count] == 0){
        return  false;
    } else {
        return fetchedRecords;
    }

    return false;
}
- (NSString *)setUserIDAndToken:(NSString *)user_id token:(NSString *)token {
    UserData *userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserEntities"
                                                       inManagedObjectContext:self.managedObjectContext];
    userData.user_id = user_id;
    userData.token = token;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return @"ok";
}
- (NSString *)setUserData {
    return @"a";
}
- (void)setAuthData:(NSString *)loginStatus who:(NSString *)who guest_token:(NSString *)guest_token {
    
    AuthData *authData = [NSEntityDescription insertNewObjectForEntityForName:@"AuthEntities"
                                                      inManagedObjectContext:self.managedObjectContext];
    
    authData.login_status = loginStatus;
    authData.who = who;
    authData.guest_token = guest_token;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (NSString *)removeAuthAllRecord {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AuthEntities" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];

    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	return @"AuthEntities object deleted ";
    }
    if (![_managedObjectContext save:&error]) {
    	return @"Error deleting AuthEntities - error";
    }
    return @"AuthEntities object deleted ";
}

- (NSString *)removeUserAllRecord {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntities" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	return @"UserEntities object deleted ";
    }
    if (![_managedObjectContext save:&error]) {
    	return @"Error deleting AuthEntities - error";
    }
    return @"UserEntities object deleted ";
}





















@end
