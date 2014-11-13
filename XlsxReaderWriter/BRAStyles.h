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

@interface BRAStyles : BRARelationship

@property (nonatomic, strong) NSArray *indexedColors;
@property (nonatomic, strong) NSArray *textsAttributes;
@property (nonatomic, strong) NSArray *cellFormats;
@property (nonatomic, strong) NSArray *cellStyleFormats;
@property (nonatomic, strong) NSArray *cellFills;
@property (nonatomic, strong) NSDictionary *numberFormats;

- (UIColor *)colorWithOpenXmlAttributes:(NSDictionary *)attributes;
- (NSDictionary *)openXmlAttributesWithColor:(UIColor *)color;
- (NSDictionary *)attributedStringAttributesFromOpenXmlAttributes:(NSDictionary *)attributes;
- (NSString *)addNumberFormat:(BRANumberFormat *)numberFormat;
- (NSInteger)addStyleByCopyingStyleWithId:(NSInteger)styleId;

@end
