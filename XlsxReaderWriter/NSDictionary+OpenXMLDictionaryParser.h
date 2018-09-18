//
//  NSDictionary+OpenXMLDictionaryParser.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 19/06/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;

@class NSXMLParser;

@interface NSDictionary (OpenXMLDictionaryParser)

+ (NSDictionary *)dictionaryWithOpenXmlParser:(NSXMLParser *)parser;
+ (NSDictionary *)dictionaryWithOpenXmlData:(NSData *)data;
+ (NSDictionary *)dictionaryWithOpenXmlString:(NSString *)string;
+ (NSDictionary *)dictionaryWithOpenXmlFile:(NSString *)path;

@end
