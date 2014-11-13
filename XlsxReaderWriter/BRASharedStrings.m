//
//  BRASharedStrings.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRASharedStrings.h"
#import "BRAStyles.h"
#import "BRASharedString.h"

@implementation BRASharedStrings

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml";
}

- (NSString *)targetFormat {
    return @"sharedStrings.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];

    NSArray *siArray = [attributes arrayValueForKeyPath:@"si"];
    
    //Create shared strings
    NSMutableArray *sharedStringsArray = [[NSMutableArray alloc] initWithCapacity:[siArray count]];
    for (NSDictionary *sharedStringDict in siArray) {
        BRASharedString *sharedString = [[BRASharedString alloc] initWithOpenXmlAttributes:sharedStringDict];
        if (sharedString) [sharedStringsArray addObject:sharedString];
    }
    
    if (sharedStringsArray) {
        _sharedStrings = sharedStringsArray;
    } else {
        _sharedStrings = @[];
    }
}

- (void)addSharedString:(BRASharedString *)sharedString {
    NSMutableArray *sharedStrings = _sharedStrings.mutableCopy;
    [sharedStrings addObject:sharedString];
    
    _sharedStrings = sharedStrings;
}

- (void)setStyles:(BRAStyles *)styles {
    _styles = styles;
    
    [_sharedStrings makeObjectsPerformSelector:@selector(setStyles:) withObject:_styles];
}

#pragma mark -

- (NSString *)xmlRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation].mutableDeepCopy;
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";
    
    NSMutableArray *sharedStringsArray = @[].mutableCopy;
    
    for (BRASharedString *sharedString in _sharedStrings) {
        [sharedStringsArray addObject:[sharedString dictionaryRepresentation]];
    }
    
    dictionaryRepresentation[@"_count"] = [NSString stringWithFormat:@"%ld", (long)sharedStringsArray.count];
    dictionaryRepresentation[@"_uniqueCount"] = [NSString stringWithFormat:@"%ld", (long)sharedStringsArray.count];
    dictionaryRepresentation[@"si"] = sharedStringsArray;
    
    _xmlRepresentation = [xmlHeader stringByAppendingString:[dictionaryRepresentation openXmlStringInNodeNamed:@"sst"]];
    
    return _xmlRepresentation;
}

@end
