//
//  BRAVmlDrawing.m
//  XlsxReaderWriter
//
//  Created by René BIGOT on 28/09/2015.
//  Copyright © 2015 BRAE. All rights reserved.
//

#import "BRAVmlDrawing.h"

@implementation BRAVmlDrawing

- (NSString *)targetFormat {
    return @"../drawings/vmlDrawing%ld.vml";
}

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/vmlDrawing";
}

- (void)loadXmlContents {
    [super loadXmlContents];
}

#pragma mark -

- (NSString *)xmlRepresentation {
    //Have to be nil. BRAImage is not an xml file, so BRAOpenXmlElement will save it as raw data
    return nil;
}

@end
