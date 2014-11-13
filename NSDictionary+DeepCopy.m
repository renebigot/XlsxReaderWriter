//
//  NSDictionary+DeepCopy.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 20/06/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "NSDictionary+DeepCopy.h"

@implementation NSDictionary (DeepCopy)

- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSArray *keys = [self allKeys];
    
    for(id key in keys) {
        id oneValue = [self objectForKey:key];
        id oneCopy = nil;
        
        if([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        }
        else if([oneValue respondsToSelector:@selector(mutableCopy)]) {
            oneCopy = [oneValue mutableCopy];
        }
        else {
            oneCopy = [oneValue copy];
        }
        [returnDict setValue:oneCopy forKey:key];
    }
    return returnDict;
}

@end

@implementation NSArray (DeepCopy)

- (NSMutableArray *)mutableDeepCopy {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for(NSInteger i = 0; i < [self count]; i++) {
        id oneValue = self[i];
        id oneCopy = nil;
        
        if([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        }
        else if([oneValue respondsToSelector:@selector(mutableCopy)]) {
            oneCopy = [oneValue mutableCopy];
        }
        else {
            oneCopy = [oneValue copy];
        }
        returnArray[i] = oneCopy;
    }
    return returnArray;
}

@end
