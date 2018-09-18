//
//  BRAOpenXmlElement.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;

#define NOT_IMPLEMENTED NSAssert2(NO, @"%s is not implemented in %@", __PRETTY_FUNCTION__, [super class]);

@interface BRAOpenXmlElement : NSObject {
    NSString *_xmlRepresentation;
    NSData *_dataRepresentation;
}

@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSString *parentDirectory;
@property (nonatomic, strong) NSString *xmlRepresentation;
@property (nonatomic, strong) NSData *dataRepresentation;

- (instancetype)initWithContentsOfTarget:(NSString *)target inParentDirectory:(NSString *)parentDirectory;
- (instancetype)initWithTarget:(NSString *)target inParentDirectory:(NSString *)parentDirectory;
- (void)loadXmlContents;
- (void)save;

@end
