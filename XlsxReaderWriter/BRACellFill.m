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

- (instancetype)initWithForegroundColor:(BRANativeColor *)foregroundColor backgroundColor:(BRANativeColor *)backgroundColor andPatternType:(BRACellFillPatternType)patternType inStyles:(BRAStyles *)styles {
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
        _backgroundColor = [BRANativeColor clearColor];
        _foregroundColor = [BRANativeColor clearColor];
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

- (BRANativeColor *)patternedColor {
    if ([_patternType isEqual:kBRACellFillPatternTypeNone]) {
        return [BRANativeColor clearColor];
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

- (BRANativeColor *)_solidPatternedColor {
    return _foregroundColor ? _foregroundColor : [BRANativeColor clearColor];
}

- (BRANativeColor *)_darkGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.75];
}

- (BRANativeColor *)_mediumGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.5];
}

- (BRANativeColor *)_lightGrayPatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.25];
}

- (BRANativeColor *)_gray125PatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.125];
}

- (BRANativeColor *)_gray0625PatternedColor {
    return [self __grayPatternedColorWithGrayLevel:.0625];
}

- (BRANativeColor *)nativeColorWithSize:(CGSize)drawingSize drawingOperations:(void (^)(CGContextRef context))drawingOps {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, drawingSize.width, drawingSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    drawingOps(context);
        
    BRANativeImage *patternImage = BRANativeGraphicsGetImageFromContext(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [BRANativeColor colorWithPatternImage:patternImage];
}

- (BRANativeColor *)_darkHorizontalPatternedColor {
  
   return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
     CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
     CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
     
     CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
     CGContextFillRect(context, CGRectMake(0., 0., 4., 2.));
   }];
}

- (BRANativeColor *)_darkVerticalPatternedColor {
  
  return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
      CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
      CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
      
      CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
      CGContextFillRect(context, CGRectMake(0., 0., 2., 4.));
    }];
}

- (BRANativeColor *)_darkDownPatternedColor {
  
  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)_darkUpPatternedColor {

  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)_darkGridPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 2., 2.));
    CGContextFillRect(context, CGRectMake(2., 2., 2., 2.));
  }];
}

- (BRANativeColor *)_darkTrellisPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)_lightHorizontalPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 1.));
  }];
}

- (BRANativeColor *)_lightVerticalPatternedColor {
  
  return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 1., 4.));
  }];
}

- (BRANativeColor *)_lightDownPatternedColor {
  
  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)_lightUpPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)_lightGridPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(4, 4) drawingOperations:^(CGContextRef context){
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 4., 4.));
    
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0., 0., 1., 4.));
    CGContextFillRect(context, CGRectMake(0., 3., 4., 1.));
  }];
}

- (BRANativeColor *)_lightTrellisPatternedColor {
  return [self nativeColorWithSize:CGSizeMake(6, 6) drawingOperations:^(CGContextRef context){
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
  }];
}

- (BRANativeColor *)__grayPatternedColorWithGrayLevel:(CGFloat)grayLevel {
  return [self nativeColorWithSize:CGSizeMake(4, 2) drawingOperations:^(CGContextRef context){
    CGRect patternBounds = CGRectMake(0., 0., 4., 2.);
    CGContextSetFillColorWithColor(context, _foregroundColor.CGColor);
    CGContextFillRect(context, patternBounds);
    
    CGContextSetFillColorWithColor(context, [_backgroundColor colorWithAlphaComponent:grayLevel].CGColor);
    CGContextFillRect(context, patternBounds);
  }];
}

@end
