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
}

@property (nonatomic, getter=isProtected) BOOL protected;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, strong) BRACellFill *cellFill;
@property (nonatomic, strong) NSDictionary *textAttributes;
@property (nonatomic, strong) BRANumberFormat *numberFormat;

//Cell format (cellXfs) may have a reference to a cell style format (cellStyleXfs)
@property (nonatomic, weak) BRACellFormat *cellStyleFormat;

@end
