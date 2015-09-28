//
//  BRARelationships.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 04/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationships.h"
#import "BRAContentTypesDefaultExtension.h"
#import "BRAContentTypesOverride.h"
#import "BRADrawing.h"

@implementation BRARelationships

- (void)loadXmlContents {
    [super loadXmlContents];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];
    
    _relationshipsArray = @[].mutableCopy;
    
    NSArray *relationshipArray = [attributes arrayValueForKeyPath:@"Relationship"];
    
    for (NSDictionary *attributesDict in relationshipArray) {
        [self createRelationshipWithAttributes:attributesDict];
    }   
}

- (Class)relationshipClassForOpenXmlRelationshipType:(NSString *)relationshipType {
    //If the class is implemented, it should be named BRA<Type> where <Type> is the capitalized last path component of the type
    //Example 1 : http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet => BRAWorksheet
    //Example 2 : http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument => BRAOfficeDocument
    //Example 3 : http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties => BRACoreProperties
    
    NSMutableString *className = @"BRA".mutableCopy;
    NSArray *nameComponents = [[relationshipType lastPathComponent] componentsSeparatedByString:@"-"];
    
    for (NSString *nameComponent in nameComponents) {
        [className appendString:[nameComponent stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[nameComponent substringToIndex:1] uppercaseString]]];
    }
    
    Class relationshipClass = NSClassFromString(className);
    
    if (relationshipClass == nil) {
        relationshipClass = [BRARelationship class];
    }

    return relationshipClass;
}

- (void)createRelationshipWithAttributes:(NSDictionary *)attributes {
    Class relationshipClass = [self relationshipClassForOpenXmlRelationshipType:attributes[@"_Type"]];
    
    [_relationshipsArray addObject:[[relationshipClass alloc] initWithId:attributes[@"_Id"]
                                                                    type:attributes[@"_Type"]
                                                               andTarget:attributes[@"_Target"]
                                                       inParentDirectory:self.parentDirectory]];
}

- (void)setParentDirectory:(NSString *)parentDirectory {
    [super setParentDirectory:parentDirectory];
    
    parentDirectory = [[parentDirectory stringByReplacingOccurrencesOfString:@"_rels" withString:@""] stringByStandardizingPath];

    for (BRARelationship *relationship in _relationshipsArray) {
        NSString *target = self.target;
        
        if (target == nil) {
            //we need a last path component
            target = @".rels";
        }
        
        parentDirectory = [[[[parentDirectory stringByAppendingPathComponent:target] stringByStandardizingPath]
                            stringByReplacingOccurrencesOfString:@"_rels" withString:@""] stringByDeletingLastPathComponent];
        
        [relationship setParentDirectory:parentDirectory];
    }
}

- (id)relationshipWithId:(NSString *)rId {
    for (BRARelationship *relationship in _relationshipsArray) {
        if ([relationship.identifier isEqual:rId]) {
            return relationship;
        }
    }
    
    return nil;
}

- (id)anyRelationshipWithType:(NSString *)relationshipType {
    for (BRARelationship *relationship in _relationshipsArray) {
        if ([relationship.type isEqual:relationshipType]) {
            return relationship;
        }
    }
    
    return nil;
}

- (void)addRelationship:(BRARelationship *)relationship {
    if ([relationship isKindOfClass:[BRAElementWithRelationships class]]) {
        
        NSMutableArray *subRelationshipsTargets = @[].mutableCopy;
        
        [[self allRelationships] enumerateObjectsUsingBlock:^(BRARelationship *obj, NSUInteger idx, BOOL *stop) {
            if (obj.target != nil) {
                [subRelationshipsTargets addObject:obj.target];
            }
        }];
        
        for (BRARelationship *rel in relationship.relationships.relationshipsArray) {
            if ([subRelationshipsTargets containsObject:rel.target]) {
                NSInteger targetIndex = 1;
                NSString *relExtension = [rel.target pathExtension];
                NSString *relPrefix = [[rel.target stringByDeletingPathExtension] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
                
                while (YES) {
                    NSString *tmpTarget = [NSString stringWithFormat:@"%@%ld.%@", relPrefix, (long)targetIndex, relExtension];
                    
                    if (![subRelationshipsTargets containsObject:tmpTarget]) {
                        rel.target = tmpTarget;
                        break;
                    }
                    
                    ++targetIndex;
                }
            }
        }
    }
    
    [_relationshipsArray addObject:relationship];
}

- (void)removeRelationshipWithId:(NSString *)identifier {
    NSInteger indexOfRelationshipToRemove = [_relationshipsArray indexOfObjectPassingTest:^BOOL(BRARelationship *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.identifier isEqual:identifier]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (indexOfRelationshipToRemove != NSNotFound) {
        [_relationshipsArray removeObjectAtIndex:indexOfRelationshipToRemove];
    }
}

- (NSString *)relationshipIdForNewRelationship {
    NSInteger relationshipIndex = 1;
    NSString *relationshipId = nil;
    
    do {
        NSString *tmpRelId = [NSString stringWithFormat:@"rId%ld", (long)relationshipIndex];
        NSInteger objectIndex = [_relationshipsArray indexOfObjectPassingTest:^BOOL(BRARelationship *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.identifier isEqual:tmpRelId]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        if (objectIndex == NSNotFound) {
            relationshipId = tmpRelId;
        }
        
        ++relationshipIndex;
    } while (relationshipId == nil);
    
    return relationshipId;
}

- (NSArray *)allRelationships {
    NSMutableArray *allRelationships = @[].mutableCopy;
    
    for (BRARelationship *relationship in _relationshipsArray) {
        [allRelationships addObject:relationship];
        
        [allRelationships addObjectsFromArray:[relationship.relationships allRelationships]];
    }
    
    return allRelationships;
}

- (void)save {
    for (BRARelationship *relationship in _relationshipsArray) {
        [relationship save];
    }
    
    [super save];
}

#pragma mark -

- (instancetype)copy {
    BRARelationships *newRelationships = [[BRARelationships alloc] init];
    newRelationships.parentDirectory = self.parentDirectory;
    newRelationships.xmlRepresentation = _xmlRepresentation;
    
    newRelationships.relationshipsArray = @[].mutableCopy;
    
    for (BRARelationship *relationship in _relationshipsArray) {
        [newRelationships addRelationship:[relationship copy]];
    }
    
    return newRelationships;
}

- (NSString *)xmlRepresentation {
    NSMutableArray *relationshipsArray = @[].mutableCopy;

    for (BRARelationship *relationship in _relationshipsArray) {
        [relationshipsArray addObject:@{
                                        @"_Id": relationship.identifier,
                                        @"_Target": relationship.target,
                                        @"_Type": relationship.type
                                        }];
    }
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";
    NSString *xmlString = [@{
                             @"_xmlns": @"http://schemas.openxmlformats.org/package/2006/relationships",
                             @"Relationship": relationshipsArray
                             } openXmlStringInNodeNamed:@"Relationships"];
    
    _xmlRepresentation = [xmlHeader stringByAppendingString:xmlString];
    
    return _xmlRepresentation;
}

@end
