//
//  BRATheme.m
//  XlsxReaderWriter
//
//  Created by René BIGOT on 06/07/2015.
//  Copyright (c) 2015 BRAE. All rights reserved.
//

#import "BRATheme.h"
#import "NativeColor+HTML.h"

// It seems thats S01 & S00 have been switched compared to IEC 29500-1.
// Don't know why !!!
#define S01     @"a:dk1"
#define S00     @"a:lt1"
#define S02     @"a:dk2"
#define S03     @"a:lt2"
#define S04     @"a:accent1"
#define S05     @"a:accent2"
#define S06     @"a:accent3"
#define S07     @"a:accent4"
#define S08     @"a:accent5"
#define S09     @"a:accent6"
#define S10     @"a:hlink"
#define S11     @"a:folHlink"

@implementation BRATheme

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.theme+xml";
}

- (NSString *)targetFormat {
    return @"theme/theme%ld.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *colorsScheme = [[NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation] dictionaryValueForKeyPath:@"a:themeElements.a:clrScheme"];
    
    _colors = @[
                [self colorNamed:S00 inColorScheme:colorsScheme],
                [self colorNamed:S01 inColorScheme:colorsScheme],
                [self colorNamed:S02 inColorScheme:colorsScheme],
                [self colorNamed:S03 inColorScheme:colorsScheme],
                [self colorNamed:S04 inColorScheme:colorsScheme],
                [self colorNamed:S05 inColorScheme:colorsScheme],
                [self colorNamed:S06 inColorScheme:colorsScheme],
                [self colorNamed:S07 inColorScheme:colorsScheme],
                [self colorNamed:S08 inColorScheme:colorsScheme],
                [self colorNamed:S09 inColorScheme:colorsScheme],
                [self colorNamed:S10 inColorScheme:colorsScheme],
                [self colorNamed:S11 inColorScheme:colorsScheme]
                ];
}

- (BRANativeColor *)colorNamed:(NSString *)colorName inColorScheme:(NSDictionary *)colorsScheme {
    NSString *colorValue = [colorsScheme dictionaryValueForKeyPath:[colorName stringByAppendingString:@".a:sysClr"]][@"_lastClr"];
    
    if (!colorValue) {
        colorValue = [colorsScheme dictionaryValueForKeyPath:[colorName stringByAppendingString:@".a:srgbClr"]][@"_val"];
    }
    
    //Do not replace this 'if' with an 'else' or 'else if' !!!
    if (colorValue) {
        return [BRANativeColor colorWithHexString:colorValue];
    }
    
    return [BRANativeColor blackColor];
}

#pragma mark -

- (NSString *)xmlRepresentation {
    //This class is read-only
    //We just return _xmlRepresentation
    return _xmlRepresentation;
}

@end
