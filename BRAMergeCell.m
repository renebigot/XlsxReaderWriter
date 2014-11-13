//
//  BRAMergeCell.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAMergeCell.h"

@implementation BRAMergeCell

- (NSString *)firstCellReference {
    return [NSString stringWithFormat:@"%@%ld", _leftColumnName, (long)self.topRowIndex];
}

@end
