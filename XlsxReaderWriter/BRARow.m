//
//  BRARow.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARow.h"
#import "BRACell.h"
#import "BRAMergeCell.h"
#import "BRAWorksheet.h"
#import "BRAColumn.h"

@implementation BRARow

+ (NSInteger)rowIndexForCellReference:(NSString *)cellReference {
    NSInteger retVal = 0;
    
    for (NSInteger i = 0; i < [cellReference length]; i++) {
        unichar currentChar = [cellReference characterAtIndex:i];
        
        if (currentChar < '0' || currentChar > '9') {
            continue;
        }
        
        retVal = retVal * 10 + (currentChar - '0');
    }
    
    return retVal;
}

- (instancetype)initWithRowIndex:(NSInteger)rowIndex inWorksheet:(BRAWorksheet *)worksheet {
    NSDictionary *openXmlAttributes = @{
                                        @"_r": [NSString stringWithFormat:@"%ld", (long)rowIndex],
                                        @"_customHeight": @"0",
                                        @"c": @[]
                                        };
    
    self = [super initWithOpenXmlAttributes:openXmlAttributes inWorksheet:worksheet];
    
    return self;
}

- (void)loadAttributes {
    _cells = @[].mutableCopy;
    
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    
    if (dictionaryRepresentation.attributes[@"r"]) {
        _rowIndex = [dictionaryRepresentation.attributes[@"r"] integerValue];
    }
    
    if (dictionaryRepresentation.attributes[@"ht"]) {
        _height = [dictionaryRepresentation.attributes[@"ht"] integerValue];
    }
    
    if (dictionaryRepresentation.attributes[@"customHeight"]) {
        _customHeight = [dictionaryRepresentation.attributes[@"customHeight"] boolValue];
    }
    
    NSArray *cellsDict = [dictionaryRepresentation arrayValueForKeyPath:@"c"];
    
    for (NSDictionary *cellDict in cellsDict) {
        BRACell *cell = [[BRACell alloc] initWithOpenXmlAttributes:cellDict inWorksheet:_worksheet];
        
        cell.mergeCell = [_worksheet mergeCellForCell:cell];
        
        [_cells addObject:cell];
    }
    
}

- (void)setRowIndex:(NSInteger)rowIndex {
    _rowIndex = rowIndex;
    
    for (BRACell *cell in _cells) {
        cell.reference = [BRACell cellReferenceForColumnIndex:[cell columnIndex] andRowIndex:_rowIndex];
    }
}

- (NSInteger)height {
    if (_customHeight) {
        return _height;
    }
    
    return 15.;
}

- (void)addCell:(BRACell *)cell {
    [_cells addObject:cell];
    [_worksheet.cells addObject:cell];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    dictionaryRepresentation[@"_r"] = [NSString stringWithFormat:@"%ld", (long)_rowIndex];
    
    if (_customHeight) {
        dictionaryRepresentation[@"_ht"] = [NSString stringWithFormat:@"%ld", (long)_height];
        dictionaryRepresentation[@"_customHeight"] = [NSString stringWithFormat:@"%ld", (long)_customHeight];
    } else if (dictionaryRepresentation[@"_ht"]) {
        [dictionaryRepresentation removeObjectForKey:@"_ht"];
        [dictionaryRepresentation removeObjectForKey:@"_customHeight"];
    }
    
    //Sort cells by reference
    [_cells sortUsingComparator:^NSComparisonResult(BRACell *obj1, BRACell *obj2) {
        return [BRAColumn columnIndexForCellReference:obj1.reference] < [BRAColumn columnIndexForCellReference:obj2.reference]
        ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    
    NSMutableArray *cells = @[].mutableCopy;
    for (BRACell *cell in _cells) {
        [cells addObject:[cell dictionaryRepresentation]];
    }
    dictionaryRepresentation[@"c"] = cells;
    
    
    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> : %ld", [self class], self, (long)_rowIndex];
}

@end
