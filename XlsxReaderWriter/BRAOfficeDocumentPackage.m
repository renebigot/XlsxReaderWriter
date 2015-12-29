//
//  BRAOfficeDocumentPackage.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOfficeDocumentPackage.h"
#import "SSZipArchive.h"
#import "BRAContentTypes.h"
#import "BRARelationships.h"

/*!
 * @brief BRADocumentPackage is the OPC package representation. OpenXml documents are OPC (Open Packaging Convention) packages which uses the ZIP archive format.
 * @brief Files types contained in the packages are discribed by the [Content-Types].xml file.
 * @brief The set of explicit relationships for a given package as a whole are stored in _rels/.rels file.
 */
@implementation BRAOfficeDocumentPackage

/*!
 * @brief Opens an OPC package and unzip it, read its [Content-Types] and _rels/.rels files.
 * @param filePath Path to the OPC package file to read.
 * @return BRADocumentPackage
 */
+ (instancetype)open:(NSString *)filePath {
    BRAOfficeDocumentPackage *document = [[self alloc] initWithContentsOfFile:filePath];
    return document;
}

/*!
 * @brief Creates an OPC package with a basic [Content-Types] and _rels/.rels files.
 * @param filePath Destionation file path.
 * @return BRADocumentPackage
 */
+ (instancetype)create:(NSString *)filePath {
// TODO : Not Implemented
    NOT_IMPLEMENTED
    return nil;
}

/*!
 * @brief Initialize a spreadsheet document from a file and read its .rels file
 * @param filePath The file path.
 * @return BRAElementWithRelationships
 */
- (instancetype)initWithContentsOfFile:(NSString *)filePath {
    //BRAOfficeDocumentPackage is a special BRAElementWithRelationships.
    //We can't use initWithContentsOfFile since we have to unpack the OPC Package.
    if (self = [super init]) {
        self.target = filePath;
        
        //Unpack the OPC package
        NSString *subCacheDirectory = [@"fr.brae.spreadsheetdocument" stringByAppendingPathComponent:[filePath lastPathComponent]];
        self.cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:subCacheDirectory];
        
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

/*!
 * @brief Saves an OPC package : update [Content-Types] and zip all datas to it's known file path.
 */
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
    
    //Save OPC Package
    [SSZipArchive createZipFileAtPath:self.target withContentsOfDirectory:self.cacheDirectory];
    
    [self deleteCacheDirectory];
}

/*!
 * @brief Saves an OPC package : update [Content-Types] and zip all datas to filePath.
 * @param filePath Destination path
 */
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
