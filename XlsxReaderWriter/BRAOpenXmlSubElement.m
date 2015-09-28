//
//  BRAOpenXmlSubElement.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOpenXmlSubElement.h"
#import "BRAStyles.h"

@implementation BRAOpenXmlSubElement

- (instancetype)initWithOpenXmlAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _dictionaryRepresentation = attributes.mutableCopy;
        
        [self loadAttributes];
    }
    
    return self;
}

- (void)loadAttributes {
    //loadAttributes must be implemented by sub-class
    NOT_IMPLEMENTED
}

- (NSDictionary *)dictionaryRepresentation {
    return _dictionaryRepresentation;
}

#pragma mark - isEqual:

- (NSUInteger)hash {
    return [_dictionaryRepresentation hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [_dictionaryRepresentation isEqualToDictionary:[object dictionaryRepresentation]];
}

@end

@implementation BRAOpenXmlSubElementWithStyle

- (instancetype)initWithOpenXmlAttributes:(NSDictionary *)attributes inStyles:(BRAStyles *)styles {
    // Do not init super with initWithOpenXmlAttributes. We need to know _styles before loadAttributes
    if (self = [super init]) {
        self.dictionaryRepresentation = attributes.mutableCopy;
        _styles = styles;
        
        [self loadAttributes];
    }
    
    return self;
}

@end

@implementation BRAOpenXmlSubElementWithWorksheet

- (instancetype)initWithOpenXmlAttributes:(NSDictionary *)attributes inWorksheet:(BRAWorksheet *)worksheet {
    if (self = [super init]) {
        self.dictionaryRepresentation = attributes.mutableCopy;
        _worksheet = worksheet;
        
        [self loadAttributes];
    }
    
    return self;
}

@end