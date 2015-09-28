//
//  BRAComments.m
//  XlsxReaderWriter
//
//  Created by René BIGOT on 23/09/2015.
//  Copyright © 2015 BRAE. All rights reserved.
//

#import "BRARelationship.h"
#import "BRARelationships.h"
#import "BRARelatedToColumnAndRowProtocol.h"
#import "BRAComment.h"

/** This class does not change the comments content.
 * It just handles rows and columns deletions / additions */

@interface BRAComments : BRARelationship <BRARelatedToColumnAndRowProtocol>

@property (nonatomic, strong) NSArray *comments;

@end
