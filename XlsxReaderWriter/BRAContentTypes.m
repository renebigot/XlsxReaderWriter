//
//  BRAContentTypes.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAContentTypes.h"
#import "BRARelationship.h"

@implementation BRAContentTypes

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];
    
    NSMutableArray *defaultExtensions = @[].mutableCopy;
    for (NSDictionary *attributesDict in attributes[@"Default"]) {
        [defaultExtensions addObject:[[BRAContentTypesDefaultExtension alloc] initWithOpenXmlAttributes:attributesDict]];
    }
    
    self.defaultExtensions = defaultExtensions;
    
    NSMutableArray *overrides = @[].mutableCopy;
    for (NSDictionary *attributesDict in attributes[@"Override"]) {
        [overrides addObject:[[BRAContentTypesOverride alloc] initWithOpenXmlAttributes:attributesDict]];
    }
    
    self.overrides = overrides;
}


- (NSString *)xmlRepresentation {
    NSMutableArray *defaultExtensions = @[].mutableCopy;
    for (BRAContentTypesDefaultExtension *extension in _defaultExtensions) {
        [defaultExtensions addObject:[extension dictionaryRepresentation]];
    }
    
    NSMutableArray *overrides = @[].mutableCopy;
    for (BRAContentTypesOverride *override in _overrides) {
        [overrides addObject:[override dictionaryRepresentation]];
    }
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";
    NSString *xmlString = [@{
                             @"_xmlns": @"http://schemas.openxmlformats.org/package/2006/content-types",
                             @"Default": defaultExtensions,
                             @"Override": overrides
                             } openXmlStringInNodeNamed:@"Types"];
    
    if ([xmlString rangeOfString:xmlHeader].location == NSNotFound) {
        xmlString = [xmlHeader stringByAppendingString:xmlString];
    }
    
    return xmlString;
}

- (BOOL)hasContentTypeForPart:(NSString *)partName {
    NSString *extension = partName.pathExtension;
    
    NSInteger index = [_defaultExtensions indexOfObjectPassingTest:^BOOL(BRAContentTypesDefaultExtension *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.extension isEqual:extension]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return index != NSNotFound;
}

- (BOOL)hasOverrideForPart:(NSString *)partName {
    NSInteger index = [_overrides indexOfObjectPassingTest:^BOOL(BRAContentTypesOverride *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.partName isEqual:partName]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    return index != NSNotFound;
}

- (void)overrideContentType:(NSString *)contentType forPart:(NSString *)partName {
    BRAContentTypesOverride *override = [[BRAContentTypesOverride alloc] initWithContentType:contentType forPart:partName];
    
    NSMutableArray *overrides = _overrides.mutableCopy;
    [overrides addObject:override];
    
    _overrides = overrides;
}

- (void)addContentTypeForExtension:(NSString *)extension {
    BRAContentTypesDefaultExtension *defaultExtension = [[BRAContentTypesDefaultExtension alloc] initWithExtension:extension];
    
    NSMutableArray *defaultExtensions = _defaultExtensions.mutableCopy;
    [defaultExtensions addObject:defaultExtension];
    
    _defaultExtensions = defaultExtensions;
}

@end
