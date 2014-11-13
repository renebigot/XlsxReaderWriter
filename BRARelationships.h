//
//  BRARelationships.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 04/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRARelationship.h"

@interface BRARelationships : BRAOpenXmlElement

@property (nonatomic, strong) NSMutableArray *relationshipsArray;

- (id)relationshipWithId:(NSString *)rId;
- (id)anyRelationshipWithType:(NSString *)relationshipType;
- (void)addRelationship:(BRARelationship *)relationship;
- (void)removeRelationshipWithId:(NSString *)identifier;
- (NSArray *)allRelationships;
- (NSString *)relationshipIdForNewRelationship;

@end
