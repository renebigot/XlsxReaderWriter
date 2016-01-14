//
//  BRASharedString.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 07/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRASharedString.h"

@implementation BRASharedString

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString inStyles:(BRAStyles *)styles {
    if (self = [super initWithOpenXmlAttributes:nil]) {
        _attributedString = attributedString.mutableCopy;
        _styles = styles;
    }
    
    return self;
}

- (void)loadAttributes {
    _attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
}

- (void)refreshContent {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];

    if (_attributedString.length > 0) {
        [_attributedString deleteCharactersInRange:NSMakeRange(0, _attributedString.length)];
    }
    
    //String can be a text (t) or a run (r)
    if (dictionaryRepresentation[@"r"]) {
        
        NSArray *runs = [dictionaryRepresentation arrayValueForKeyPath:@"r"];
        
        //Run (r)
        for (NSDictionary *textDict in runs) {
            NSAttributedString *attributedSubstring = [[NSAttributedString alloc] initWithString:[self stringFromTextDictionary:textDict]
                                                                                      attributes:[_styles attributedStringAttributesFromOpenXmlAttributes:textDict[@"rPr"]]];
            [_attributedString appendAttributedString:attributedSubstring];
        }
        
    } else if (dictionaryRepresentation[@"t"]) {
        
        //Text (t)
        [_attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[self stringFromTextDictionary:dictionaryRepresentation]]];
        
    }
}

- (NSString *)stringFromTextDictionary:(NSDictionary *)dictionary {
    NSString *retVal = nil;
    
    if ([dictionary[@"t"] isKindOfClass:[NSString class]]) {
        retVal = dictionary[@"t"];
    } else if ([dictionary[@"t"] isKindOfClass:[NSDictionary class]]) {
        retVal = [dictionary[@"t"] innerText];
    } else {
        retVal = @"";
    }
    
    return retVal ? retVal : @"";
}

- (NSAttributedString *)attributedString {
    return _attributedString;
}

- (void)setStyles:(BRAStyles *)styles {
    _styles = styles;
    
    //Need workbook styles to compute attributed string
    [self refreshContent];
}

#pragma mark - 

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    if (dictionaryRepresentation != nil) {
        return dictionaryRepresentation;
    }
    
    dictionaryRepresentation = @{}.mutableCopy;
    NSMutableArray *attributesArray = @[].mutableCopy;
    
    BOOL __block runHasProperties = NO;
    
    [_attributedString enumerateAttributesInRange:NSMakeRange(0, _attributedString.length)
                                         options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                             //Text string
                                             NSString *subString = [[_attributedString string] substringWithRange:range];
                                             NSMutableDictionary *subAttributes = @{
                                                                                    @"__text": subString,
                                                                                    }.mutableCopy;
                                             
                                             if ([subString characterAtIndex:0] == ' ' || [subString characterAtIndex:subString.length - 1] == ' ') {
                                                 subAttributes[@"_xml:space"] = @"preserve";
                                             }
                                             
                                             NSMutableDictionary *runPropertiesDictionary = @{}.mutableCopy;
                                             
                                             //Font color
                                             if (value[NSForegroundColorAttributeName]) {
                                                 BRANativeColor *color = value[NSForegroundColorAttributeName];
                                                 
                                                 [runPropertiesDictionary setValue:[_styles openXmlAttributesWithColor:color] forKeyPath:@"color"];
                                             }
                                             
                                             //Font name & size
                                             if (value[NSFontAttributeName]) {
                                                 BRANativeFont *font = value[NSFontAttributeName];
                                                 BRANativeFontDescriptor *fontProperties = font.fontDescriptor;
                                                 
                                                 if (fontProperties.fontAttributes[BRANativeFontDescriptorSizeAttribute]) {
                                                     NSNumber *sizeNumber = fontProperties.fontAttributes[BRANativeFontDescriptorSizeAttribute];
                                                     
                                                     [runPropertiesDictionary setValue:@{@"_val": [NSString stringWithFormat:@"%ld", [sizeNumber longValue]]} forKeyPath:@"sz"];
                                                 }
                                             }
                                             
                                             //Strike
                                             if (value[NSStrikethroughStyleAttributeName]) {
                                                 if ([value[NSStrikethroughStyleAttributeName] integerValue] == NSUnderlineStyleDouble) {
                                                     [runPropertiesDictionary setValue:@{@"_val": @"1"} forKeyPath:@"dstrike"];
                                                 } else if ([value[NSStrikethroughStyleAttributeName] integerValue] > NSUnderlineStyleNone) {
                                                     [runPropertiesDictionary setValue:@{@"_val": @"1"} forKeyPath:@"strike"];
                                                 }
                                             }
                                             
                                             if (runPropertiesDictionary.count > 0) {
                                                 runHasProperties = YES;
                                                 [attributesArray addObject:@{
                                                                              @"t": subAttributes,
                                                                              @"rPr": runPropertiesDictionary
                                                                              }];
                                             } else {
                                                 [attributesArray addObject:@{
                                                                              @"t": subAttributes
                                                                              }];
                                             }
                                         }];

    
    if (runHasProperties) {
        dictionaryRepresentation[@"r"] = attributesArray;
    } else if (attributesArray.count > 0) {
        dictionaryRepresentation = attributesArray[0];
    }

    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

@end
