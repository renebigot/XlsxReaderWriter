//
//  BRACellFormat.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 08/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRACellFormat.h"
#import "BRAStyles.h"
#import "BRACellFill.h"

@implementation BRACellFormat

- (void)loadAttributes {
    _isCellStyleXf = NO;
    
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    
    //Text alignment
    if (![dictionaryRepresentation.attributes[@"applyAlignment"] isEqual:@"0"]) {
        NSString *horizontalAlignment = [dictionaryRepresentation valueForKeyPath:@"alignment._horizontal"];
        
        if ([horizontalAlignment isEqual:@"center"]) {
            _textAlignment = NSTextAlignmentCenter;
        } else if ([horizontalAlignment isEqual:@"right"]) {
            _textAlignment = NSTextAlignmentRight;
        } else if ([horizontalAlignment isEqual:@"left"]) {
            _textAlignment = NSTextAlignmentLeft;
        } else if ([horizontalAlignment isEqual:@"justified"]) {
            _textAlignment = NSTextAlignmentJustified;
        }
    } else {
        _textAlignment = 0;
    }
    
    //Cell fill
    if ([dictionaryRepresentation.attributes[@"applyFill"] boolValue] && dictionaryRepresentation.attributes[@"fillId"] != nil) {
        _cellFill = _styles.cellFills[[dictionaryRepresentation.attributes[@"fillId"] integerValue]];
    }

    //String attributes
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = [self textAlignment];
    
    NSMutableDictionary *attributedStringAttributes = nil;
    
    if (dictionaryRepresentation.attributes[@"fontId"] != nil && [dictionaryRepresentation.attributes[@"fontId"] integerValue] != NSNotFound) {
        _stylesTextsAttributes = _styles.textsAttributes[[dictionaryRepresentation.attributes[@"fontId"] integerValue]];

        attributedStringAttributes = @{
                                       NSParagraphStyleAttributeName: paragraphStyle
                                       }.mutableCopy;
        [attributedStringAttributes addEntriesFromDictionary:_stylesTextsAttributes];
        
        _textAttributes = attributedStringAttributes;
    }
    
    //Number format
    if (dictionaryRepresentation.attributes[@"applyNumberFormat"] && ![dictionaryRepresentation.attributes[@"applyNumberFormat"] isEqual:@"0"]) {
        _numberFormat = _styles.numberFormats[dictionaryRepresentation.attributes[@"numFmtId"]];
    } else {
        //General format
        _numberFormat = _styles.numberFormats[@"0"];
    }
    
    //Protection
    _protected = [dictionaryRepresentation.attributes[@"applyProtection"] boolValue];
    
    //cellXfs xf entries may have a reference to an existing cellStyleXfs xf entry
    if (dictionaryRepresentation.attributes[@"xfId"] == nil) {
        _isCellStyleXf = YES;
        _cellStyleFormat = _styles.cellStyleFormats[[dictionaryRepresentation.attributes[@"xfId"] integerValue]];
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    
    //Text alignment
    if (_textAlignment == 0) {
        [dictionaryRepresentation setValue:@"0" forKeyPath:@"_applyAlignment"];
    } else {
        [dictionaryRepresentation setValue:@"1" forKeyPath:@"_applyAlignment"];
        switch (_textAlignment) {
            case NSTextAlignmentCenter:
                [dictionaryRepresentation setValue:@"center" forKeyPath:@"alignment._horizontal"];
                break;

            case NSTextAlignmentJustified:
                [dictionaryRepresentation setValue:@"justified" forKeyPath:@"alignment._horizontal"];
                break;

            case NSTextAlignmentRight:
                [dictionaryRepresentation setValue:@"right" forKeyPath:@"alignment._horizontal"];
                break;

            default:
                [dictionaryRepresentation setValue:@"left" forKey:@"alignment._horizontal"];
                break;
        }
    }
    
    //Fill
    if (_cellFill == nil) {
        [dictionaryRepresentation setValue:@"0" forKey:@"_applyFill"];
        [dictionaryRepresentation setValue:@"0" forKey:@"_fillId"];
    } else {
        [dictionaryRepresentation setValue:@"1" forKey:@"_applyFill"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[_styles.cellFills indexOfObject:_cellFill]] forKey:@"_fillId"];
    }
    
    //String attributes
    if (_textAttributes == nil) {
        [dictionaryRepresentation setValue:@"0" forKey:@"_fontId"];
    } else {
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[_styles.textsAttributes indexOfObject:_stylesTextsAttributes]] forKey:@"_fontId"];
    }

    //Number format
    if (_numberFormat == nil || [_numberFormat isEqual:_styles.numberFormats[@"@"]]) {
        [dictionaryRepresentation setValue:@"0" forKey:@"_applyNumberFormat"];
        [dictionaryRepresentation setValue:@"0" forKey:@"_numFmtId"];
    } else {
        [dictionaryRepresentation setValue:@"1" forKey:@"_applyNumberFormat"];
        NSString __block *numFmtId = @"0";
        [_styles.numberFormats enumerateKeysAndObjectsUsingBlock:^(NSString *key, BRANumberFormat *obj, BOOL *stop) {
            if ([obj isEqual:_numberFormat]) {
                numFmtId = key;
                *stop = YES;
            }
        }];
        [dictionaryRepresentation setValue:numFmtId forKey:@"_numFmtId"];
    }
    
    //Protection
    if (_isCellStyleXf) {
        [dictionaryRepresentation setValue:self.isProtected ? @"1" : @"0" forKey:@"_applyProtection"];
    }
    
    //Cell style format
    NSInteger cellStyleFormatId = [_styles.cellStyleFormats indexOfObject:_cellStyleFormat];
    if (cellStyleFormatId == NSNotFound) {
        cellStyleFormatId = 0;
    }
    [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)cellStyleFormatId] forKey:@"_xfId"];
    
    [super setDictionaryRepresentation:dictionaryRepresentation];

    return dictionaryRepresentation;
}

#pragma mark - Getters

- (BOOL)isProtected {
    if (_cellStyleFormat) {
        return _cellStyleFormat.protected || _protected;
    } else {
        return _protected;
    }
}

- (NSTextAlignment)textAlignment {
    if (_cellStyleFormat && _cellStyleFormat.textAlignment != 0) {
        return _cellStyleFormat.textAlignment;
    } else {
        return _textAlignment;
    }
}

- (BRACellFill *)cellFill {
    if (_cellStyleFormat && _cellStyleFormat.cellFill != nil) {
        return _cellStyleFormat.cellFill;
    } else {
        return _cellFill;
    }
}

- (NSDictionary *)textAttributes {
    if (_cellStyleFormat && _cellStyleFormat.textAttributes != nil) {
        return _cellStyleFormat.textAttributes;
    } else {
        return _textAttributes;
    }
}

- (BRANumberFormat *)numberFormat {
    if (_cellStyleFormat && _cellStyleFormat.numberFormat != nil) {
        return _cellStyleFormat.numberFormat;
    } else {
        return _numberFormat;
    }
}

#pragma mark - Setters

- (void)setCellFill:(BRACellFill *)cellFill {
    if (cellFill) {
        NSInteger index = [_styles.cellFills indexOfObject:_stylesTextsAttributes];
        
        if (index == NSNotFound) {
            NSMutableArray *cellFills = _styles.cellFills.mutableCopy;
            [cellFills addObject:cellFill];
            _styles.cellFills = cellFills;
        }
    }

    _cellFill = cellFill;
}

- (void)setNumberFormat:(BRANumberFormat *)numberFormat {
    if (numberFormat) {
        NSString *key = [[_styles.numberFormats keysOfEntriesPassingTest:^BOOL(id key, BRANumberFormat *obj, BOOL *stop) {
            if ([obj.formatCode isEqual:numberFormat.formatCode]) {
                *stop = YES;
                return YES;
            }
            
            return NO;
        }] anyObject];
        
        if (key) {
            numberFormat.formatId = key;
            
        } else {
            NSInteger tmpId = 100;
            NSString *formatId = [NSString stringWithFormat:@"%ld", (long)tmpId];
            while (_styles.numberFormats[formatId]) {
                formatId = [NSString stringWithFormat:@"%ld", (long)++tmpId];
            }
            
            numberFormat.formatId = formatId;
            NSMutableDictionary *numberFormats = _styles.numberFormats.mutableCopy;
            numberFormats[formatId] = numberFormat;
            _styles.numberFormats = numberFormats;
        }
    }
    _numberFormat = numberFormat;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>: Protected: %@  Number format: %@", [self class], self, _protected ? @"YES": @"NO", _numberFormat.formatCode];
}

@end
