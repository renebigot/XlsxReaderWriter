//
//  BRANumberFormat.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 08/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@class BRAStyles;

typedef enum : NSUInteger {
    kBRAFormatCodeTypeNone = 0,
    kBRAFormatCodeTypePercentage,
    kBRAFormatCodeTypeDateTime,
    kBRAFormatCodeTypeCurrency,
    kBRAFormatCodeTypeFraction,
    kBRAFormatCodeTypeNumber
} BRAFormatCodeType;

typedef struct {
    NSInteger numerator;
    NSInteger denominator;
    CGFloat error;
} BRAFraction;


@interface BRANumberFormatData : NSObject

- (instancetype)initWithCode:(NSString *)code;

@property (nonatomic) BOOL hasThousands;
@property (nonatomic) BOOL isScientific;
@property (nonatomic) NSInteger exponentLength;
@property (nonatomic) NSInteger minWidth;
@property (nonatomic) NSInteger decimals;
@property (nonatomic) NSInteger precision;
@property (nonatomic) BRAFormatCodeType type;
@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSString *exponentSymbol;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) BRANativeColor *color;

@end

@interface BRANumberFormat : BRAOpenXmlSubElementWithStyle {
    BRANumberFormatData *_cacheData;
    NSArray *_numberFormatParts;
}

@property (nonatomic, strong) NSString *formatCode;
@property (nonatomic, strong) NSString *formatId;

- (instancetype)initWithFormatCode:(NSString *)formatCode andId:(NSInteger)formatId inStyles:(BRAStyles *)styles;
- (NSAttributedString *)formatNumber:(CGFloat)number;

@end
