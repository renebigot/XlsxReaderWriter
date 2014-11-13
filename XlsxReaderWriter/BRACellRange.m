//
//  BRACellRange.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 17/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRACellRange.h"
#import "BRAColumn.h"

@implementation BRACellRange

- (instancetype)initWithRangeReference:(NSString *)rangeReference {
    if (self = [super init]) {
        self.dictionaryRepresentation = @{@"_ref": rangeReference};
        
        //regex to get each group of letters or number -> mergeCell bounds
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([A-Z]+)|([0-9]+)"
                                                                               options:0
                                                                                 error:NULL];
        
        NSArray *matchingResults = [regex matchesInString:rangeReference
                                                  options:0
                                                    range:NSMakeRange(0, [rangeReference length])];
        
        NSInteger matchingResultsCount = [matchingResults count];
        
        if (matchingResultsCount == 4) {
            for (NSInteger i = 0; i < matchingResultsCount; i++) {
                switch (i) {
                    case 0:
                        _leftColumnName = [rangeReference substringWithRange:[matchingResults[i] range]];
                        break;
                        
                    case 1:
                        _topRowIndex = [[rangeReference substringWithRange:[matchingResults[i] range]] integerValue];
                        break;
                        
                    case 2:
                        _rightColumnName = [rangeReference substringWithRange:[matchingResults[i] range]];
                        break;
                        
                    default:
                        _bottomRowIndex = [[rangeReference substringWithRange:[matchingResults[i] range]] integerValue];
                        break;
                }
            }
        } else if (matchingResultsCount == 2) {
            for (NSInteger i = 0; i < matchingResultsCount; i++) {
                switch (i) {
                    case 0:
                        _leftColumnName = [rangeReference substringWithRange:[matchingResults[i] range]];
                        _rightColumnName = _leftColumnName;
                        break;
                        
                    case 1:
                        _topRowIndex = [[rangeReference substringWithRange:[matchingResults[i] range]] integerValue];
                        _bottomRowIndex = _topRowIndex;
                        break;
                }
            }
        } else {
            return nil;
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    dictionaryRepresentation[@"_ref"] = self.reference;
    
    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

- (NSString *)reference {
    if (_topRowIndex == _bottomRowIndex && [_leftColumnName isEqual:_rightColumnName]) {
        return [NSString stringWithFormat:@"%@%ld",
                _rightColumnName,
                (long)_bottomRowIndex];
    } else {
        return [NSString stringWithFormat:@"%@%ld:%@%ld",
                _leftColumnName,
                (long)_topRowIndex,
                _rightColumnName,
                (long)_bottomRowIndex];
    }
}

- (NSInteger)leffColumnIndex {
    return [BRAColumn columnIndexForCellReference:_leftColumnName];
}

- (NSInteger)rightColumnIndex {
    return [BRAColumn columnIndexForCellReference:_rightColumnName];
}

- (void)setRightColumnIndex:(NSInteger)rightColumnIndex {
    _rightColumnName = [BRAColumn columnNameForColumnIndex:rightColumnIndex];
}

- (void)setLeffColumnIndex:(NSInteger)leffColumnIndex {
    _leftColumnName = [BRAColumn columnNameForColumnIndex:leffColumnIndex];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> : %@", [self class], self, [self reference]];
}

@end
