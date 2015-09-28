//
//  BRADrawing.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRADrawing.h"
#import "BRARow.h"
#import "BRACell.h"
#import "BRAColumn.h"

#define ONE_CELL_ANCHOR @"xdr:oneCellAnchor"
#define TWO_CELL_ANCHOR @"xdr:twoCellAnchor"
#define ABSOLUTE_ANCHOR @"xdr:absoluteAnchor"

@implementation BRADrawing

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.drawing+xml";
}

- (NSString *)targetFormat {
    return @"../drawings/drawing%ld.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
    _worksheetDrawings = @[];
    
    [self addWorksheetDrawingsForAnchorType:ONE_CELL_ANCHOR];
    [self addWorksheetDrawingsForAnchorType:TWO_CELL_ANCHOR];
    [self addWorksheetDrawingsForAnchorType:ABSOLUTE_ANCHOR];
}

- (void)addWorksheetDrawingsForAnchorType:(NSString *)anchorType {
    NSMutableArray *worksheetDrawings = [_worksheetDrawings mutableCopy];
    NSDictionary *attributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];

    NSArray *wsDrArray = [attributes arrayValueForKeyPath:anchorType];
    
    for (NSDictionary *wsDrDict in wsDrArray) {
        [worksheetDrawings addObject:[[BRAWorksheetDrawing alloc] initWithOpenXmlAttributes:wsDrDict]];
    }

    _worksheetDrawings = worksheetDrawings;
}

- (BRAWorksheetDrawing *)addDrawing:(BRAWorksheetDrawing *)drawing {
    //Create the worksheet drawing
    NSMutableArray *worksheetDrawings = [_worksheetDrawings mutableCopy];
    
    BRAWorksheetDrawing *wsDr = [[BRAWorksheetDrawing alloc] initWithOpenXmlAttributes:drawing.dictionaryRepresentation];
    [worksheetDrawings addObject:wsDr];
    _worksheetDrawings = worksheetDrawings;
    
    return wsDr;
}

- (BRAWorksheetDrawing *)addDrawingForImage:(BRAImage *)image withAnchor:(BRAAnchor *)anchor {
    //Add image to relationships
    [self.relationships addRelationship:image];

    //Create the worksheet drawing
    NSMutableArray *worksheetDrawings = [_worksheetDrawings mutableCopy];

    BRAWorksheetDrawing *wsDr = [[BRAWorksheetDrawing alloc] initWithImage:image andAnchor:anchor];
    wsDr.drawingIdentifier = [self newDrawingIdentifier];
    [worksheetDrawings addObject:wsDr];
    
    _worksheetDrawings = worksheetDrawings;
    
    return wsDr;
}

- (NSString *)newDrawingIdentifier {
    NSInteger drawingId = 1;
    for (BRAWorksheetDrawing *wsDr in _worksheetDrawings) {
        drawingId = MAX(drawingId, [wsDr.drawingIdentifier integerValue] + 1);
    }
    
    return [NSString stringWithFormat:@"%ld", (long)drawingId];
}

- (void)didAddRowsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_worksheetDrawings) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAWorksheetDrawing *worksheetDrawing in _worksheetDrawings) {
                
                //Change top left reference if necessary
                if ([worksheetDrawing.anchor respondsToSelector:@selector(topLeftCellReference)]) {
                    
                    NSString *topLeftCellReference = [(BRAOneCellAnchor *)worksheetDrawing.anchor topLeftCellReference];
                    NSInteger cellRowIndex = [BRARow rowIndexForCellReference:topLeftCellReference];
                    
                    if (cellRowIndex >= index) {
                        ((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:topLeftCellReference]
                                                                                                                      andRowIndex:cellRowIndex + 1];
                        
                        //Change bottom right reference if necessary
                        if ([worksheetDrawing.anchor respondsToSelector:@selector(bottomRightCellReference)]) {
                            
                            NSString *bottomRightCellReference = [(BRATwoCellAnchor *)worksheetDrawing.anchor bottomRightCellReference];
                            cellRowIndex = [BRARow rowIndexForCellReference:bottomRightCellReference];
                            ((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellReference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:bottomRightCellReference]
                                                                                                                              andRowIndex:cellRowIndex + 1];
                        }
                    }
                }
            }
        }];
    }
}

- (void)didRemoveRowsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];
    
    @synchronized(_worksheetDrawings) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAWorksheetDrawing *worksheetDrawing in _worksheetDrawings) {
                
                //Change top left reference if necessary
                if ([worksheetDrawing.anchor respondsToSelector:@selector(topLeftCellReference)]) {
                    
                    NSString *topLeftCellReference = [(BRAOneCellAnchor *)worksheetDrawing.anchor topLeftCellReference];
                    NSInteger cellRowIndex = [BRARow rowIndexForCellReference:topLeftCellReference];
                    
                    if (cellRowIndex > index) {
                        ((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:topLeftCellReference]
                                                                                                                      andRowIndex:cellRowIndex - 1];
                        
                        //Change bottom right reference if necessary
                        if ([worksheetDrawing.anchor respondsToSelector:@selector(bottomRightCellReference)]) {
                            
                            NSString *bottomRightCellReference = [(BRATwoCellAnchor *)worksheetDrawing.anchor bottomRightCellReference];
                            cellRowIndex = [BRARow rowIndexForCellReference:bottomRightCellReference];
                            ((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellReference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:bottomRightCellReference]
                                                                                                                              andRowIndex:cellRowIndex - 1];
                        }
                    } else if (cellRowIndex == index) {
                        [indexesToBeRemoved addIndex:index];
                    }
                }
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *worksheetDrawings = _worksheetDrawings.mutableCopy;
            [worksheetDrawings removeObjectsAtIndexes:indexesToBeRemoved];
            _worksheetDrawings = worksheetDrawings;
        }
    }
}

- (void)didAddColumnsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_worksheetDrawings) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAWorksheetDrawing *worksheetDrawing in _worksheetDrawings) {
                
                //Change top left reference if necessary
                if ([worksheetDrawing.anchor respondsToSelector:@selector(topLeftCellReference)]) {
                    
                    NSString *topLeftCellReference = [(BRAOneCellAnchor *)worksheetDrawing.anchor topLeftCellReference];
                    NSInteger cellColumnIndex = [BRAColumn columnIndexForCellReference:topLeftCellReference];
                    
                    if (cellColumnIndex >= index) {
                        ((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference = [BRACell cellReferenceForColumnIndex:cellColumnIndex + 1
                                                                                                                      andRowIndex:[BRARow rowIndexForCellReference:topLeftCellReference]];
                        
                        //Change bottom right reference if necessary
                        if ([worksheetDrawing.anchor respondsToSelector:@selector(bottomRightCellReference)]) {
                            
                            NSString *bottomRightCellReference = [(BRATwoCellAnchor *)worksheetDrawing.anchor bottomRightCellReference];
                            cellColumnIndex = [BRAColumn columnIndexForCellReference:bottomRightCellReference];
                            
                            ((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellReference = [BRACell cellReferenceForColumnIndex:cellColumnIndex + 1
                                                                                                                              andRowIndex:[BRARow rowIndexForCellReference:bottomRightCellReference]];
                        }
                    }
                }
            }
        }];
    }
}

- (void)didRemoveColumnsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];
    
    @synchronized(_worksheetDrawings) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAWorksheetDrawing *worksheetDrawing in _worksheetDrawings) {
                
                //Change top left reference if necessary
                if ([worksheetDrawing.anchor respondsToSelector:@selector(topLeftCellReference)]) {
                    
                    NSString *topLeftCellReference = [(BRAOneCellAnchor *)worksheetDrawing.anchor topLeftCellReference];
                    NSInteger cellColumnIndex = [BRAColumn columnIndexForCellReference:topLeftCellReference];
                    
                    if (cellColumnIndex > index) {
                        ((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference = [BRACell cellReferenceForColumnIndex:cellColumnIndex - 1
                                                                                                                      andRowIndex:[BRARow rowIndexForCellReference:topLeftCellReference]];
                        
                        //Change bottom right reference if necessary
                        if ([worksheetDrawing.anchor respondsToSelector:@selector(bottomRightCellReference)]) {
                            
                            NSString *bottomRightCellReference = [(BRATwoCellAnchor *)worksheetDrawing.anchor bottomRightCellReference];
                            cellColumnIndex = [BRAColumn columnIndexForCellReference:bottomRightCellReference];
                            
                            ((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellReference = [BRACell cellReferenceForColumnIndex:cellColumnIndex - 1
                                                                                                                              andRowIndex:[BRARow rowIndexForCellReference:bottomRightCellReference]];
                        }

                    } else if (cellColumnIndex == index) {
                        [indexesToBeRemoved addIndex:index];
                        
                    }
                }
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *worksheetDrawings = _worksheetDrawings.mutableCopy;
            [worksheetDrawings removeObjectsAtIndexes:indexesToBeRemoved];
            _worksheetDrawings = worksheetDrawings;
        }
    }
}

#pragma mark -

- (NSString *)xmlRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation].mutableCopy;
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";

    NSMutableArray *oneCellAnchoredXdr = @[].mutableCopy;
    NSMutableArray *twoCellAnchoredXdr = @[].mutableCopy;
    NSMutableArray *absoluteAnchoredXdr = @[].mutableCopy;
    
    for (BRAWorksheetDrawing *worksheetDrawing in _worksheetDrawings) {
        if ([worksheetDrawing.anchor isKindOfClass:[BRAAbsoluteAnchor class]]) {
            [absoluteAnchoredXdr addObject:[worksheetDrawing dictionaryRepresentation]];
            
        } else if ([worksheetDrawing.anchor isKindOfClass:[BRATwoCellAnchor class]]) {
            [twoCellAnchoredXdr addObject:[worksheetDrawing dictionaryRepresentation]];
            
        } else if ([worksheetDrawing.anchor isKindOfClass:[BRAOneCellAnchor class]]) {
            [oneCellAnchoredXdr addObject:[worksheetDrawing dictionaryRepresentation]];
        }
    }
    
    dictionaryRepresentation[ONE_CELL_ANCHOR] = oneCellAnchoredXdr;
    dictionaryRepresentation[TWO_CELL_ANCHOR] = twoCellAnchoredXdr;
    dictionaryRepresentation[ABSOLUTE_ANCHOR] = absoluteAnchoredXdr;
    
    _xmlRepresentation = [xmlHeader stringByAppendingString:[dictionaryRepresentation openXmlStringInNodeNamed:@"xdr:wsDr"]];
    
    return _xmlRepresentation;
}

- (instancetype)copy {
    BRADrawing *copy = [super copy];
    
    copy.worksheetDrawings = @[];
    copy.relationships.relationshipsArray = @[].mutableCopy;
    
    for (BRAWorksheetDrawing *wsDr in self.worksheetDrawings) {
        // We create a new image file when duplicating image, so we create a new relationship
        if (wsDr.identifier) {
            BRAImage *imageCopy = [[self.relationships relationshipWithId:wsDr.identifier] copy];
            
            if (imageCopy) {
                imageCopy.identifier = [copy.relationships relationshipIdForNewRelationship];
                
                [copy addDrawingForImage:imageCopy withAnchor:wsDr.anchor];
            }
            
        } else {
            //If no relationship id, we just push the drawing data to worksheetDrawings
            [copy addDrawing:wsDr];
        }
    }

    return copy;
}

@end
