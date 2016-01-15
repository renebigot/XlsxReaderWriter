//
//  BRAStyles.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 07/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRACellFill.h"
#import "BRACellFormat.h"
#import "BRANumberFormat.h"
#import "BRATheme.h"
#import "BRAPlatformSpecificDefines.h"

@interface BRAStyles : BRARelationship {
    NSDictionary *_attributes;
}

@property (nonatomic, strong) NSArray *indexedColors;
@property (nonatomic, strong) NSArray *textsAttributes;
@property (nonatomic, strong) NSArray *cellFormats;
@property (nonatomic, strong) NSArray *cellStyleFormats;
@property (nonatomic, strong) NSArray *cellFills;
@property (nonatomic, strong) NSDictionary *numberFormats;
@property (nonatomic, weak) BRATheme *theme;

- (void)loadThemableContent;
- (NSDictionary *)defaultNumberFormats;
- (NSDictionary *)attributedStringAttributesFromOpenXmlAttributes:(NSDictionary *)attributes;
- (BRANativeColor *)colorWithOpenXmlAttributes:(NSDictionary *)attributes;
- (NSDictionary *)openXmlAttributesWithColor:(BRANativeColor *)color;
- (NSString *)addNumberFormat:(BRANumberFormat *)numberFormat;
- (NSInteger)addStyleByCopyingStyleWithId:(NSInteger)styleId;

@end
