//
//  NSDictionary+DeepCopy.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 20/06/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DeepCopy)

- (NSMutableDictionary *)mutableDeepCopy;

@end

@interface NSArray (DeepCopy)

- (NSMutableArray *)mutableDeepCopy;

@end
