//
//  BRAContentTypes.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlElement.h"
#import "NSDictionary+OpenXMLDictionaryParser.h"
#import "BRAContentTypesDefaultExtension.h"
#import "BRAContentTypesOverride.h"

typedef NSString *BRAContentType;

@class BRARelationship;

@interface BRAContentTypes : BRAOpenXmlElement

- (BOOL)hasOverrideForPart:(NSString *)partName;
- (BOOL)hasContentTypeForPart:(NSString *)partName;
- (void)addContentTypeForExtension:(NSString *)extension;
- (void)overrideContentType:(NSString *)contentType forPart:(NSString *)partName;

@property (nonatomic, strong) NSArray *defaultExtensions;
@property (nonatomic, strong) NSArray *overrides;

@end
