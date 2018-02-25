//
//  BRAOfficeDocumentPackage.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;

#import "BRAElementWithRelationships.h"

@class BRAContentTypes, BRAOfficeDocument;

@interface BRAOfficeDocumentPackage : BRAElementWithRelationships

@property (nonatomic, strong) BRAContentTypes *contentTypes;
@property (nonatomic, strong) BRAOfficeDocument *workbook;
@property (nonatomic, strong) NSString *cacheDirectory;

+ (instancetype)open:(NSString *)filePath;
+ (instancetype)create:(NSString *)filePath;
- (void)saveAs:(NSString *)filePath;

@end
