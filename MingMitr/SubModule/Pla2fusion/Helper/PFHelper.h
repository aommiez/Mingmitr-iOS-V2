//
//  PFHelper.h
//  MingMitr
//
//  Created by MRG on 4/18/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFHelper : NSObject
- (NSString *)genRandStringLength:(int)len;
- (NSString *)getUdid;
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array;
@end
