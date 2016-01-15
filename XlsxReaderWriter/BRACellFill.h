//
//  BRACellFill.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 07/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@class BRAStyles;

typedef NSString* BRACellFillPatternType;
static BRACellFillPatternType kBRACellFillPatternTypeNone              = @"none";
static BRACellFillPatternType kBRACellFillPatternTypeSolid             = @"solid";
static BRACellFillPatternType kBRACellFillPatternTypeDarkGray          = @"darkGray";
static BRACellFillPatternType kBRACellFillPatternTypeMediumGray        = @"mediumGray";
static BRACellFillPatternType kBRACellFillPatternTypeLightGray         = @"lightGray";
static BRACellFillPatternType kBRACellFillPatternTypeGray125           = @"gray125";
static BRACellFillPatternType kBRACellFillPatternTypeGray0625          = @"gray0625";
static BRACellFillPatternType kBRACellFillPatternTypeDarkHorizontal    = @"darkHorizontal";
static BRACellFillPatternType kBRACellFillPatternTypeDarkVertical      = @"darkVertical";
static BRACellFillPatternType kBRACellFillPatternTypeDarkDown          = @"darkDown";
static BRACellFillPatternType kBRACellFillPatternTypeDarkUp            = @"darkUp";
static BRACellFillPatternType kBRACellFillPatternTypeDarkGrid          = @"darkGrid";
static BRACellFillPatternType kBRACellFillPatternTypeDarkTrellis       = @"darkTrellis";
static BRACellFillPatternType kBRACellFillPatternTypeLightHorizontal   = @"lightHorizontal";
static BRACellFillPatternType kBRACellFillPatternTypeLightVertical     = @"lightVertical";
static BRACellFillPatternType kBRACellFillPatternTypeLightDown         = @"lightDown";
static BRACellFillPatternType kBRACellFillPatternTypeLightUp           = @"lightUp";
static BRACellFillPatternType kBRACellFillPatternTypeLightGrid         = @"lightGrid";
static BRACellFillPatternType kBRACellFillPatternTypeLightTrellis      = @"lightTrellis";


@interface BRACellFill : BRAOpenXmlSubElementWithStyle

- (instancetype)initWithForegroundColor:(BRANativeColor *)foregroundColor backgroundColor:(BRANativeColor *)backgroundColor andPatternType:(BRACellFillPatternType)patternType inStyles:(BRAStyles *)styles;
- (BRANativeColor *)patternedColor;

@property (nonatomic, strong) BRANativeColor *backgroundColor;
@property (nonatomic, strong) BRANativeColor *foregroundColor;
@property (nonatomic, strong) BRACellFillPatternType patternType;

@end
