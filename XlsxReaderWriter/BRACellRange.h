//
//  BRACellRange.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@interface BRACellRange : BRAOpenXmlSubElement {
    NSString *_leftColumnName;
    NSString *_rightColumnName;
}

- (instancetype)initWithRangeReference:(NSString *)rangeReference;
- (NSString *)reference;

@property (nonatomic) NSInteger topRowIndex;
@property (nonatomic) NSInteger bottomRowIndex;
@property (nonatomic) NSInteger leffColumnIndex;
@property (nonatomic) NSInteger rightColumnIndex;


@end
