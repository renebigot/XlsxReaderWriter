//
//  BRAContentTypesDefaultExtension.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 23/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOpenXmlSubElement.h"

@class BRARelationship;

@interface BRAContentTypesDefaultExtension : BRAOpenXmlSubElement

- (instancetype)initWithExtension:(NSString *)extension;

@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *contentType;

@end
