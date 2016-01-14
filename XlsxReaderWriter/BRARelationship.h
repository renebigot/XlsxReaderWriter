//
//  BRARelationship.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"
#import "NativeColor+OpenXML.h"
#import "BRAElementWithRelationships.h"

@interface BRARelationship : BRAElementWithRelationships

+ (NSString *)fullRelationshipType;
- (instancetype)initWithId:(NSString *)relationshipId type:(NSString *)relationshipType andTarget:(NSString *)relationTarget inParentDirectory:(NSString *)parentDirectory;
- (instancetype)initWithXmlRepresentation:(NSString *)xmlRepresentation forRelationId:(NSString *)relationId inParentDirectory:(NSString *)parentDirectory;
- (instancetype)initWithDataRepresentation:(NSData *)dataRepresentation forRelationId:(NSString *)relationId inParentDirectory:(NSString *)parentDirectory;
- (NSString *)contentType;
- (NSString *)targetFormat;
- (NSString *)newTarget;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *type;

@end
