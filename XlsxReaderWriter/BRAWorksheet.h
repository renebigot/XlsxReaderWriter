//
//  BRAWorksheet.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 10/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRACell.h"
#import "BRACellRange.h"
#import "BRAMergeCell.h"
#import "BRAStyles.h"
#import "BRADrawing.h"
#import "BRAImage.h"
#import "BRACalcChain.h"
#import "BRASharedStrings.h"
#import "BRAComments.h"

@interface BRAWorksheet : BRARelationship {
    BRACellRange *_dimension;
}

- (BRAMergeCell *)mergeCellForCell:(BRACell *)cell;
- (BRACell *)cellForCellReference:(NSString *)cellReference;
- (BRACell *)cellOrFirstCellInMergeCellForCellReference:(NSString *)cellReference;
- (BRACell *)cellForCellReference:(NSString *)cellReference shouldCreate:(BOOL)shouldCreate;

//Image
- (BRAImage *)imageForCellReference:(NSString *)cellReference;
- (BRAWorksheetDrawing *)addImage:(BRANativeImage *)image betweenCellsReferenced:(NSString *)firstCellReference and:(NSString *)secondCellReference withInsets:(BRANativeEdgeInsets)insets preserveTransparency:(BOOL)transparency;
- (BRAWorksheetDrawing *)addImage:(BRANativeImage *)image inCellReferenced:(NSString *)cellReference withOffset:(CGPoint)offset size:(CGSize)size preserveTransparency:(BOOL)transparency;
- (BRAWorksheetDrawing *)addImage:(BRANativeImage *)image inFrame:(CGRect)frame preserveTransparency:(BOOL)transparency;

//Column

//Rows
- (void)addRowAt:(NSInteger)rowIndex;
- (void)addRowsAt:(NSInteger)rowIndex count:(NSInteger)numberOfRowsToAdd;
- (void)removeRow:(NSInteger)rowIndex;
- (void)removeRow:(NSInteger)rowIndex count:(NSInteger)numberOfRowsToRemove;

@property (nonatomic, getter=isTabSelected) BOOL tabSelected;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *mergeCells;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, strong) BRACellRange *dimension;
@property (nonatomic, strong) BRADrawing *drawings;
@property (nonatomic, strong) BRAComments *comments;
@property (nonatomic, strong) BRASharedStrings *sharedStrings;
@property (nonatomic, strong) BRAStyles *styles;
@property (nonatomic, strong) BRACalcChain *calcChain;

@end
