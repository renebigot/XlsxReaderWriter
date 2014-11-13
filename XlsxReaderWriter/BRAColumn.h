//
//  BRAColumn.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@interface BRAColumn : BRAOpenXmlSubElement

+ (NSInteger)columnIndexForCellReference:(NSString *)cellReference;
+ (NSString *)columnNameForCellReference:(NSString *)cellReference;
+ (NSString *)columnNameForColumnIndex:(NSInteger)index;
- (instancetype)initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum;

@property (nonatomic, getter = hasCustomWidth) BOOL customWidth;
@property (nonatomic) NSInteger minimum;
@property (nonatomic) NSInteger maximum;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger pointWidth;

@end
