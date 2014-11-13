//
//  BRAContentTypesOverride.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 23/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAContentTypesOverride.h"
#import "BRARelationship.h"

@implementation BRAContentTypesOverride

- (instancetype)initWithContentType:(NSString *)contentType forPart:(NSString *)partName {
    NSDictionary *attributes = @{
                                 @"_ContentType": contentType,
                                 @"_PartName": partName,
                                 };
    
    self = [super initWithOpenXmlAttributes:attributes];
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];

    self.contentType = dictionaryRepresentation.attributes[@"ContentType"];
    self.partName = dictionaryRepresentation.attributes[@"PartName"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> ContentType: %@ - PartName: %@", self.class, self, _contentType, _partName];
}

@end

