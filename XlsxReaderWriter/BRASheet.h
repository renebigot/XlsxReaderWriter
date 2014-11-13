//
//  BRASheet.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/11/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOpenXmlSubElement.h"

@interface BRASheet : BRAOpenXmlSubElement

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sheetId;
@property (nonatomic, strong) NSString *state;

@end
