//
//  BRASheet.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 05/11/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRASheet.h"

@implementation BRASheet

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    
    _name = dictionaryRepresentation[@"_name"];
    _identifier = dictionaryRepresentation[@"_r:id"];
    _sheetId = dictionaryRepresentation[@"_sheetId"];
    _state = dictionaryRepresentation[@"_state"];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableCopy;
    
    dictionaryRepresentation[@"_name"] = _name;
    dictionaryRepresentation[@"_r:id"] = _identifier;
    dictionaryRepresentation[@"_sheetId"] = _sheetId;
    
    if (_state != nil) {
        dictionaryRepresentation[@"_state"] = _state;
    }
    
    [super setDictionaryRepresentation:dictionaryRepresentation];
    
    return dictionaryRepresentation;
}

@end
