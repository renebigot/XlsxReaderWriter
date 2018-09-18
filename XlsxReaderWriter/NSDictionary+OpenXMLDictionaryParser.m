//
//  NSDictionary+OpenXMLDictionaryParser.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 19/06/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "NSDictionary+OpenXMLDictionaryParser.h"
#import "XlsxReaderXMLDictionary.h"

@implementation NSDictionary (OpenXMLDictionaryParser)

+ (NSDictionary *)dictionaryWithOpenXmlParser:(NSXMLParser *)parser {
	XlsxReaderXMLDictionaryParser *dictionaryParser = [[XlsxReaderXMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithParser:parser];
}

+ (NSDictionary *)dictionaryWithOpenXmlData:(NSData *)data {
	XlsxReaderXMLDictionaryParser *dictionaryParser = [[XlsxReaderXMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithData:data];
}

+ (NSDictionary *)dictionaryWithOpenXmlString:(NSString *)string {
	XlsxReaderXMLDictionaryParser *dictionaryParser = [[XlsxReaderXMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithString:string];
}

+ (NSDictionary *)dictionaryWithOpenXmlFile:(NSString *)path {
	XlsxReaderXMLDictionaryParser *dictionaryParser = [[XlsxReaderXMLDictionaryParser sharedInstance] copy];
    [dictionaryParser setStripEmptyNodes:NO];
    [dictionaryParser setTrimWhiteSpace:NO];
    return [dictionaryParser dictionaryWithFile:path];
}

@end
