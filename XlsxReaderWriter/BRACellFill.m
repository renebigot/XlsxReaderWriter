//
//  BRACellFill.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 07/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRACellFill.h"
#import "BRAStyles.h"

@implementation BRACellFill

- (instancetype)initWithForegroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor andPatternType:(BRACellFillPatternType)patternType inStyles:(BRAStyles *)styles {
    NSDictionary *dictionaryRepresentation = @{
                                               @"patternFill": @{
                                                       @"_patternType": patternType,
                                                       @"bgColor": [styles openXmlAttributesWithColor:backgroundColor],
                                                       @"fgColor": [styles openXmlAttributesWithColor:foregroundColor]
                                                       }
                                               };
    
    if (self = [super initWithOpenXmlAttributes:dictionaryRepresentation inStyles:styles]) {
    }
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    _patternType = [dictionaryRepresentation valueForKeyPath:@"patternFill._patternType"];
    
    if ([_patternType isEqual:kBRACellFillPatternTypeNone]) {
        _backgroundColor = [UIColor clearColor];
        _foregroundColor = [UIColor clearColor];
    } else {
        _backgroundColor = [_styles colorWithOpenXmlAttributes:[dictionaryRepresentation valueForKeyPath:@"patternFill.bgColor"]];
        _foregroundColor = [_styles colorWithOpenXmlAttributes:[dictionaryRepresentation valueForKeyPath:@"patternFill.fgColor"]];
    }
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableDeepCopy;
        
    [dictionaryRepresentation setValue:_patternType forKeyPath:@"patternFill._patternType"];
    [dictionaryRepresentation setValue:[_styles openXmlAttributesWithColor:_backgroundColor] forKeyPath:@"patternFill.bgColor"];
    [dictionaryRepresentation setValue:[_styles openXmlAttributesWithColor:_foregroundColor] forKeyPath:@"patternFill.fgColor"];
    
    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

#pragma mark - Pattern

- (UIColor *)patternedColor {
    if ([_patternType isEqual:kBRACellFillPatternTypeNone]) {
        return [UIColor clearColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeSolid]) {
        return [self _solidPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkGray]) {
        return [self _darkGrayPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeMediumGray]) {
        return [self _mediumGrayPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightGray]) {
        return [self _lightGrayPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeGray125]) {
        return [self _gray125PatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeGray0625]) {
        return [self _gray0625PatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkHorizontal]) {
        return [self _darkHorizontalPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkVertical]) {
        return [self _darkVerticalPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkDown]) {
        return [self _darkDownPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkUp]) {
        return [self _darkUpPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkGrid]) {
        return [self _darkGridPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeDarkTrellis]) {
        return [self _darkTrellisPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightHorizontal]) {
        return [self _lightHorizontalPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightVertical]) {
        return [self _lightVerticalPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightDown]) {
        return [self _lightDownPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightUp]) {
        return [self _lightUpPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightGrid]) {
        return [self _lightGridPatternedColor];
    } else if ([_patternType isEqual:kBRACellFillPatternTypeLightTrellis]) {
        return [self _lightTrellisPatternedColor];
    }
    
    return nil;
}

#pragma mark - Patterned color makers

- (UIColor *)_solidPatternedColor {
    return _foregroundColor ? _foregroundColor : [UIColor clearColor];
}

- (UIColor *)_darkGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.75];
}

- (UIColor *)_mediumGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.5];
}

- (UIColor *)_lightGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.25];
}

- (UIColor *)_gray125PatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.125];
}

- (UIColor *)_gray0625PatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.0625];
}

- (UIColor *)_darkHorizontalPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 2.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_darkVerticalPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 2., 4.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_darkDownPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 2.);
    CGContextMoveToPoint(context, -2., -1.);
    CGContextAddLineToPoint(context, 6., 7.);
    CGContextMoveToPoint(context, 4., -1.);
    CGContextAddLineToPoint(context, 7., 2.);
    CGContextMoveToPoint(context, -2., 5.);
    CGContextAddLineToPoint(context, 0., 7.);
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_darkUpPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 2.);
    CGContextMoveToPoint(context, 6., -2.);
    CGContextAddLineToPoint(context, -2., 6.);
    CGContextMoveToPoint(context, 7., 3.);
    CGContextAddLineToPoint(context, 3., 7.);
    CGContextMoveToPoint(context, -2., 0.);
    CGContextAddLineToPoint(context, 0., -2.);
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_darkGridPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 2., 2.));
    CGContextFillRect(context, CGRectMake(2., 2., 2., 2.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_darkTrellisPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 2.);
    CGContextMoveToPoint(context, 6., -2.);
    CGContextAddLineToPoint(context, -2., 6.);
    CGContextMoveToPoint(context, 7., 3.);
    CGContextAddLineToPoint(context, 3., 7.);
    CGContextMoveToPoint(context, -2., 0.);
    CGContextAddLineToPoint(context, 0., -2.);
    
    CGContextMoveToPoint(context, -2., -1.);
    CGContextAddLineToPoint(context, 6., 7.);
    CGContextMoveToPoint(context, 4., -1.);
    CGContextAddLineToPoint(context, 7., 2.);
    CGContextMoveToPoint(context, -2., 5.);
    CGContextAddLineToPoint(context, 0., 7.);
    
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightHorizontalPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 1.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightVerticalPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 1., 4.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightDownPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 1.);
    CGContextMoveToPoint(context, -2., -1.);
    CGContextAddLineToPoint(context, 6., 7.);
    CGContextMoveToPoint(context, 4., -1.);
    CGContextAddLineToPoint(context, 7., 2.);
    CGContextMoveToPoint(context, -2., 5.);
    CGContextAddLineToPoint(context, 0., 7.);
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightUpPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 1.);
    CGContextMoveToPoint(context, 6., -2.);
    CGContextAddLineToPoint(context, -2., 6.);
    CGContextMoveToPoint(context, 7., 3.);
    CGContextAddLineToPoint(context, 3., 7.);
    CGContextMoveToPoint(context, -2., 0.);
    CGContextAddLineToPoint(context, 0., -2.);
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightGridPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4., 4.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 1., 4.));
    CGContextFillRect(context, CGRectMake(0., 3., 4., 1.));
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)_lightTrellisPatternedColor {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(6., 6.), NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 6., 6.));
    
    CGContextSetStrokeColorWithColor(context, _backgroundColor.CGColor);
    CGContextSetLineWidth(context, 1.);
    CGContextMoveToPoint(context, 6., -2.);
    CGContextAddLineToPoint(context, -2., 6.);
    CGContextMoveToPoint(context, 7., 3.);
    CGContextAddLineToPoint(context, 3., 7.);
    CGContextMoveToPoint(context, -2., 0.);
    CGContextAddLineToPoint(context, 0., -2.);
    
    CGContextMoveToPoint(context, -2., -1.);
    CGContextAddLineToPoint(context, 6., 7.);
    CGContextMoveToPoint(context, 4., -1.);
    CGContextAddLineToPoint(context, 7., 2.);
    CGContextMoveToPoint(context, -2., 5.);
    CGContextAddLineToPoint(context, 0., 7.);
    
    CGContextStrokePath(context);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

- (UIColor *)__grayPatternedColorWithGrayLevel:(CGFloat)grayLevel {
    CGRect patternBounds = CGRectMake(0., 0., 4., 2.);
    UIGraphicsBeginImageContextWithOptions(patternBounds.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, patternBounds);
    
    CGContextSetFillColorWithColor(context, [_backgroundColor colorWithAlphaComponent:grayLevel].CGColor);
    CGContextFillRect(context, patternBounds);
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:patternImage];
}

@end
