//
//  BRANumberFormat.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 08/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRANumberFormat.h"
#import "BRAStyles.h"

@implementation BRANumberFormatData

- (instancetype)initWithCode:(NSString *)code {
    if (self = [super init]) {
        _code = code;
        _hasThousands = NO;
        _isScientific = NO;
        _scale = 1;
        _type = kBRAFormatCodeTypeNone;
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *description = @"".mutableCopy;
    
    switch ((NSInteger)_type) {
        case kBRAFormatCodeTypeCurrency:
            [description appendString:@"[Currency]    "];
            break;
            
        case kBRAFormatCodeTypeDateTime:
            [description appendString:@"[DateTime]    "];
            break;
            
        case kBRAFormatCodeTypeFraction:
            [description appendString:@"[Fraction]    "];
            break;

        case kBRAFormatCodeTypePercentage:
            [description appendString:@"[Percentage]    "];
            break;
            
        default:
            [description appendString:@"[Unknown]    "];
    }
    
    [description appendString:@"Code: "];
    [description appendString:_code ? _code : @"none"];
    [description appendString:@"    "];
    
    [description appendString:@"Pattern: "];
    [description appendString:_pattern ? _pattern : @"none"];
    [description appendString:@"    "];
    
    [description appendString:@"Currency symbol: "];
    [description appendString:_currency ? _currency : @"none"];
    [description appendString:@"    "];
    
    [description appendString:@"Color: "];
    [description appendString:_color ? [_color hexStringValue] : @"none"];

    return description;
}

@end

@implementation BRANumberFormat

- (instancetype)initWithFormatCode:(NSString *)formatCode andId:(NSInteger)formatId inStyles:(BRAStyles *)styles {
    if (self = [super initWithOpenXmlAttributes:@{@"_formatCode": formatCode, @"_numFmtId": [NSString stringWithFormat:@"%ld", (long)formatId]}]) {
        _styles = styles;
    }
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    
    _formatId = dictionaryRepresentation[@"_numFmtId"];
    _formatCode = dictionaryRepresentation[@"_formatCode"];
    if ([_formatCode isEqual:@"@"]) {
//        _formatCode = GENERAL_NUMBER_FORMAT_CODE;
    }
    
    NSMutableArray *numberFormats = @[].mutableCopy;
    
    //Get format code for number value
    NSArray *sections = [_formatCode componentsSeparatedByString:@";"];
    
    for (NSInteger i = 0; i < [sections count]; i++) {
        _cacheData = [[BRANumberFormatData alloc] initWithCode:sections[i]];
        
        //Apply color
        NSString *colorString = [self colorStringFromFormatCode:_cacheData.code];
        if (colorString) {
            _cacheData.color = [self colorFromColorString:colorString];
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:colorString withString:@""];
        }
        
        //--------- Get data type
        if ([self isPercentageCode:_cacheData.code]) {
            //----Percentages
            _cacheData.type = kBRAFormatCodeTypePercentage;
            
        } else if ([self isDateTimeCode:_cacheData.code]) {
            //----Date time
            _cacheData.type = kBRAFormatCodeTypeDateTime;
            _cacheData.code = [[[_cacheData.code stringByReplacingOccurrencesOfString:[self nonDateTimeFormatStringInCode:_cacheData.code] withString:@""] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
// TODO : [S] [M] [H]
            _cacheData.code = [self replaceOpenXmlFormatCodesWithNSFormatterCodesInString:_cacheData.code];
        } else {
            //Removing skipped characters
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"_." withString:@""];
            //Removing unnecessary escaping
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            //Removing string quotes
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"*" withString:@""];
            
            //Removing thousands separator
            _cacheData.hasThousands = ([_cacheData.code rangeOfString:@"0,0"].location != NSNotFound || [_cacheData.code rangeOfString:@"#,#"].location != NSNotFound);
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"0,0" withString:@"00"];
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"#,#" withString:@"##"];
            
            //Scaling (commas indicate the power)
            _cacheData.scale = 1;
            if ([_cacheData.code rangeOfString:@"0,"].location != NSNotFound || [_cacheData.code rangeOfString:@"#,"].location != NSNotFound) {
                _cacheData.scale = 1000;
                _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"0," withString:@"0"];
                _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"#," withString:@"#"];
            }
            
            if ([self isFractionCode:_cacheData.code]) {
                //----Fraction
                _cacheData.type = kBRAFormatCodeTypeFraction;
            } else {
                _cacheData.type = kBRAFormatCodeTypeNumber;
                _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"#" withString:@""];
                
                [self createPatternCacheFromCode:_cacheData.code];
            }
            
            //Remove E+, E-, e+, e-
            if ([_cacheData.code rangeOfString:@"e+"].location != NSNotFound || [_cacheData.code rangeOfString:@"e-"].location != NSNotFound) {
                _cacheData.exponentSymbol = @"e";
            } else if ([_cacheData.code rangeOfString:@"E+"].location != NSNotFound || [_cacheData.code rangeOfString:@"E-"].location != NSNotFound) {
                _cacheData.exponentSymbol = @"E";
            }
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"e+" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, _cacheData.code.length)];
            _cacheData.code = [_cacheData.code stringByReplacingOccurrencesOfString:@"e-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, _cacheData.code.length)];
            
            
            //----Currency
            _cacheData.currency = [self currencyFromCode:_cacheData.code];
            
            _cacheData.code = [_cacheData.code stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
        }
        
        numberFormats[i] = _cacheData;
    }
    
    _numberFormatParts = numberFormats;
}

- (NSString *)colorStringFromFormatCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"^\\[[a-z0-9].*\\]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    if (results.count > 0) {
        return [formatCode substringWithRange:[results[0] range]];
    }
    
    return nil;
    
}

- (BRANativeColor *)colorFromColorString:(NSString *)colorString {
    if (colorString.length < 5) {
        return nil;
    }
    
    colorString = [colorString uppercaseString];
    
    if ([colorString isEqual:@"[BLACK]"]) {
        return [BRANativeColor blackColor];
    } else if ([colorString isEqual:@"[BLUE]"]) {
        return [BRANativeColor blueColor];
    } else if ([colorString isEqual:@"[CYAN]"]) {
        return [BRANativeColor cyanColor];
    } else if ([colorString isEqual:@"[GREEN]"]) {
        return [BRANativeColor greenColor];
    } else if ([colorString isEqual:@"[MAGENTA]"]) {
        return [BRANativeColor magentaColor];
    } else if ([colorString isEqual:@"[RED]"]) {
        return [BRANativeColor redColor];
    } else if ([colorString isEqual:@"[WHITE]"]) {
        return [BRANativeColor whiteColor];
    } else if ([colorString isEqual:@"[YELLOW]"]) {
        return [BRANativeColor yellowColor];
    } else if ([[colorString substringToIndex:5] isEqual:@"[COLOR"]) {
        NSInteger colorIndex = [[[colorString stringByReplacingOccurrencesOfString:@"[COLOR" withString:@""]
                                 stringByReplacingOccurrencesOfString:@"]" withString:@""] integerValue] + 8; //+8 described in 18.8.31
        
        return _styles.indexedColors[colorIndex];
    }
    
    return nil;
}

- (BOOL)isPercentageCode:(NSString *)formatCode {
    return [formatCode rangeOfString:@"%"].location != NSNotFound;
}

- (BOOL)isDateTimeCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"^(\\[\\$[[:alpha:]]*-[0-9A-F]*\\])*[\\[\\]hmsdy]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];

    return results.count > 0;
}

- (BOOL)isFractionCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"#?.*\\?\\/\\?"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    
    return results.count > 0;
}

- (void)createPatternCacheFromCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\]]+\\]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    
    if (results.count > 0) {
        formatCode = [formatCode stringByReplacingCharactersInRange:[results[0] range] withString:@""];
    }
    
    regEx = [NSRegularExpression regularExpressionWithPattern:@"([0#]+)(\\.?)([0#]*)(E?\\+?([0#]+))?"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
    
    results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    
    if (results.count > 0 && [results[0] numberOfRanges] == 6) {
        NSString *integerPart = [formatCode substringWithRange:[results[0] rangeAtIndex:1]];
        NSString *decimalPoint = [formatCode substringWithRange:[results[0] rangeAtIndex:2]];
        NSString *decimalPart = [formatCode substringWithRange:[results[0] rangeAtIndex:3]];
        
        _cacheData.minWidth = integerPart.length + decimalPoint.length + decimalPart.length;
        _cacheData.decimals = [decimalPart integerValue];
        _cacheData.precision = decimalPart.length;
        _cacheData.pattern = [NSString stringWithFormat:@"%%0%ld.%ldf", (long)_cacheData.minWidth, (long)_cacheData.precision];

        if ([results[0] rangeAtIndex:5].location != NSNotFound) {
            NSString *exponentPart = [formatCode substringWithRange:[results[0] rangeAtIndex:5]];
            _cacheData.exponentLength = [exponentPart length];
            _cacheData.isScientific = YES;
        }
    }
}

- (NSString *)nonDateTimeFormatStringInCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"^(\\[\\$[[:alpha:]]*-[0-9A-F]*\\])*"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    
    if (results.count > 0) {
        return [formatCode substringWithRange:[results[0] range]];
    }
    
    return @"";
}

- (NSString *)currencyFromCode:(NSString *)formatCode {
    NSError *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\[\\$(.*)\\]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *results = [regEx matchesInString:formatCode options:0 range:NSMakeRange(0., formatCode.length)];
    
    if (results.count > 0 && [results[0] numberOfRanges] > 1) {
        NSString *currencyCode = [formatCode substringWithRange:[results[0] rangeAtIndex:1]];
        
        if ([currencyCode componentsSeparatedByString:@"-"].count > 0) {
            currencyCode = [currencyCode componentsSeparatedByString:@"-"][0];
        }
        
        if (currencyCode.length > 0) {
            _cacheData.currency = currencyCode;
        } else {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            _cacheData.currency = [formatter currencySymbol];
        }
        
        return [formatCode substringWithRange:[results[0] range]];
    }

    return nil;
}

- (NSString *)replaceOpenXmlFormatCodesWithNSFormatterCodesInString:(NSString *)formatCode {
    //if AM/PM or am/pm or a/p or A/P is present, we sould present 12-hour
    BOOL hasAmPm = [[formatCode lowercaseString] rangeOfString:@"am/pm"].location != NSNotFound || [[formatCode lowercaseString] rangeOfString:@"a/p"].location != NSNotFound;
    
    //Seconds
    if ([formatCode rangeOfString:@"s"].location != NSNotFound) {
        //Conversion : [s] => [S],  ss => ss, s => s
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"[s]" withString:@"[S]"];
    }
    
    //Minutes
    if ([formatCode rangeOfString:@"[m]"].location != NSNotFound || [formatCode rangeOfString:@":m"].location != NSNotFound) {
        //Conversion [m] => [M], :mm => :mm, :m => :m (Mi for distinction with month)
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"[m]" withString:@"[Mi]"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@":mm" withString:@":MiMi"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@":m" withString:@":Mi"];
    }
    
    //Hour
    if ([formatCode rangeOfString:@"h"].location != NSNotFound) {
        //Conversion : [h] => [H], hh => hh or HH, h => h or H
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"[h]" withString:@"[H]"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"h" withString:hasAmPm ? @"h" : @"H"];
    }
    
    //Day
    if ([formatCode rangeOfString:@"d"].location != NSNotFound) {
        //Conversion : dddd => EEEE, dddd => EEE, dd => dd, d => d
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"dddd" withString:@"EEEE"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"ddd" withString:@"EEE"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"dd" withString:@"dd"];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"d" withString:@"d"];
    }
    
    //Month
    if ([formatCode rangeOfString:@"m"].location != NSNotFound) {
        //Conversion : mmmmm => MMMMM, mmmm => MMMM, mmm => MMM, mm => MM, m => M
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"m" withString:@"M"];
    }
    
    //Minute (again)
    if ([formatCode rangeOfString:@"Mi"].location != NSNotFound) {
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"Mi" withString:@"m"];
    }
    
    //Year
    //Conversion : yyyy => yyyy, yy => yy
    //Nothing to do

    //AM / PM
    if (hasAmPm) {
        //Conversion : am/pm => [AP], a/p => [AP]
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"am/pm" withString:@"a" options:NSCaseInsensitiveSearch range:NSMakeRange(0, formatCode.length)];
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"a/p" withString:@"a" options:NSCaseInsensitiveSearch range:NSMakeRange(0, formatCode.length)];
    }
    
    if ([formatCode rangeOfString:@"\\"].location != NSNotFound) {
        formatCode = [formatCode stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }

    return formatCode;
}

- (NSInteger)greatestCommonDivisonWithErrorFor:(NSInteger)intA and:(NSInteger)intB {
    //GCD Algorithm with error tolerance (Ex.: 0.33 -> 1/3)
    while ((CGFloat)MIN(intA, intB) / (CGFloat)MAX(intA, intB) < 0.9) {
        if (intA > intB) {
            intA -= intB;
        } else {
            intB -= intA;
        }
    }
    
    return intA;
}

- (NSInteger)greatestCommonDivisonFor:(NSInteger)intA and:(NSInteger)intB {
    //GCD Algorithm with error tolerance (Ex.: 0.33 -> 1/3)
    while (intA != intB) {
        if (intA > intB) {
            intA -= intB;
        } else {
            intB -= intA;
        }
    }
    
    return intA;
}

- (BRAFraction)convertToFraction:(CGFloat)number withDenominatorLength:(NSInteger)denominatorLength  {
    BRAFraction fraction;
    
    NSString *decimalString = [NSString stringWithFormat:@"%f", number];
    NSArray *components = [decimalString componentsSeparatedByString:@"."];
    
    NSInteger decimalLength = [[components objectAtIndex:1] length];
    NSInteger n = pow(10, decimalLength);
    NSInteger m = [[components objectAtIndex:1] intValue];
    NSInteger gcd = [self greatestCommonDivisonWithErrorFor:m and:n];

    fraction.denominator = n / gcd;
    fraction.numerator = ([[components objectAtIndex:0] intValue] * fraction.denominator) + m / gcd;

//    fraction.error = number - (CGFloat)fraction.numerator / (CGFloat)fraction.denominator;
    
    
    BRAFraction retVal;
    retVal.denominator = 0;
    retVal.numerator = 0;
    retVal.error = 0;
    CGFloat epsilon = 1.5 * pow(10, -1 - denominatorLength);
   
    do {
        ++retVal.denominator;
        retVal.numerator = round(((CGFloat)fraction.numerator * (CGFloat)retVal.denominator) / (CGFloat)fraction.denominator);
        retVal.error = ABS((CGFloat)fraction.numerator / (CGFloat)fraction.denominator - (CGFloat)retVal.numerator / (CGFloat)retVal.denominator);
    } while (retVal.error > epsilon);
    
    return retVal;
}

/*!
 * @brief This method takes a SpreadsheetML number and convert it to a NSAttributedString by keeping its formatting. This method is based on the PHP spreadsheet-reader library FormatValue function. https://github.com/nuovo/spreadsheet-reader/blob/master/SpreadsheetReader_XLSX.php
 */
- (NSAttributedString *)formatNumber:(CGFloat)number {
    NSString *stringToFormat = @"";
    NSMutableDictionary *attributedStringAttributes = @{}.mutableCopy;

    if ([_formatCode isEqual:@"@"]) {
        // If general formating (code "@") we display the shortest possible decimal value
        stringToFormat = [NSString stringWithFormat:@"%g", number];

    } else {
        
        BRANumberFormatData *formatData = _numberFormatParts[0];
        
        BOOL shouldAppendMinus = YES;
        
        switch (_numberFormatParts.count) {
            case 2:
                if (number < 0) {
                    shouldAppendMinus = NO;
                    formatData = _numberFormatParts[1];
                }
                break;
                
            case 3:
            case 4:
                if (number < 0) {
                    shouldAppendMinus = NO;
                    formatData = _numberFormatParts[1];
                } else if (number == 0) {
                    formatData = _numberFormatParts[2];
                }
                break;
        }
        
        // Applying format to value
        
        if (formatData.color) {
            attributedStringAttributes[NSForegroundColorAttributeName] = formatData.color;
        }
        
        if (formatData.type == kBRAFormatCodeTypePercentage) {
            if ([formatData.code isEqual:@"0%"]) {
                stringToFormat = [[self formatOutputCode:formatData.code] stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%ld", (long)floor(100. * number + 0.5)]];
            } else {
                stringToFormat = [[self formatOutputCode:formatData.code] stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%.2f", 100. * number]];
            }
            
        } else if (formatData.type == kBRAFormatCodeTypeDateTime) {
            NSInteger days = (NSInteger)number;
            //Correcting for Feb 29, 1900
            if (days > 60) {
                --days;
            }
            
            //At this time, time is a fraction of a day
            CGFloat time = number - (NSInteger)number;
            NSInteger seconds = 0;
            if (time) {
                //Here time is converted to seconds
                //some loss of precision will occur
                seconds = (NSInteger)(time * 86400);
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"d/M/yyyy";
            NSDate *baseDate = [dateFormatter dateFromString:@"1/1/1900"];
            
            dateFormatter.dateFormat = formatData.code;
            stringToFormat = [dateFormatter stringFromDate:[baseDate dateByAddingTimeInterval:days * 86400 + seconds]];
            
        } else if (formatData.type == kBRAFormatCodeTypeFraction && number != (NSInteger)number) {
            NSInteger integer = (NSInteger)(ABS(number));
            NSInteger denominatorStartPosition = [formatData.code rangeOfString:@"/"].location;
            NSInteger denominatorLength = 1;
            
            if (denominatorStartPosition != NSNotFound) {
                for (NSInteger i = denominatorStartPosition + 2; i < formatData.code.length; i++) {
                    if ([formatData.code characterAtIndex:i] == '?') {
                        ++denominatorLength;
                    } else {
                        break;
                    }
                }
            }
            BRAFraction fraction = [self convertToFraction:fmod(ABS(number), 1) withDenominatorLength:denominatorLength];
            
            if ([formatData.code rangeOfString:@"0"].location != NSNotFound ||
                [formatData.code rangeOfString:@"#"].location != NSNotFound ||
                [[formatData.code substringWithRange:NSMakeRange(0, 3)] isEqual:@"? ?"]) {
                
                //The integer part is shown separately apart from the fraction
                stringToFormat = [NSString stringWithFormat:@"%@%ld/%ld",
                                  integer ? [NSString stringWithFormat:@"%ld ", (long)integer] : @"",
                                  (long)fraction.numerator,
                                  (long)fraction.denominator];
            } else {
                stringToFormat = [NSString stringWithFormat:@"%ld/%ld",
                                  (long)(integer + fraction.numerator),
                                  (long)fraction.denominator];
            }
            
            stringToFormat = [[self formatOutputCode:formatData.code] stringByReplacingOccurrencesOfString:@"0" withString:stringToFormat];
            
        } else {
            //Scaling
            number = number / formatData.scale;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            
            [formatter setMinimumFractionDigits:formatData.precision];
            [formatter setMaximumFractionDigits:formatData.precision];
            [formatter setAlwaysShowsDecimalSeparator:formatData.precision > 0];
            
            NSNumberFormatterStyle numberStyle = NSNumberFormatterNoStyle;
            if (formatData.isScientific) {
                numberStyle = NSNumberFormatterScientificStyle;
                formatter.exponentSymbol = _cacheData.exponentSymbol;
                
                //For some strange reason, NSNumberFormatter format 12345 to 1.20E4
                [formatter setMinimumFractionDigits:formatData.precision + 1];
                [formatter setMaximumFractionDigits:formatData.precision + 1];
            } else if (formatData.precision > 0) {
                numberStyle = NSNumberFormatterDecimalStyle;
            }
            
            [formatter setNumberStyle:numberStyle];
            
            //Thousands -> use group
            if (formatData.hasThousands) {
                NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
                [formatter setGroupingSeparator:groupingSeparator];
                [formatter setGroupingSize:3];
                [formatter setUsesGroupingSeparator:YES];
            }
            
            if (!shouldAppendMinus) {
                number = ABS(number);
            }
            
            NSString *formattedNumber = [formatter stringFromNumber:@(number)];
            
            //if scientific format, reformat exponent
            NSInteger exponentLength = 0;
            if (formatData.isScientific) {
                if ([formattedNumber rangeOfString:@"0e-"].location != NSNotFound || [formattedNumber rangeOfString:@"0E-"].location != NSNotFound) {
                    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"0e-" withString:@"e-"];
                    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"0E-" withString:@"E-"];
                    
                    exponentLength = formattedNumber.length - [formattedNumber rangeOfString:@"-"].location - 1;
                    while (exponentLength < formatData.exponentLength) {
                        formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"-" withString:@"-0"];
                        ++exponentLength;
                    }
                } else if ([formattedNumber rangeOfString:@"e"].location != NSNotFound || [formattedNumber rangeOfString:@"E"].location != NSNotFound) {
                    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"0e" withString:@"e+"];
                    formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"0E" withString:@"E+"];
                    
                    exponentLength = formattedNumber.length - [formattedNumber rangeOfString:@"+"].location - 1;
                    
                    while (exponentLength < formatData.exponentLength) {
                        formattedNumber = [formattedNumber stringByReplacingOccurrencesOfString:@"+" withString:@"+0"];
                        ++exponentLength;
                    }
                }
            }
            
            stringToFormat = [[self formatOutputCode:formatData.code] stringByReplacingOccurrencesOfString:@"0" withString:formattedNumber];
        }
        
    }
    
    return [[NSAttributedString alloc] initWithString:stringToFormat attributes:attributedStringAttributes];
}

- (NSString *)formatOutputCode:(NSString *)code {
    NSMutableString *outputCode = @"".mutableCopy;
    NSCharacterSet *zeroCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".,0#?/"];
    
    BOOL escaped = NO;
    BOOL spaceEscaped = NO;
    BOOL hasZero = NO;
    
    code = [code stringByReplacingOccurrencesOfString:@" ?" withString:@"?"];
    
        for (NSInteger i = 0; i < code.length; i++) {
        NSString *currentChar = [code substringWithRange:NSMakeRange(i, 1)];
        
        if (escaped) {
            [outputCode appendString:currentChar];
            escaped = NO;
            continue;
        }
        
        if (spaceEscaped) {
            [outputCode appendString:@" "];
            spaceEscaped = NO;
            continue;
        }
        
        if ([currentChar isEqual:@"\\"]) {
            escaped = YES;
            continue;
        
        } else if ([currentChar isEqual:@"_"]) {
            spaceEscaped = YES;
            continue;
        
        } else if ([currentChar rangeOfCharacterFromSet:zeroCharacterSet].location != NSNotFound) {
            if (hasZero) {
                continue;
            }
            
            [outputCode appendString:@"0"];
            hasZero = YES;

        } else {
            [outputCode appendString:currentChar];
        }
    }
    
    return outputCode;
}

#pragma mark - 

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    if (_formatId) {
        dictionaryRepresentation[@"_numFmtId"] = _formatId;
    }

    dictionaryRepresentation[@"_formatCode"] = _formatCode;
    
    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

@end
