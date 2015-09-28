//
//  BRARelationship.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"
#import "BRARelationships.h"

@implementation BRARelationship

- (instancetype)initWithId:(NSString *)identifier type:(NSString *)relationshipType andTarget:(NSString *)relationTarget inParentDirectory:(NSString *)parentDirectory {
    if (self = [super initWithContentsOfTarget:relationTarget inParentDirectory:parentDirectory]) {
        self.identifier = identifier;
        self.type = relationshipType;
        self.target = relationTarget;
    }
    
    return self;
}

- (instancetype)initWithXmlRepresentation:(NSString *)xmlRepresentation forRelationId:(NSString *)identifier inParentDirectory:(NSString *)parentDirectory {
    Class relationshipClass = [self class];
    
    if (self = [super init]) {
        self.identifier = identifier;
        self.type = [relationshipClass fullRelationshipType];
        self.target = nil;
        self.parentDirectory = parentDirectory;
        
        self.xmlRepresentation = xmlRepresentation;
        [self loadXmlContents];
    }
    
    return self;
}

- (instancetype)initWithDataRepresentation:(NSData *)dataRepresentation forRelationId:(NSString *)identifier inParentDirectory:(NSString *)parentDirectory {
    Class relationshipClass = [self class];
    
    if (self = [super init]) {
        self.identifier = identifier;
        self.type = [relationshipClass fullRelationshipType];
        self.target = nil;
        self.parentDirectory = parentDirectory;
        
        self.dataRepresentation = dataRepresentation;
        [self loadXmlContents];
    }
    
    return self;
}

+ (NSString *)fullRelationshipType {
    //Must be implemented by sub-class
    NOT_IMPLEMENTED
    return nil;
}

- (NSString *)contentType {
    //Must be implemented by sub-class
    NOT_IMPLEMENTED
    return nil;
}

- (NSString *)targetFormat {
    //Must be implemented by sub-class
    NOT_IMPLEMENTED
    return nil;
}

- (NSString *)newTarget {
    if (self.class == [BRARelationship class]) {
        return self.target;
    }
    
    NSInteger targetId = 1;
    NSString *newTarget = nil;
    
    do {
        NSString *tmpTarget = [NSString stringWithFormat:[self targetFormat], (long)targetId];
        NSString *fullTarget = [[self.parentDirectory stringByAppendingPathComponent:tmpTarget] stringByStandardizingPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:fullTarget isDirectory:NULL]) {
            newTarget = tmpTarget;
        }
        
        ++targetId;
    } while (newTarget == nil);
    
    return newTarget;
}

- (void)setParentDirectory:(NSString *)parentDirectory {
    [super setParentDirectory:parentDirectory];
        
    NSString *target = self.target;
    if (target == nil) {
        target = [self targetFormat];
    }
    
    parentDirectory = [parentDirectory stringByAppendingPathComponent:[target stringByDeletingLastPathComponent]];
    
    [self.relationships setParentDirectory:parentDirectory];
}

- (instancetype)copy {
    Class relationshipClass = [self class];
    BRARelationship *newRelationship = [[relationshipClass alloc] init];
    
    newRelationship.xmlRepresentation = self.xmlRepresentation;
    newRelationship.dataRepresentation = self.dataRepresentation;
    newRelationship.type = self.type;
    newRelationship.target = nil;
    newRelationship.identifier = self.identifier;
    newRelationship.relationships = [self.relationships copy];
    
    [newRelationship loadXmlContents];
        
    return newRelationship;
}

@end
