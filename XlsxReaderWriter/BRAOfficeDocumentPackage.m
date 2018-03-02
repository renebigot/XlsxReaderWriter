//
//  BRAOfficeDocumentPackage.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOfficeDocumentPackage.h"
#import "BRAOfficeDocument.h"
#import "BRARelationships.h"
#import "BRAContentTypes.h"
#import "BRAWorksheet.h"
#import "BRARow.h"
#import "BRAColumn.h"
#import "BRACell.h"

#if COCOAPODS
@import SSZipArchive;
#else
@import ZipArchive;
#endif

@interface BRAOfficeDocumentPackage ()
    @property (nonatomic, strong) BRAContentTypes   *  contentTypes;
    @property (nonatomic, strong) BRAOfficeDocument *  workbook;
    @property (nonatomic, strong) NSString          *  cacheDirectory;
@end

@implementation BRAOfficeDocumentPackage


+ (instancetype)open:(NSString *)filePath {
    BRAOfficeDocumentPackage *document = [[self alloc] initWithContentsOfFile:filePath];
    return document;
}

+ (instancetype)create:(NSString *)filePath {
// TODO : Not Implemented
    NOT_IMPLEMENTED
    return nil;
}
    
- (instancetype)initWithContentsOfFile:(NSString *)filePath {
    //BRAOfficeDocumentPackage is a special BRAElementWithRelationships.
    //We can't use initWithContentsOfFile since we have to unpack the OPC Package.
    if (self = [super init]) {
        self.target = filePath;
        
        //Unpack the OPC package
        NSString *subCacheDirectory = [@"fr.brae.spreadsheetdocument" stringByAppendingPathComponent:[filePath lastPathComponent]];
        self.cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:subCacheDirectory];
        [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        [SSZipArchive unzipFileAtPath:filePath toDestination:self.cacheDirectory];
        
        
        //Read [Content-Types]
        self.contentTypes = [[BRAContentTypes alloc] initWithContentsOfTarget:[self contentTypesFilePath] inParentDirectory:self.cacheDirectory];
        
        //Read _rels/.rels
        self.relationships = [[BRARelationships alloc] initWithContentsOfTarget:[self relationshipsTarget] inParentDirectory:self.cacheDirectory];
        
        
        //Done reading, clear cache
        [self deleteCacheDirectory];
    }
    
    return self;
}
    
- (void)save {
    [self deleteCacheDirectory];
    
    //Save [Content_Types]
    if (!self.contentTypes) {
        self.contentTypes = [[BRAContentTypes alloc] initWithTarget:@"[Content_Types].xml" inParentDirectory:self.cacheDirectory];
    }
    
    [self.contentTypes setParentDirectory:self.cacheDirectory];
    
    [self.relationships setParentDirectory:self.cacheDirectory];
    
    NSArray *documentRelationships = [self.relationships allRelationships];
    
    for (BRARelationship *relationship in documentRelationships) {
        
        relationship.target = [relationship newTarget];
        
        NSString *fullFilePath = [[relationship.parentDirectory stringByAppendingPathComponent:relationship.target] stringByStandardizingPath];
        NSString *partName = [fullFilePath stringByReplacingOccurrencesOfString:self.cacheDirectory withString:@""];

        //create an empty file
        [[NSFileManager defaultManager] createDirectoryAtPath:[fullFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:fullFilePath contents:[[NSData alloc] init] attributes:nil];

        
        if ([[[relationship.target pathExtension] lowercaseString] isEqual:@"xml"]) {

            //xml files are overrided if they're not in the overrides
            if (![self.contentTypes hasOverrideForPart:partName]) {
                [self.contentTypes overrideContentType:[relationship contentType] forPart:partName];
            }
        } else {
            
            //other files have their "classic" content type
            if (![self.contentTypes hasContentTypeForPart:partName]) {
                [self.contentTypes addContentTypeForExtension:partName.pathExtension];
            }
        }
    }
    
    [self.contentTypes save];
    
    //Save relationships
    [self.relationships save];
    
    //Create the target directory (If it doesn't exist)
    [[NSFileManager defaultManager] createDirectoryAtPath:[self.target stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];

    //Save OPC Package
    [SSZipArchive createZipFileAtPath:self.target withContentsOfDirectory:self.cacheDirectory];
    
    [self deleteCacheDirectory];
}

- (void)saveAs:(NSString *)filePath {
    self.target = filePath;

    NSString *subCacheDirectory = [@"fr.brae.spreadsheetdocument" stringByAppendingPathComponent:[filePath lastPathComponent]];
    self.cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:subCacheDirectory];
    
    [self save];
}

- (BRAOfficeDocument *)workbook {
    return [self.relationships anyRelationshipWithType:[BRAOfficeDocument fullRelationshipType]];
}

- (void)deleteCacheDirectory {
    NSError *error = nil;
    BOOL isDirectory = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheDirectory isDirectory:&isDirectory]) {
        if (isDirectory) {
            [[NSFileManager defaultManager] removeItemAtPath:self.cacheDirectory error:&error];
        }
    }
    
    if (error) {
        NSLog(@"Error while deleting cache directory %@\nError : %@", self.cacheDirectory, error);
    }
}

#pragma mark - Helpers

- (NSString *)contentTypesFilePath {
    return @"[Content_Types].xml";
}

- (NSString *)relationshipsTarget {
    return @"_rels/.rels";
}

@end
