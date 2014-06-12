//
//  PFHelper.m
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFHelper.h"

@implementation PFHelper
- (NSString *)genRandStringLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (NSString *)getUdid {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [array enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         NSNumber *index = [NSNumber numberWithInteger:idx];
         [mutableDictionary setObject:obj forKey:index];
     }];
    NSDictionary *result = [NSDictionary.alloc initWithDictionary:mutableDictionary];
    return result;
}
@end
