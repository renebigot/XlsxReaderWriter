//
//  UIColor+OpenXml.m
//  Levé
//
//  Created by René BIGOT on 14/04/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "UIColor+OpenXml.h"

@implementation UIColor (OpenXml)

+ (NSArray *)defaultIndexedColors {
    static dispatch_once_t pred;
    static NSArray *_defaultIndexedColors = nil;
    dispatch_once(&pred, ^{
        _defaultIndexedColors = @[
                                  [UIColor colorWithHexString:@"000000"],
                                  [UIColor colorWithHexString:@"FFFFFF"],
                                  [UIColor colorWithHexString:@"FF0000"],
                                  [UIColor colorWithHexString:@"00FF00"],
                                  [UIColor colorWithHexString:@"0000FF"],
                                  [UIColor colorWithHexString:@"FFFF00"],
                                  [UIColor colorWithHexString:@"FF00FF"],
                                  [UIColor colorWithHexString:@"00FFFF"],
                                  [UIColor colorWithHexString:@"000000"],
                                  [UIColor colorWithHexString:@"FFFFFF"],
                                  [UIColor colorWithHexString:@"FF0000"],
                                  [UIColor colorWithHexString:@"00FF00"],
                                  [UIColor colorWithHexString:@"0000FF"],
                                  [UIColor colorWithHexString:@"FFFF00"],
                                  [UIColor colorWithHexString:@"FF00FF"],
                                  [UIColor colorWithHexString:@"00FFFF"],
                                  [UIColor colorWithHexString:@"800000"],
                                  [UIColor colorWithHexString:@"008000"],
                                  [UIColor colorWithHexString:@"000080"],
                                  [UIColor colorWithHexString:@"808000"],
                                  [UIColor colorWithHexString:@"800080"],
                                  [UIColor colorWithHexString:@"008080"],
                                  [UIColor colorWithHexString:@"C0C0C0"],
                                  [UIColor colorWithHexString:@"808080"],
                                  [UIColor colorWithHexString:@"9999FF"],
                                  [UIColor colorWithHexString:@"993366"],
                                  [UIColor colorWithHexString:@"FFFFCC"],
                                  [UIColor colorWithHexString:@"CCFFFF"],
                                  [UIColor colorWithHexString:@"660066"],
                                  [UIColor colorWithHexString:@"FF8080"],
                                  [UIColor colorWithHexString:@"0066CC"],
                                  [UIColor colorWithHexString:@"CCCCFF"],
                                  [UIColor colorWithHexString:@"000080"],
                                  [UIColor colorWithHexString:@"FF00FF"],
                                  [UIColor colorWithHexString:@"FFFF00"],
                                  [UIColor colorWithHexString:@"00FFFF"],
                                  [UIColor colorWithHexString:@"800080"],
                                  [UIColor colorWithHexString:@"800000"],
                                  [UIColor colorWithHexString:@"008080"],
                                  [UIColor colorWithHexString:@"0000FF"],
                                  [UIColor colorWithHexString:@"00CCFF"],
                                  [UIColor colorWithHexString:@"CCFFFF"],
                                  [UIColor colorWithHexString:@"CCFFCC"],
                                  [UIColor colorWithHexString:@"FFFF99"],
                                  [UIColor colorWithHexString:@"99CCFF"],
                                  [UIColor colorWithHexString:@"FF99CC"],
                                  [UIColor colorWithHexString:@"CC99FF"],
                                  [UIColor colorWithHexString:@"FFCC99"],
                                  [UIColor colorWithHexString:@"3366FF"],
                                  [UIColor colorWithHexString:@"33CCCC"],
                                  [UIColor colorWithHexString:@"99CC00"],
                                  [UIColor colorWithHexString:@"FFCC00"],
                                  [UIColor colorWithHexString:@"FF9900"],
                                  [UIColor colorWithHexString:@"FF6600"],
                                  [UIColor colorWithHexString:@"666699"],
                                  [UIColor colorWithHexString:@"969696"],
                                  [UIColor colorWithHexString:@"003366"],
                                  [UIColor colorWithHexString:@"339966"],
                                  [UIColor colorWithHexString:@"003300"],
                                  [UIColor colorWithHexString:@"333300"],
                                  [UIColor colorWithHexString:@"993300"],
                                  [UIColor colorWithHexString:@"993366"],
                                  [UIColor colorWithHexString:@"333399"],
                                  [UIColor colorWithHexString:@"333333"],
                                  [UIColor colorWithHexString:@"000000"],
                                  [UIColor colorWithHexString:@"FFFFFF"]
                                  ];
    });
    
    return _defaultIndexedColors;
}

@end
