//
//  BRAColumn.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAColumn.h"

#define TRUNCATE(X) floor(X)

@implementation BRAColumn

+ (NSInteger)columnIndexForCellReference:(NSString *)cellReference {
    NSInteger retVal = 0;
    NSInteger pow = 1;

    for (NSInteger i = [cellReference length] - 1; i >= 0 ; i--) {
        unichar currentChar = [cellReference characterAtIndex:i];
        
        if (currentChar < 'A' || currentChar > 'Z') {
            continue;
        }
        
        retVal += (currentChar - 'A' + 1) * pow;
        pow *= 26;
    }
    
    return retVal;
}

+ (NSString *)columnNameForColumnIndex:(NSInteger)index {
    NSString *retVal = @"";
    
    while (index > 0) {
        NSInteger modulo = (index - 1) % 26;
        retVal = [NSString stringWithFormat:@"%c%@", (char)(65 + modulo), retVal];;
        index = (NSInteger)((index - modulo) / 26);
    }
    
    return retVal;
}

+ (NSString *)columnNameForCellReference:(NSString *)cellReference {
    NSMutableString *retVal = @"".mutableCopy;
    
    for (NSInteger i = 0; i < [cellReference length]; i++) {
        unichar currentChar = [cellReference characterAtIndex:i];
        
        if (currentChar < 'A' || currentChar > 'Z') {
            break;
        }
        
        [retVal appendFormat:@"%c", currentChar];
    }

    return retVal;
}

- (instancetype)initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum {
    if (self = [super initWithOpenXmlAttributes:@{
                                                  @"_min": [NSString stringWithFormat:@"%ld", (long)minimum],
                                                  @"_max": [NSString stringWithFormat:@"%ld", (long)maximum]
                                                  }
            ]) {
    }
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];

    _maximum = [dictionaryRepresentation.attributes[@"max"] integerValue];
    _minimum = [dictionaryRepresentation.attributes[@"min"] integerValue];

    if (dictionaryRepresentation.attributes[@"customWidth"]) {
        _customWidth = [dictionaryRepresentation.attributes[@"customWidth"] boolValue];
    }

    if (dictionaryRepresentation.attributes[@"width"]) {
        _width = [dictionaryRepresentation.attributes[@"width"] floatValue];
    }
}

- (NSInteger)pointWidth {
    //More info : 18.3.1.13
    //7 is Calibri 11pt max digit width
    CGFloat width = TRUNCATE((_width * 7. + 5.) / 7. * 256.) / 256.;
    
    return TRUNCATE(((256. * width + TRUNCATE(128. / 7.)) / 256.) * 7.);
}

- (void)setPointWidth:(NSInteger)pointWidth {
    _width = TRUNCATE((pointWidth - 5.) / 7. * 100. + .5) / 100.;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    dictionaryRepresentation[@"_min"] = [NSString stringWithFormat:@"%ld", (long)_minimum];
    dictionaryRepresentation[@"_max"] = [NSString stringWithFormat:@"%ld", (long)_maximum];
    dictionaryRepresentation[@"_width"] = [NSString stringWithFormat:@"%ld", (long)_width];
    dictionaryRepresentation[@"_customWidth"] = [NSString stringWithFormat:@"%ld", (long)_customWidth];

    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> : %ld", [self class], self, (long)_minimum];
}

@end
