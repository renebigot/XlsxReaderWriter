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

- (void)didAddRowAtIndex:(NSInteger)index;
- (void)didRemoveRowAtIndex:(NSInteger)index;
- (void)didAddColumnAtIndex:(NSInteger)index;
- (void)didRemoveColumnAtIndex:(NSInteger)index;

@property (nonatomic, strong) NSArray *cells;

@end
