//
//  NativeFont+BoldItalic.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/04/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAPlatformSpecificDefines.h"

static const NSString *kBRAFontNameRegular = @"regular";
static const NSString *kBRAFontNameItalic = @"italic";
static const NSString *kBRAFontNameBold = @"bold";
static const NSString *kBRAFontNameBoldItalic = @"bold-italic";
static const NSString *kBRAFontNameWindows = @"windows";

@interface BRANativeFont (BoldItalic)

+ (BRANativeFont *)nativeFontWithName:(NSString *)fontName size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic;
- (NSDictionary *)windowsFontProperties;

@end
