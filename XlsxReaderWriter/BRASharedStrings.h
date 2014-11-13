//
//  BRASharedStrings.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRASharedString.h"

@class BRAStyles;

@interface BRASharedStrings : BRARelationship

- (void)addSharedString:(BRASharedString *)sharedString;

@property (nonatomic, weak) BRAStyles *styles;
@property (nonatomic, strong) NSArray *sharedStrings;

@end
