//
//  NSDictionary+OpenXmlDictionaryParser.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 19/06/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "NSDictionary+OpenXmlDictionaryParser.h"

@implementation NSDictionary (OpenXmlDictionaryParser)

+ (NSDictionary *)dictionaryWithOpenXmlParser:(NSXMLParser *)parser {
	XMLDictionaryParser *dictionaryParser = [[XMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithParser:parser];
}

+ (NSDictionary *)dictionaryWithOpenXmlData:(NSData *)data {
	XMLDictionaryParser *dictionaryParser = [[XMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithData:data];
}

+ (NSDictionary *)dictionaryWithOpenXmlString:(NSString *)string {
	XMLDictionaryParser *dictionaryParser = [[XMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithString:string];
}

+ (NSDictionary *)dictionaryWithOpenXmlFile:(NSString *)path {
	XMLDictionaryParser *dictionaryParser = [[XMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithFile:path];
}

@end
