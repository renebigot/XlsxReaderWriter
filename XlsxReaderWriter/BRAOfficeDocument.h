//
//  BRAOfficeDocument.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;
#import "BRARelationship.h"

@class BRASharedStrings, BRACalcChain, BRAStyles, BRAWorksheet;

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
