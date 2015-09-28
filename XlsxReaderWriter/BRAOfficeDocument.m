//
//  BRAOfficeDocument
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAOfficeDocument.h"
#import "BRARelationships.h"
#import "BRASharedStrings.h"
#import "BRAWorksheet.h"
#import "BRASheet.h"

@implementation BRAOfficeDocument

+ (NSString *)fullRelationshipType {
    return @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
}

- (NSString *)contentType {
    return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml";
}

- (NSString *)targetFormat {
    return @"xl/workbook.xml";
}

- (void)loadXmlContents {
    [super loadXmlContents];
    
   //Styles
    _styles = [self.relationships anyRelationshipWithType:[BRAStyles fullRelationshipType]];
    _styles.theme = [self.relationships anyRelationshipWithType:[BRATheme fullRelationshipType]];
    [_styles loadThemableContent];
    
    //Shared strings
    _sharedStrings = [self.relationships anyRelationshipWithType:[BRASharedStrings fullRelationshipType]];
    _sharedStrings.styles = _styles;
    
    //Calc chain
    _calcChain = [self.relationships anyRelationshipWithType:[BRACalcChain fullRelationshipType]];
    
    //Sheets
    NSMutableArray *sheets = @[].mutableCopy;
    NSDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation];
    
    for (NSDictionary *openXmlAttributes in [dictionaryRepresentation arrayValueForKeyPath:@"sheets.sheet"]) {
        [sheets addObject:[[BRASheet alloc] initWithOpenXmlAttributes:openXmlAttributes]];
    }
    
    _sheets = sheets;
}

- (BRAWorksheet *)worksheetNamed:(NSString *)worksheetName {
    for (BRASheet *sheet in _sheets) {
        if ([sheet.name isEqual:worksheetName]) {
            BRAWorksheet *worksheet = [self.relationships relationshipWithId:sheet.identifier];
            worksheet.styles = _styles;
            worksheet.sharedStrings = _sharedStrings;
            worksheet.calcChain = _calcChain;
            return worksheet;
        }
    }
    
    return nil;
}

- (BRAWorksheet *)createWorksheetNamed:(NSString *)worksheetName {
    //Create the relation (sheetX.xml file)
    NSString *relationId = [self.relationships relationshipIdForNewRelationship];
    
    BRAWorksheet *newWorksheet = [[BRAWorksheet alloc] initWithXmlRepresentation:@"<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\"><sheetData /></worksheet>"
                                                                forRelationId:relationId
                                                            inParentDirectory:[self.parentDirectory stringByAppendingPathComponent:@"xl"]];
    
    newWorksheet.styles = _styles;
    newWorksheet.sharedStrings = _sharedStrings;
    newWorksheet.calcChain = _calcChain;
    
    [self.relationships addRelationship:newWorksheet];
    
    //Create sheet (OpenXmlSubElement)
    BRASheet *newSheet = [[BRASheet alloc] initWithOpenXmlAttributes:@{
                                                                       @"_name": worksheetName,
                                                                       @"_sheetId": [self sheetIdForNewSheet],
                                                                       @"_r:id": relationId
                                                                       }];
    NSMutableArray *sheets = _sheets.mutableCopy;
    [sheets addObject:newSheet];
    _sheets = sheets;
    
    [newWorksheet setTabSelected:NO];

    return newWorksheet;
}

- (BRAWorksheet *)createWorksheetNamed:(NSString *)worksheetName byCopyingWorksheet:(BRAWorksheet *)worksheet {
    NSString *identifier = [self.relationships relationshipIdForNewRelationship];

    //Create the relation (sheetX.xml file)
    BRAWorksheet *newWorksheet = [worksheet copy];
    newWorksheet.identifier = identifier;

    newWorksheet.styles = _styles;
    newWorksheet.sharedStrings = _sharedStrings;
    newWorksheet.calcChain = _calcChain;

    [self.relationships addRelationship:newWorksheet];
    
    //Create sheet (OpenXmlSubElement)
    BRASheet *newSheet = [[BRASheet alloc] initWithOpenXmlAttributes:@{
                                                                       @"_name": worksheetName,
                                                                       @"_sheetId": [self sheetIdForNewSheet],
                                                                       @"_r:id": identifier
                                                                       }];
    NSMutableArray *sheets = _sheets.mutableCopy;
    [sheets addObject:newSheet];
    _sheets = sheets;
    
    [newWorksheet setTabSelected:NO];
    
    return newWorksheet;
}

- (void)removeWorksheetNamed:(NSString *)worksheetName {
    NSMutableArray *sheetsArray = _sheets.mutableCopy;

    for (BRASheet *sheet in _sheets) {
        if ([sheet.name isEqual:worksheetName]) {
            [self.relationships removeRelationshipWithId:sheet.identifier];
            [sheetsArray removeObject:sheet];
            break;
        }
    }

    //Delete calcChain to prevent a file error from Excel
    NSString *calcChainId = [[self.relationships anyRelationshipWithType:[BRACalcChain fullRelationshipType]] identifier];
    [self.relationships removeRelationshipWithId:calcChainId];
    
    _sheets = sheetsArray;
}

- (NSArray *)worksheets {
    NSMutableArray *worksheets = @[].mutableCopy;
    
    for (BRASheet *sheet in _sheets) {
        BRAWorksheet *worksheet = [self.relationships relationshipWithId:sheet.identifier];
        worksheet.styles = _styles;
        worksheet.sharedStrings = _sharedStrings;
        worksheet.calcChain = _calcChain;
        [worksheets addObject:worksheet];
    }
    
    return worksheets.count ? worksheets : nil;
}

#pragma mark -

- (NSString *)sheetIdForNewSheet {
    NSInteger __block newSheetId = 0;
    [_sheets enumerateObjectsUsingBlock:^(BRASheet *obj, NSUInteger idx, BOOL *stop) {
        newSheetId = MAX(newSheetId, [obj.sheetId integerValue] + 1);
    }];
    
    return [NSString stringWithFormat:@"%ld", (long)newSheetId];
}

- (NSString *)xmlRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithOpenXmlString:_xmlRepresentation].mutableCopy;
    
    NSString *xmlHeader = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n";

    NSMutableArray *sheets = _sheets.mutableCopy;
    [sheets sortedArrayUsingComparator:^NSComparisonResult(BRASheet *obj1, BRASheet *obj2) {
        return [obj1.identifier compare:obj2.identifier];
    }];
    
    NSMutableArray *sheetsArray = @[].mutableCopy;
    
    for (BRASheet *sheet in sheets) {
        [sheetsArray addObject:[sheet dictionaryRepresentation]];
    }
    
    [dictionaryRepresentation setValue:sheetsArray forKeyPath:@"sheets.sheet"];
    
    //Return xmlRepresentation
    _xmlRepresentation = [xmlHeader stringByAppendingString:[dictionaryRepresentation openXmlStringInNodeNamed:@"workbook"]];
    
    return _xmlRepresentation;
}

@end
