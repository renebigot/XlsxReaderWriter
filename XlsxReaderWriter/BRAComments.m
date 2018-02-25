//
//  BRAComments.m
//  XlsxReaderWriter
//
//  Created by René BIGOT on 23/09/2015.
//  Copyright © 2015 BRAE. All rights reserved.
//
#import "BRAComments.h"
#import "BRAComment.h"
#import "BRARow.h"
#import "BRACell.h"
#import "BRAColumn.h"
#import "XlsxReaderXMLDictionary.h"
#import "NSDictionary+OpenXmlString.h"

@implementation BRAComments

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.spreadsheetml.comments+xml";
}

- (NSString *)targetFormat {
    return @"../comments%ld.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *openXmlAttributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];
    
    NSArray *commentsArray = [openXmlAttributes xlsxReaderArrayValueForKeyPath:@"commentList.comment"];
    
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *comment in commentsArray) {
        [comments addObject:[[BRAComment alloc] initWithOpenXmlAttributes:comment]];
    }
    
    _comments = comments;
}

- (void)didAddRowsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_comments) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAComment *comment in self->_comments) {
                
                NSInteger commentRowIndex = [BRARow rowIndexForCellReference:comment.reference];
                
                if (commentRowIndex >= index) {
                    comment.reference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:comment.reference]
                                                                 andRowIndex:commentRowIndex + 1];
                }
            }
        }];
    }
}

- (void)didRemoveRowsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];
    
    @synchronized(_comments) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAComment *comment in self->_comments) {
                
                NSInteger commentRowIndex = [BRARow rowIndexForCellReference:comment.reference];
                
                if (commentRowIndex > index) {
                    comment.reference = [BRACell cellReferenceForColumnIndex:[BRAColumn columnIndexForCellReference:comment.reference]
                                                                 andRowIndex:commentRowIndex - 1];
                    
                } else if (commentRowIndex == index) {
                    [indexesToBeRemoved addIndex:index];
                }
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *comments = _comments.mutableCopy;
            [comments removeObjectsAtIndexes:indexesToBeRemoved];
            _comments = comments;
        }
    }
}

- (void)didAddColumnsAtIndexes:(NSIndexSet *)indexes {
    @synchronized(_comments) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAComment *comment in self->_comments) {
                
                NSInteger commentColumnIndex = [BRAColumn columnIndexForCellReference:comment.reference];
                
                if (commentColumnIndex >= index) {
                    comment.reference = [BRACell cellReferenceForColumnIndex:[BRARow rowIndexForCellReference:comment.reference]
                                                              andRowIndex:commentColumnIndex + 1];
                }
            }
        }];
    }
}

- (void)didRemoveColumnsAtIndexes:(NSIndexSet *)indexes {
    NSMutableIndexSet *indexesToBeRemoved = [[NSMutableIndexSet alloc] init];

    @synchronized(_comments) {
        [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            for (BRAComment *comment in self->_comments) {
                
                NSInteger commentColumnIndex = [BRAColumn columnIndexForCellReference:comment.reference];
                
                if (commentColumnIndex > index) {
                    comment.reference = [BRACell cellReferenceForColumnIndex:[BRARow rowIndexForCellReference:comment.reference]
                                                              andRowIndex:commentColumnIndex - 1];

                } else if (commentColumnIndex == index) {
                    [indexesToBeRemoved addIndex:index];
                }
                
            }
        }];
        
        if (indexesToBeRemoved.count > 0) {
            NSMutableArray *comments = _comments.mutableCopy;
            [comments removeObjectsAtIndexes:indexesToBeRemoved];
            _comments = comments;
        }
    }
}

- (NSString *)xmlRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation].mutableCopy;
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";
    
    NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
    
    for (BRAComment *comment in _comments) {
        [commentsArray addObject:[comment dictionaryRepresentation]];
    }
    
    [dictionaryRepresentation setValue:commentsArray forKeyPath:@"commentList.comment"];
    
    //Return xmlRepresentation
    _xmlRepresentation = [xmlHeader stringByAppendingString:[dictionaryRepresentation openXmlStringInNodeNamed:@"comments"]];
    
    return _xmlRepresentation;
}


@end
