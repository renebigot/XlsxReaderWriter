//
//  BRACalcChain.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 24/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRACalcChain.h"
#import "BRARow.h"
#import "BRACell.h"
#import "BRAColumn.h"

@implementation BRACalcChain

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml";
}

- (NSString *)targetFormat {
    return @"calcChain.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *openXmlAttributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];
    
    NSArray *calcChainCellArray = [openXmlAttributes arrayValueForKeyPath:@"c"];
    
    NSMutableArray *cells = @[].mutableCopy;
    
    for (NSDictionary *calcChainCellDict in calcChainCellArray) {
        [cells addObject:[[BRACalcChainCell alloc] initWithOpenXmlAttributes:calcChainCellDict]];
    }
    
    _cells = cells;
}

- (void)didAddRowsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_cells) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRACalcChainCell *cell in _cells) {
                
                NSInteger cellRowIndex = [BRARow rowIndexForCellReference:cell.reference];
                
                if (cellRowIndex >= index) {
                    cell.reference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:cell.reference]
                                                              andRowIndex:cellRowIndex + 1];
                }
            }
        }];
    }
}

- (void)didRemoveRowsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];
    
    @synchronized(_cells) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRACalcChainCell *cell in _cells) {
                
                NSInteger cellRowIndex = [BRARow rowIndexForCellReference:cell.reference];
                
                if (cellRowIndex > index) {
                    cell.reference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:cell.reference]
                                                              andRowIndex:cellRowIndex - 1];
                } else if (cellRowIndex == index) {
                    [indexesToBeRemoved addIndex:index];
                }
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *cells = _cells.mutableCopy;
            [cells removeObjectsAtIndexes:indexesToBeRemoved];
            _cells = cells;
        }
    }
}

- (void)didAddColumnsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_cells) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRACalcChainCell *cell in _cells) {
                
                NSInteger cellColumnIndex = [BRAColumn columnIndexForCellReference:cell.reference];
                
                if (cellColumnIndex >= index) {
                    cell.reference = [BRACell cellReferenceForColumnIndex:[BRARow rowIndexForCellReference:cell.reference]
                                                              andRowIndex:cellColumnIndex + 1];
                }
            }
        }];
    }
}

- (void)didRemoveColumnsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];
    
    @synchronized(_cells) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRACalcChainCell *cell in _cells) {
                
                NSInteger cellColumnIndex = [BRAColumn columnIndexForCellReference:cell.reference];
                
                if (cellColumnIndex > index) {
                    cell.reference = [BRACell cellReferenceForColumnIndex:[BRARow rowIndexForCellReference:cell.reference]
                                                              andRowIndex:cellColumnIndex - 1];
                    
                } else if (cellColumnIndex == index) {
                    [indexesToBeRemoved addIndex:index];
                }
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *cells = _cells.mutableCopy;
            [cells removeObjectsAtIndexes:indexesToBeRemoved];
            _cells = cells;
        }
    }
    
}

- (NSString *)xmlRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation].mutableCopy;
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";
    
    NSMutableArray *cellsArray = @[].mutableCopy;
    
    for (BRACalcChainCell *cell in _cells) {
        [cellsArray addObject:[cell dictionaryRepresentation]];
    }
    
    [dictionaryRepresentation setValue:cellsArray forKey:@"c"];
    
    //Return xmlRepresentation
    _xmlRepresentation = [xmlHeader stringByAppendingString:[dictionaryRepresentation openXmlStringInNodeNamed:@"calcChain"]];
    
    return _xmlRepresentation;
}

@end
