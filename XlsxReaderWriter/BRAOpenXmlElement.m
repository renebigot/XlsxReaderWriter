//
//  BRAOpenXmlElement.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOpenXmlElement.h"
#import "BRAOfficeDocumentPackage.h"

@implementation BRAOpenXmlElement

- (instancetype)initWithContentsOfTarget:(NSString *)target inParentDirectory:(NSString *)parentDirectory {
    if (target == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        NSError *error = nil;
        
        _parentDirectory = parentDirectory;
        _target = target;
        
        NSString *fullFilePath = [[self.parentDirectory stringByAppendingPathComponent:self.target] stringByStandardizingPath];
        
        if ([[_target pathExtension] isEqual:@"xml"] || [[_target pathExtension] isEqual:@"rels"] || [[_target lastPathComponent] isEqual:@".rels"]) {
            _xmlRepresentation = [NSString stringWithContentsOfFile:fullFilePath encoding:NSUTF8StringEncoding error:&error];
            
            if (error) {
                NSLog(@"Error while loading content of file %@.\n\n%@", [self.target lastPathComponent], error);
            }
        } else {
            _dataRepresentation = [NSData dataWithContentsOfFile:fullFilePath];
        }
        
        [self loadXmlContents];
    }
    
    return self;
}

- (instancetype)initWithTarget:(NSString *)target inParentDirectory:(NSString *)parentDirectory {
    if (self = [super init]) {
        _parentDirectory = parentDirectory;
        _target = target;
    }
    
    return self;
}

- (void)loadXmlContents {
    //Do nothing for unknown element type.
    //Must be implemented by subclasses.
}

- (void)save {
    NSError *error = nil;
    
    NSLog(@"Saving target : %@", self.target);
    
    
    BOOL isDirectory = NO;
    NSString *fullFilePath = [[self.parentDirectory stringByAppendingPathComponent:self.target] stringByStandardizingPath];
    NSString *directoryPath = [fullFilePath stringByDeletingLastPathComponent];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];

    if (![defaultManager fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        if (!isDirectory) {
            [defaultManager createDirectoryAtPath:directoryPath
                      withIntermediateDirectories:YES
                                       attributes:0
                                            error:&error];
            
            if (error) {
                NSLog(@"Error while creating directory at %@\nError : %@", directoryPath, error);
                error = nil;
            }
        }
    }
    
    if ([self xmlRepresentation]) {
        [[self xmlRepresentation] writeToFile:fullFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    } else {
        [_dataRepresentation writeToFile:fullFilePath options:0 error:&error];
    }
    
    
    if (error) {
        NSLog(@"Error while writing XML representation of %@\n\nError : %@", [self.target lastPathComponent], error);
    }
}

#pragma mark - Getters

- (void)setXmlRepresentation:(NSString *)xmlRepresentation {
    _xmlRepresentation = xmlRepresentation;
}

- (NSString *)xmlRepresentation {
    if ([self class] != [BRAOpenXmlElement class] && [self class] != [BRARelationship class]) {
        NOT_IMPLEMENTED
    }
    
    return _xmlRepresentation;
}

#pragma mark - Setters

- (void)setParentDirectory:(NSString *)parentDirectory {
    _parentDirectory = parentDirectory;
}

#pragma mark - NSObject

- (NSUInteger)hash {
    return _xmlRepresentation.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [[self xmlRepresentation] isEqual:[object xmlRepresentation]];
}

@end
