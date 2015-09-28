//
//  BRAOfficeDocument.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRARelationship.h"
#import "BRAStyles.h"
#import "BRACalcChain.h"
#import "BRAComments.h"
#import "BRAOpenXmlSubElement.h"

@class BRASharedStrings;

@interface BRAOfficeDocument : BRARelationship

- (BRAWorksheet *)worksheetNamed:(NSString *)worksheetName;
- (BRAWorksheet *)createWorksheetNamed:(NSString *)worksheetName;
- (BRAWorksheet *)createWorksheetNamed:(NSString *)worksheetName byCopyingWorksheet:(BRAWorksheet *)worksheet;
- (void)removeWorksheetNamed:(NSString *)worksheetName;

@property (nonatomic, weak) BRACalcChain *calcChain;
@property (nonatomic, weak) BRASharedStrings *sharedStrings;
@property (nonatomic, weak) BRAStyles *styles;
@property (nonatomic, strong) NSArray *sheets;
@property (nonatomic, strong, readonly) NSArray *worksheets;

@end
