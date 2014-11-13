//
//  UIColor+HTML.h
//  FasciaLib
//
//  Created by René Bigot on 26/01/2014.
//  Copyright (c) 2014 SNCF PSIGT.TL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HTML)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;
- (NSString *)hexStringValue;

@end
