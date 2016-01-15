//
//  BRASharedString.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 07/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//


#import "BRAOfficeDocument.h"
#import "BRAOpenXmlSubElement.h"

@interface BRASharedString : BRAOpenXmlSubElementWithStyle {
    NSMutableAttributedString *_attributedString;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString inStyles:(BRAStyles *)styles;

//Read only ! We won't change shared strings but create new ones
- (NSAttributedString *)attributedString;

@end
