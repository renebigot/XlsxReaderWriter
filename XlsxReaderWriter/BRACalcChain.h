//
//  BRACalcChain.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 24/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRAOpenXmlSubElement.h"

@interface BRACalcChainCell : BRAOpenXmlSubElement

@property (nonatomic, strong) NSString *reference;

@end

@interface BRACalcChain : BRARelationship

- (void)didAddRowsAtIndexes:(NSIndexSet *)indexes;
- (void)didRemoveRowsAtIndexes:(NSIndexSet *)indexes;
- (void)didAddColumnsAtIndexes:(NSIndexSet *)indexes;
- (void)didRemoveColumnsAtIndexes:(NSIndexSet *)indexes;

@property (nonatomic, strong) NSArray *cells;

@end
