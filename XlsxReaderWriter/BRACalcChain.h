//
//  BRACalcChain.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 24/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRARelatedToColumnAndRowProtocol.h"
#import "BRACalcChainCell.h"

@interface BRACalcChain : BRARelationship <BRARelatedToColumnAndRowProtocol>

@property (nonatomic, strong) NSArray *cells;

@end
