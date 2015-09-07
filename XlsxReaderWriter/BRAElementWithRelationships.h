//
//  BRAElementWithRelationships.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAOpenXmlElement.h"
#import "NSDictionary+OpenXMLDictionaryParser.h"

@class BRARelationships;

@interface BRAElementWithRelationships : BRAOpenXmlElement

@property (nonatomic, strong) BRARelationships *relationships;

- (NSString *)relationshipsTarget;

@end
