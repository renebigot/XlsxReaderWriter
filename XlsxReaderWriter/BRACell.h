//
//  BRACell.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"
#import "BRACellFill.h"

@class BRAMergeCell, BRACellFormat, BRARow, BRAImage;

typedef enum : NSUInteger {
    BRACellContentTypeBoolean,
    BRACellContentTypeDate,
    BRACellContentTypeError,
    BRACellContentTypeInlineString,
    BRACellContentTypeNumber,
    BRACellContentTypeSharedString,
    BRACellContentTypeString,
    BRACellContentTypeUnknown
} BRACellContentType;

@interface BRACell : BRAOpenXmlSubElementWithWorksheet {
    NSDate *_dateValue;
    NSString *_formulaString;
}

//General
+ (NSString *)cellReferenceForColumnIndex:(NSInteger)columnIndex andRowIndex:(NSInteger)rowIndex;
- (instancetype)initWithReference:(NSString *)reference andStyleId:(NSInteger)styleId inWorksheet:(BRAWorksheet *)worksheet;
- (NSInteger)columnIndex;
- (NSString *)columnName;
- (NSInteger)rowIndex;

//Styles
- (void)setNumberFormat:(NSString *)numberFormat;
- (void)setCellFillWithForegroundColor:(BRANativeColor *)foregroundColor backgroundColor:(BRANativeColor *)backgroundColor andPatternType:(BRACellFillPatternType)patternType;
- (void)setCellFill:(BRACellFill *)cellFill;
- (void)setTextAlignment:(NSTextAlignment)alignment;
- (BRACellFill *)cellFill;
- (BRANativeColor *)cellFillColor;
- (NSString *)numberFormatCode;
- (NSTextAlignment)textAlignment;

//Cell content setters
- (void)setBoolValue:(BOOL)boolValue;
- (void)setIntegerValue:(NSInteger)integerValue;
- (void)setFloatValue:(float)floatValue;
- (void)setStringValue:(NSString *)stringValue;
- (void)setAttributedStringValue:(NSAttributedString *)attributedStringValue;
- (void)setDateValue:(NSDate *)date;
- (void)setFormulaString:(NSString *)formulaString;
- (void)setErrorValue:(NSString *)errorValue;

//Cell content getters
- (BOOL)boolValue;
- (NSInteger)integerValue;
- (float)floatValue;
- (NSString *)stringValue;
- (NSAttributedString *)attributedStringValue;
- (NSDate *)dateValue;
- (NSString *)formulaString;
- (NSString *)errorValue;



@property (nonatomic, strong) BRAMergeCell *mergeCell;
@property (nonatomic, strong) NSString *reference;

@property (nonatomic) NSInteger styleId;
@property (nonatomic) NSInteger sharedStringIndex;
@property (nonatomic) BRACellContentType type;
@property (nonatomic, getter=hasError) BOOL error;
@property (nonatomic, strong) NSString *value;

@end
