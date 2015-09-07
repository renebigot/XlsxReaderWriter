//
//  NSDictionary+OpenXmlString.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/09/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"

@interface NSDictionary (OpenXmlString)

- (NSString *)openXmlStringInNodeNamed:(NSString *)nodeName;

@end
