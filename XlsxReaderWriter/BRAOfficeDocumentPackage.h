//
//  BRAOfficeDocumentPackage.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAElementWithRelationships.h"
#import "BRAOfficeDocument.h"
#import "BRAContentTypes.h"
#import "BRAWorksheet.h"
#import "BRARow.h"
#import "BRAColumn.h"
#import "BRACell.h"

@interface BRAOfficeDocumentPackage : BRAElementWithRelationships

@property (nonatomic, strong) BRAContentTypes *contentTypes;
@property (nonatomic, strong) BRAOfficeDocument *workbook;
@property (nonatomic, strong) NSString *cacheDirectory;

+ (instancetype)open:(NSString *)filePath;
+ (instancetype)create:(NSString *)filePath;
- (void)saveAs:(NSString *)filePath;

@end
