//
//  BRACellFormat.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 08/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlSubElement.h"

@class BRAStyles, BRACellFill, BRANumberFormat;

@interface BRACellFormat : BRAOpenXmlSubElementWithStyle {
    BOOL _isCellStyleXf;
    NSDictionary *_stylesTextsAttributes;
    BRACellFill *_cellFill;
    BRANumberFormat *_numberFormat;
}

@property (nonatomic, getter=isProtected) BOOL protected;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSDictionary *textAttributes;

//Cell format (cellXfs) may have a reference to a cell style format (cellStyleXfs)
@property (nonatomic, weak) BRACellFormat *cellStyleFormat;

- (void)setCellFill:(BRACellFill *)cellFill;
- (BRACellFill *)cellFill;

- (void)setNumberFormat:(BRANumberFormat *)numberFormat;
- (BRANumberFormat *)numberFormat;


@end
