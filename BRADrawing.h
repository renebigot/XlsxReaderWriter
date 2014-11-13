//
//  BRADrawing.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRARelationships.h"
#import "BRAWorksheetDrawing.h"
#import "BRAImage.h"

@interface BRADrawing : BRARelationship

- (void)didAddRowAtIndex:(NSInteger)index;
- (void)didRemoveRowAtIndex:(NSInteger)index;
- (void)didAddColumnAtIndex:(NSInteger)index;
- (void)didRemoveColumnAtIndex:(NSInteger)index;
- (BRAWorksheetDrawing *)addDrawingForImage:(BRAImage *)image withAnchor:(BRAAnchor *)anchor;

@property (nonatomic, strong) NSArray *worksheetDrawings;

@end
