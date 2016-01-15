//
//  BRAImage.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAImage.h"

@implementation BRAImage

- (NSString *)targetFormat {
    return self.isJpeg ? @"../media/image%ld.jpeg" : @"../media/image%ld.png";
}

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image";
}

- (void)loadXmlContents {
    [super loadXmlContents];

    if (_dataRepresentation == nil && self.target != nil) {
        NSString *fullFilePath = [[self.parentDirectory stringByAppendingPathComponent:self.target] stringByStandardizingPath];
        _uiImage = [[BRANativeImage alloc] initWithContentsOfFile:fullFilePath];
    } else if (_dataRepresentation != nil) {
        _uiImage = [[BRANativeImage alloc] initWithData:_dataRepresentation];
    }
}

#pragma mark -

- (NSString *)xmlRepresentation {
    //Have to be nil. BRAImage is not an xml file, so BRAOpenXmlElement will save it as raw data
    return nil;
}

@end
