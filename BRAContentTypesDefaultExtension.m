//
//  BRAContentTypesDefaultExtension.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 23/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAContentTypesDefaultExtension.h"
#import "BRARelationship.h"

@implementation BRAContentTypesDefaultExtension

+ (NSDictionary *)knownTypes {
    //Only the content types we could create with this library
    return @{
             @"xml": @"application/xml",
             @"rels": @"application/vnd.openxmlformats-package.relationships+xml",
             @"jpeg": @"image/jpeg",
             @"jpg": @"image/jpeg",
             @"png": @"image/png",
             @"gif": @"image/gif"
             };
}

- (instancetype)initWithExtension:(NSString *)extension {
    NSString *contentType = [BRAContentTypesDefaultExtension knownTypes][extension];
    
    if (!contentType) {
        return nil;
    }
    
    NSDictionary *attributes = @{
                                 @"_Extension": extension,
                                 @"_ContentType": contentType
                                 };
    
    self = [super initWithOpenXmlAttributes:attributes];
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];

    self.extension = dictionaryRepresentation.attributes[@"Extension"];
    self.contentType = dictionaryRepresentation.attributes[@"ContentType"];
}

@end
