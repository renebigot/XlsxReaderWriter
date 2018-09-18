//
//  BRADrawing.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;
#import "BRARelatedToColumnAndRowProtocol.h"
#import "BRARelationship.h"

@class BRAWorksheetDrawing, BRAImage, BRAAnchor;

@interface BRADrawing : BRARelationship <BRARelatedToColumnAndRowProtocol>

- (BRAWorksheetDrawing *)addDrawingForImage:(BRAImage *)image withAnchor:(BRAAnchor *)anchor;

@property (nonatomic, strong) NSArray *worksheetDrawings;

@end
