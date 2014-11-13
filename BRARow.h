//
//  BRARow.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@class BRACell, BRAWorksheet;

@interface BRARow : BRAOpenXmlSubElementWithWorksheet

+ (NSInteger)rowIndexForCellReference:(NSString *)cellReference;
- (instancetype)initWithRowIndex:(NSInteger)rowIndex inWorksheet:(BRAWorksheet *)worksheet;
- (void)addCell:(BRACell *)cell;

@property (nonatomic, getter=hasCustomHeight) BOOL customHeight;
@property (nonatomic) NSInteger rowIndex;
@property (nonatomic) NSInteger height;
@property (nonatomic, strong) NSMutableArray *cells;

@end
