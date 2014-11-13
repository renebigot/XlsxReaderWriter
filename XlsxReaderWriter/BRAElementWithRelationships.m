//
//  BRAElementWithRelationships.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAElementWithRelationships.h"
#import "BRARelationships.h"
#import "BRAOfficeDocumentPackage.h"

/*!
 * @discussion Abstract class for every files that can have a .rels file
 */
@implementation BRAElementWithRelationships

- (void)loadXmlContents {
    NSString *parentDirectoryForRelationships = [self.parentDirectory stringByAppendingPathComponent:[self.target stringByDeletingLastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self fullRelationshipsTarget] isDirectory:NULL]) {
        self.relationships = [[BRARelationships alloc] initWithContentsOfTarget:[self relationshipsTarget] inParentDirectory:parentDirectoryForRelationships];
    }
}

/*!
 * @brief Saves an element to it's known file path.
 */
- (void)save {
    self.relationships.target = self.relationshipsTarget;
    self.relationships.parentDirectory = [[[self.parentDirectory stringByAppendingPathComponent:self.target] stringByStandardizingPath] stringByDeletingLastPathComponent];
    [self.relationships save];
    
    [super save];
}

- (NSString *)fullRelationshipsTarget {
    NSString *fileName = [self.target lastPathComponent];
    NSString *fileDirectory = [self.target stringByDeletingLastPathComponent];
    
    NSString *path = [NSString stringWithFormat:@"_rels/%@.rels", fileName];
    return [self.parentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", fileDirectory, path]];
}

- (NSString *)relationshipsTarget {
    NSString *fileName = [self.target lastPathComponent];
    NSString *path = [NSString stringWithFormat:@"_rels/%@.rels", fileName];
    
    //Do not include fileDirectory
    return path;
}

@end
