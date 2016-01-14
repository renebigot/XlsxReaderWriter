//
//  NativeFont+BoldItalic.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/04/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "NativeFont+BoldItalic.h"

@implementation BRANativeFont (BoldItalic)

+ (BRANativeFont *)nativeFontWithName:(NSString *)fontName size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic {
    if (fontName == nil) {
        return nil;
    }

    size = size <= 0 ? 10. : size;
    
    static dispatch_once_t pred;
    static NSDictionary *_openXml2IOsFonts = nil;
    dispatch_once(&pred, ^{
        _openXml2IOsFonts = @{
                              @"Century Gothic": @{kBRAFontNameRegular: @"AppleSDGothicNeo-Regular", kBRAFontNameBold: @"AppleSDGothicNeo-Bold"},
                              @"Arial": @{kBRAFontNameRegular: @"ArialMT", kBRAFontNameBold: @"Arial-BoldMT", kBRAFontNameItalic: @"Arial-ItalicMT", kBRAFontNameBoldItalic: @"Arial-BoldItalicMT"},
                              @"Arial Rounded MT Bold": @{kBRAFontNameRegular: @"ArialRoundedMTBold"},
                              @"Avenir": @{kBRAFontNameRegular: @"Avenir-Book", kBRAFontNameBold: @"Avenir-Medium", kBRAFontNameItalic: @"Avenir-Oblique", kBRAFontNameBoldItalic: @"Avenir-MediumOblique"},
                              @"Baskerville Old Face": @{kBRAFontNameRegular: @"Baskerville", kBRAFontNameBold: @"Baskerville-Bold", kBRAFontNameItalic: @"Baskerville-Italic", kBRAFontNameBoldItalic: @"Baskerville-BoldItalic"},
                              @"Bradley Hand ITC": @{kBRAFontNameRegular: @"BradleyHandITCTT-Bold"},
                              @"Copperplate Gothic Light": @{kBRAFontNameRegular: @"Copperplate", kBRAFontNameBold: @"Copperplate-Bold"},
                              @"Courier New": @{kBRAFontNameRegular: @"CourierNewPSMT", kBRAFontNameBold: @"CourierNewPS-BoldMT", kBRAFontNameItalic: @"CourierNewPS-ItalicMT", kBRAFontNameBoldItalic: @"CourierNewPS-BoldItalicMT"},
                              @"Georgia": @{kBRAFontNameRegular: @"Georgia", kBRAFontNameBold: @"Georgia-Bold", kBRAFontNameItalic: @"Georgia-Italic", kBRAFontNameBoldItalic: @"Georgia-BoldItalic"},
                              @"Gill Sans MT": @{kBRAFontNameRegular: @"GillSans", kBRAFontNameBold: @"GillSans-Bold", kBRAFontNameItalic: @"GillSans-Italic", kBRAFontNameBoldItalic: @"GillSans-BoldItalic"},
                              @"Consolas": @{kBRAFontNameRegular: @"Menlo-Regular", kBRAFontNameBold: @"Menlo-Bold", kBRAFontNameItalic: @"Menlo-Italic", kBRAFontNameBoldItalic: @"Menlo-BoldItalic"},
                              @"Palatino Linotype": @{kBRAFontNameRegular: @"Palatino-Roman", kBRAFontNameBold: @"Palatino-Bold", kBRAFontNameItalic: @"Palatino-Italic", kBRAFontNameBoldItalic: @"Palatino-BoldItalic"},
                              @"Papyrus": @{kBRAFontNameRegular: @"Papyrus"},
                              @"Times New Roman": @{kBRAFontNameRegular: @"TimesNewRomanPSMT", kBRAFontNameBold: @"TimesNewRomanPS-BoldMT", kBRAFontNameItalic: @"TimesNewRomanPS-ItalicMT", kBRAFontNameBoldItalic: @"TimesNewRomanPS-BoldItalicMT"},
                              @"Trebuchet MS": @{kBRAFontNameRegular: @"TrebuchetMS", kBRAFontNameBold: @"TrebuchetMS-Bold", kBRAFontNameItalic: @"TrebuchetMS-Italic", kBRAFontNameBoldItalic: @"Trebuchet-BoldItalic"},
                              @"Verdana": @{kBRAFontNameRegular: @"Verdana", kBRAFontNameBold: @"Verdana-Bold", kBRAFontNameItalic: @"Verdana-Italic", kBRAFontNameBoldItalic: @"Verdana-BoldItalic"},
                              };
    });

    NSString *fontNameType = nil;
    
    if (isBold && isItalic) {
        fontNameType = (NSString *)kBRAFontNameBoldItalic;
    } else if (isBold) {
        fontNameType = (NSString *)kBRAFontNameBold;
    } else if (isItalic) {
        fontNameType = (NSString *)kBRAFontNameItalic;
    } else {
        fontNameType = (NSString *)kBRAFontNameRegular;
    }
    
    if (!fontName || !_openXml2IOsFonts[fontName]) {
        return nil;
//        windowsFontName = @"Verdana";
    }
    
    if (_openXml2IOsFonts[fontName][fontNameType]) {
      return [BRANativeFont fontWithName:_openXml2IOsFonts[fontName][fontNameType] size:size];
    } else {
        return [BRANativeFont fontWithName:_openXml2IOsFonts[fontName][kBRAFontNameRegular] size:size];
    }
}

- (NSDictionary *)windowsFontProperties {
    static dispatch_once_t pred;
    static NSDictionary *_ios2OpenXmlFonts = nil;
    
    dispatch_once(&pred, ^{
        _ios2OpenXmlFonts = @{
                               @"AppleSDGothicNeo-Regular": @{kBRAFontNameWindows: @"Century Gothic", @"b": @(NO), @"i": @(NO)},
                               @"AppleSDGothicNeo-Bold": @{kBRAFontNameWindows: @"Century Gothic", @"b": @(YES), @"i": @(NO)},
                               @"ArialMT": @{kBRAFontNameWindows: @"Arial", @"b": @(NO), @"i": @(NO)},
                               @"Arial-BoldMT": @{kBRAFontNameWindows: @"Arial", @"b": @(YES), @"i": @(NO)},
                               @"Arial-ItalicMT": @{kBRAFontNameWindows: @"Arial", @"b": @(NO), @"i": @(YES)},
                               @"Arial-BoldItalicMT": @{kBRAFontNameWindows: @"Arial", @"b": @(YES), @"i": @(YES)},
                               @"ArialMT": @{kBRAFontNameWindows: @"Arial", @"b": @(NO), @"i": @(NO)},
                               @"Arial-BoldMT": @{kBRAFontNameWindows: @"Arial", @"b": @(YES), @"i": @(NO)},
                               @"Arial-ItalicMT": @{kBRAFontNameWindows: @"Arial", @"b": @(NO), @"i": @(YES)},
                               @"Arial-BoldItalicMT": @{kBRAFontNameWindows: @"Arial", @"b": @(YES), @"i": @(YES)},
                               @"ArialRoundedMTBold": @{kBRAFontNameWindows: @"Arial Rounded MT Bold", @"b": @(NO), @"i": @(NO)},
                               @"Avenir-Book": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(NO)},
                               @"Avenir-Medium": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(NO)},
                               @"Avenir-Oblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(YES)},
                               @"Avenir-MediumOblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(YES)},
                               @"Avenir-Book": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(NO)},
                               @"Avenir-Medium": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(NO)},
                               @"Avenir-Oblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(YES)},
                               @"Avenir-MediumOblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(YES)},
                               @"Avenir-Book": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(NO)},
                               @"Avenir-Medium": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(NO)},
                               @"Avenir-Oblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(NO), @"i": @(YES)},
                               @"Avenir-MediumOblique": @{kBRAFontNameWindows: @"Avenir", @"b": @(YES), @"i": @(YES)},
                               @"Baskerville": @{kBRAFontNameWindows: @"Baskerville Old Face", @"b": @(NO), @"i": @(NO)},
                               @"Baskerville-Bold": @{kBRAFontNameWindows: @"Baskerville Old Face", @"b": @(YES), @"i": @(NO)},
                               @"Baskerville-Italic": @{kBRAFontNameWindows: @"Baskerville Old Face", @"b": @(NO), @"i": @(YES)},
                               @"Baskerville-BoldItalic": @{kBRAFontNameWindows: @"Baskerville Old Face", @"b": @(YES), @"i": @(YES)},
                               @"BradleyHandITCTT-Bold": @{kBRAFontNameWindows: @"Bradley Hand ITC", @"b": @(NO), @"i": @(NO)},
                               @"Copperplate": @{kBRAFontNameWindows: @"Copperplate Gothic Light", @"b": @(NO), @"i": @(NO)},
                               @"Copperplate-Bold": @{kBRAFontNameWindows: @"Copperplate Gothic Light", @"b": @(YES), @"i": @(NO)},
                               @"CourierNewPSMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(NO), @"i": @(NO)},
                               @"CourierNewPS-BoldMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(YES), @"i": @(NO)},
                               @"CourierNewPS-ItalicMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(NO), @"i": @(YES)},
                               @"CourierNewPS-BoldItalicMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(YES), @"i": @(YES)},
                               @"CourierNewPSMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(NO), @"i": @(NO)},
                               @"CourierNewPS-BoldMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(YES), @"i": @(NO)},
                               @"CourierNewPS-ItalicMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(NO), @"i": @(YES)},
                               @"CourierNewPS-BoldItalicMT": @{kBRAFontNameWindows: @"Courier New", @"b": @(YES), @"i": @(YES)},
                               @"Georgia": @{kBRAFontNameWindows: @"Georgia", @"b": @(NO), @"i": @(NO)},
                               @"Georgia-Bold": @{kBRAFontNameWindows: @"Georgia", @"b": @(YES), @"i": @(NO)},
                               @"Georgia-Italic": @{kBRAFontNameWindows: @"Georgia", @"b": @(NO), @"i": @(YES)},
                               @"Georgia-BoldItalic": @{kBRAFontNameWindows: @"Georgia", @"b": @(YES), @"i": @(YES)},
                               @"GillSans": @{kBRAFontNameWindows: @"Gill Sans MT", @"b": @(NO), @"i": @(NO)},
                               @"GillSans-Bold": @{kBRAFontNameWindows: @"Gill Sans MT", @"b": @(YES), @"i": @(NO)},
                               @"GillSans-Italic": @{kBRAFontNameWindows: @"Gill Sans MT", @"b": @(NO), @"i": @(YES)},
                               @"GillSans-BoldItalic": @{kBRAFontNameWindows: @"Gill Sans MT", @"b": @(YES), @"i": @(YES)},
                               @"Menlo-Regular": @{kBRAFontNameWindows: @"Consolas", @"b": @(NO), @"i": @(NO)},
                               @"Menlo-Bold": @{kBRAFontNameWindows: @"Consolas", @"b": @(YES), @"i": @(NO)},
                               @"Menlo-Italic": @{kBRAFontNameWindows: @"Consolas", @"b": @(NO), @"i": @(YES)},
                               @"Menlo-BoldItalic": @{kBRAFontNameWindows: @"Consolas", @"b": @(YES), @"i": @(YES)},
                               @"Palatino-Roman": @{kBRAFontNameWindows: @"Palatino Linotype", @"b": @(NO), @"i": @(NO)},
                               @"Palatino-Bold": @{kBRAFontNameWindows: @"Palatino Linotype", @"b": @(YES), @"i": @(NO)},
                               @"Palatino-Italic": @{kBRAFontNameWindows: @"Palatino Linotype", @"b": @(NO), @"i": @(YES)},
                               @"Palatino-BoldItalic": @{kBRAFontNameWindows: @"Palatino Linotype", @"b": @(YES), @"i": @(YES)},
                               @"Papyrus": @{kBRAFontNameWindows: @"Papyrus", @"b": @(NO), @"i": @(NO)},
                               @"TimesNewRomanPSMT": @{kBRAFontNameWindows: @"Times New Roman", @"b": @(NO), @"i": @(NO)},
                               @"TimesNewRomanPS-BoldMT": @{kBRAFontNameWindows: @"Times New Roman", @"b": @(YES), @"i": @(NO)},
                               @"TimesNewRomanPS-ItalicMT": @{kBRAFontNameWindows: @"Times New Roman", @"b": @(NO), @"i": @(YES)},
                               @"TimesNewRomanPS-BoldItalicMT": @{kBRAFontNameWindows: @"Times New Roman", @"b": @(YES), @"i": @(YES)},
                               @"TrebuchetMS": @{kBRAFontNameWindows: @"Trebuchet MS", @"b": @(NO), @"i": @(NO)},
                               @"TrebuchetMS-Bold": @{kBRAFontNameWindows: @"Trebuchet MS", @"b": @(YES), @"i": @(NO)},
                               @"TrebuchetMS-Italic": @{kBRAFontNameWindows: @"Trebuchet MS", @"b": @(NO), @"i": @(YES)},
                               @"Trebuchet-BoldItalic": @{kBRAFontNameWindows: @"Trebuchet MS", @"b": @(YES), @"i": @(YES)},
                               @"Verdana": @{kBRAFontNameWindows: @"Verdana", @"b": @(NO), @"i": @(NO)},
                               @"Verdana-Bold": @{kBRAFontNameWindows: @"Verdana", @"b": @(YES), @"i": @(NO)},
                               @"Verdana-Italic": @{kBRAFontNameWindows: @"Verdana", @"b": @(NO), @"i": @(YES)},
                               @"Verdana-BoldItalic": @{kBRAFontNameWindows: @"Verdana", @"b": @(YES), @"i": @(YES)},
                               };
    });

    NSDictionary *fontProperties = _ios2OpenXmlFonts[self.fontName];
    
    if (fontProperties == nil) {
        fontProperties = _ios2OpenXmlFonts[@"Verdana"];
    }
    
    return fontProperties;
}

@end