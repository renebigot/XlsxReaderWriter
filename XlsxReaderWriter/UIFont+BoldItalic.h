//
//  UIFont+BoldItalic.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/04/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString *kBRAFontNameRegular = @"regular";
static const NSString *kBRAFontNameItalic = @"italic";
static const NSString *kBRAFontNameBold = @"bold";
static const NSString *kBRAFontNameBoldItalic = @"bold-italic";
static const NSString *kBRAFontNameWindows = @"windows";

@interface UIFont (BoldItalic)

+ (UIFont *)iosFontWithName:(NSString *)iOsFontName size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic;
- (NSDictionary *)windowsFontProperties;

@end
