//
//  XlsxReaderXMLDictionary.h
//
//  Version 1.4.1
//
//  Created by Nick Lockwood on 15/11/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//
//  Get the latest version of XlsxReaderXMLDictionary from here:
//
//  https://github.com/nicklockwood/XlsxReaderXMLDictionary
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, XlsxReaderXMLDictionaryAttributesMode)
{
    XlsxReaderXMLDictionaryAttributesModePrefixed = 0, //default
    XlsxReaderXMLDictionaryAttributesModeDictionary,
    XlsxReaderXMLDictionaryAttributesModeUnprefixed,
    XlsxReaderXMLDictionaryAttributesModeDiscard
};


typedef NS_ENUM(NSInteger, XlsxReaderXMLDictionaryNodeNameMode)
{
    XlsxReaderXMLDictionaryNodeNameModeRootOnly = 0, //default
    XlsxReaderXMLDictionaryNodeNameModeAlways,
    XlsxReaderXMLDictionaryNodeNameModeNever
};


static NSString *const XlsxReaderXMLDictionaryAttributesKey   = @"__attributes";
static NSString *const XlsxReaderXMLDictionaryCommentsKey     = @"__comments";
static NSString *const XlsxReaderXMLDictionaryTextKey         = @"__text";
static NSString *const XlsxReaderXMLDictionaryNodeNameKey     = @"__name";
static NSString *const XlsxReaderXMLDictionaryAttributePrefix = @"_";


@interface XlsxReaderXMLDictionaryParser : NSObject <NSCopying>

+ (XlsxReaderXMLDictionaryParser *)sharedInstance;

@property (nonatomic, assign) BOOL collapseTextNodes; // defaults to YES
@property (nonatomic, assign) BOOL stripEmptyNodes;   // defaults to YES
@property (nonatomic, assign) BOOL trimWhiteSpace;    // defaults to YES
@property (nonatomic, assign) BOOL alwaysUseArrays;   // defaults to NO
@property (nonatomic, assign) BOOL preserveComments;  // defaults to NO
@property (nonatomic, assign) BOOL wrapRootNode;      // defaults to NO

@property (nonatomic, assign) XlsxReaderXMLDictionaryAttributesMode attributesMode;
@property (nonatomic, assign) XlsxReaderXMLDictionaryNodeNameMode nodeNameMode;

- (nullable NSDictionary<NSString *, id> *)dictionaryWithParser:(NSXMLParser *)parser;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithData:(NSData *)data;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithString:(NSString *)string;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithFile:(NSString *)path;

@end


@interface NSDictionary (XlsxReaderXMLDictionary)

+ (nullable NSDictionary<NSString *, id> *)xlsxReaderDictionaryWithXMLParser:(NSXMLParser *)parser;
+ (nullable NSDictionary<NSString *, id> *)xlsxReaderDictionaryWithXMLData:(NSData *)data;
+ (nullable NSDictionary<NSString *, id> *)xlsxReaderDictionaryWithXMLString:(NSString *)string;
+ (nullable NSDictionary<NSString *, id> *)xlsxReaderDictionaryWithXMLFile:(NSString *)path;

@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, NSString *> *xlsxReaderAttributes;
@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, id> *xlsxReaderChildNodes;
@property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *xlsxReaderComments;
@property (nonatomic, readonly, copy, nullable) NSString *xlsxReaderNodeName;
@property (nonatomic, readonly, copy, nullable) NSString *xlsxReaderInnerText;
@property (nonatomic, readonly, copy) NSString *xlsxReaderInnerXML;
@property (nonatomic, readonly, copy) NSString *xlsxReaderXMLString;

- (nullable NSArray *)xlsxReaderArrayValueForKeyPath:(NSString *)keyPath;
- (nullable NSString *)xlsxReaderStringValueForKeyPath:(NSString *)keyPath;
- (nullable NSDictionary<NSString *, id> *)xlsxReaderDictionaryValueForKeyPath:(NSString *)keyPath;

@end


@interface NSString (XlsxReaderXMLDictionary)

@property (nonatomic, readonly, copy) NSString *xlsxReaderXMLEncodedString;

@end


NS_ASSUME_NONNULL_END


