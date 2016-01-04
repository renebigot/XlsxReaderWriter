//
//  BRAXlsxReaderWriterTests.m
//  BRAXlsxReaderWriterTests
//
//  Created by René Bigot on 27/12/13.
//  Copyright (c) 2013 René Bigot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <stdio.h>

#import "BRAOfficeDocumentPackage.h"
#import "BRAWorksheet.h"
#import "BRANumberFormat.h"
#import "BRARelationships.h"
#import "BRADrawing.h"
#import "BRAImage.h"
#import "BRAColumn.h"
#import "BRARow.h"
#import "BRACell.h"

#define NUMBER_FORMAT(X) [[BRANumberFormat alloc] initWithOpenXmlAttributes:@{@"_formatCode": X} inStyles:_spreadsheet.workbook.styles]

@interface BRAXlsxReaderWriterTests : XCTestCase {
    BRAOfficeDocumentPackage *_spreadsheet;
}

@end

@implementation BRAXlsxReaderWriterTests

+ (void)setUp {
    [super setUp];
}

- (void)setUp {
    [super setUp];

    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
}

+ (void)tearDown {
    NSLog(@"------ WORKING DIRECTORY : %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    
    [super tearDown];
}

- (void)testReadSpreadsheetDocument {
    XCTAssertNotNil(_spreadsheet, @"Spreadsheet document can't be read");
}

- (void)testWorksheet {
    XCTAssertNotNil(_spreadsheet.workbook.worksheets, @"Wokbook should have worksheet(s)");
    XCTAssertEqualObjects([_spreadsheet.workbook.worksheets[0] class], [BRAWorksheet class], @"Worksheet should be a BRAWorksheet instance");
}

- (void)testWorksheetNamed {
    XCTAssertNotNil([_spreadsheet.workbook worksheetNamed:@"Feuil1"], @"Feuil1 not found");
    XCTAssertEqualObjects([[_spreadsheet.workbook worksheetNamed:@"Feuil1"] class], [BRAWorksheet class], @"Feuil1 should be a BRAWorksheet instance");
}

- (void)testCellContentBoolean {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *defaultAttributes = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                        NSParagraphStyleAttributeName: paragraphStyle
                                        };
    
    //B1 : TRUE
    XCTAssert([[worksheet cellForCellReference:@"B1"] boolValue], @"B1 bool value should TRUE");
    XCTAssertEqual([[worksheet cellForCellReference:@"B1"] integerValue], 1, @"B1 integer value should 1");
    XCTAssertEqual([[worksheet cellForCellReference:@"B1"] floatValue], 1., @"B1 float value should 1.");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B1"] stringValue], @"TRUE", @"B1 string value should @\"TRUE\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B1"] attributedStringValue], [[NSAttributedString alloc] initWithString:@"TRUE" attributes:defaultAttributes], @"B1 attributed string value should @\"TRUE\" without attributes");
    XCTAssertNil([[worksheet cellForCellReference:@"B1"] dateValue], @"B1 date value should nil");
    
    //C1 : FALSE
    XCTAssert(![[worksheet cellForCellReference:@"C1"] boolValue], @"C1 bool value should FALSE");
    XCTAssertEqual([[worksheet cellForCellReference:@"C1"] integerValue], 0, @"C1 integer value should 0");
    XCTAssertEqual([[worksheet cellForCellReference:@"C1"] floatValue], 0., @"C1 float value should 0.");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C1"] stringValue], @"FALSE", @"C1 string value should @\"FALSE\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C1"] attributedStringValue], [[NSAttributedString alloc] initWithString:@"FALSE" attributes:defaultAttributes], @"C1 attributed string value should @\"FALSE\" without attributes");
    XCTAssertNil([[worksheet cellForCellReference:@"C1"] dateValue], @"C1 date value should nil");
}

- (void)testCellContentNumber {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *defaultAttributes = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                        NSParagraphStyleAttributeName: paragraphStyle
                                        };
    
    //B5 : 0.2
    XCTAssert([[worksheet cellForCellReference:@"B5"] boolValue], @"B5 bool value should TRUE");
    XCTAssertEqual([[worksheet cellForCellReference:@"B5"] integerValue], 0, @"B5 integer value should 0");
    XCTAssertEqual([[worksheet cellForCellReference:@"B5"] floatValue], .2f, @"B5 float value should 0.2"); //Use .2f => float precision problem if .2
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B5"] stringValue], @"0.2", @"B5 string value should @\"0.2\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B5"] attributedStringValue], [[NSAttributedString alloc] initWithString:@"0.2" attributes:defaultAttributes], @"B5 attributed string value should @\"0.2\" without attributes");
    XCTAssertNil([[worksheet cellForCellReference:@"B5"] dateValue], @"B5 date value should nil");
    
    //C5 : 0
    XCTAssert(![[worksheet cellForCellReference:@"C5"] boolValue], @"C5 bool value should FALSE");
    XCTAssertEqual([[worksheet cellForCellReference:@"C5"] integerValue], 0, @"C5 integer value should 0");
    XCTAssertEqual([[worksheet cellForCellReference:@"C5"] floatValue], 0., @"C5 float value should 0.");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C5"] stringValue], @"0", @"C5 string value should @\"0.000\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C5"] attributedStringValue], [[NSAttributedString alloc] initWithString:@"0" attributes:defaultAttributes], @"C5 attributed string value should @\"0.0\" with without attributes");
    XCTAssertNil([[worksheet cellForCellReference:@"C5"] dateValue], @"C5 date value should nil");
}

- (void)testCellContentString {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];

    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B6"] stringValue], @"shared string", @"B6 should contain @\"shared string\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C6"] stringValue], @"shared string with color", @"C6 should contain @\"shared string with color\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B4"] stringValue], @"concatenated string", @"B4 should contain @\"concatenated string\"");
}

- (void)testCellContentAttributedString {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *defaultAttributes = @{
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                        NSParagraphStyleAttributeName: paragraphStyle
                                        };

    NSMutableAttributedString *resultAttributedString = [[NSAttributedString alloc] initWithString:@"shared string" attributes:defaultAttributes].mutableCopy;

    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B6"] attributedStringValue], resultAttributedString, @"Bad content for B6");
    
    resultAttributedString = [[NSAttributedString alloc] initWithString:@"shared string with " attributes:defaultAttributes].mutableCopy;
    [resultAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"color"
                                                                                   attributes:@{
                                                                                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"FC0507"],
                                                                                                NSParagraphStyleAttributeName: paragraphStyle
                                                                                                }]];
    
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"C6"] attributedStringValue], resultAttributedString, @"Bad content for C6");
}

- (void)testCellContentDate {
    //Don't know how to force Excel to write a date object (automatic conversion to string or number)
}

- (void)testCellContentError {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    XCTAssert([[worksheet cellForCellReference:@"B2"] hasError], @"B2 should contain an error");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B2"] stringValue], @"#DIV/0!", @"B2 should have a #DIV/0! error");
}

- (void)testCellContentFormula {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    XCTAssertNotNil([[worksheet cellForCellReference:@"B4"] formulaString], @"B4 should contain a formula");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"B4"] formulaString], @"CONCATENATE(\"concatenated\",\" \",\"string\")", @"B4 does not contain the expected formula");
}

- (void)testThemeColor {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"F3"] cellFillColor], [UIColor colorWithRed:247./255. green:150./255. blue:70./255. alpha:1]);
}

- (void)testNumberFormats {
//@"# ??/??"
//@"m/d/yy"
//@"d-mmm-yy"
//@"d-mmm"
//@"mmm-yy"
//@"h:mm AM/PM"
//@"h:mm:ss AM/PM"
//@"h:mm"
//@"h:mm:ss"
//@"m/d/yy h:mm"
//@"(#,##0_);(#,##0)"
//@"(#,##0_);[Red](#,##0)"
//@"(#,##0.00_);(#,##0.00)"
//@"(#,##0.00_);[Red](#,##0.00)"
//@"_(* #,##0_);_(* (#,##0);_(* \"-\"_);_(@_)"
//@"_($* #,##0_);_($* (#,##0);_($* \"-\"_);_(@_)"
//@"_(* #,##0.00_);_(* (#,##0.00);_(* \"-\"??_);_(@_)"
//@"_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)"
//@"mm:ss"
//@"[h]:mm:ss"
//@"mm:ss.0"
//@"##0.0E+0"
//@"@"

    BRANumberFormat *numberFormat = nil;
    numberFormat = NUMBER_FORMAT(@"0.000");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.25] string], @"5.250");
    XCTAssertEqualObjects([[numberFormat formatNumber:5] string], @"5.000");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.2518] string], @"5.252");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.2512] string], @"5.251");
    
    numberFormat = NUMBER_FORMAT(@"0");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.75] string], @"6");
    XCTAssertEqualObjects([[numberFormat formatNumber:5] string], @"5");
    
    numberFormat = NUMBER_FORMAT(@"0.00");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.25] string], @"5.25");
    XCTAssertEqualObjects([[numberFormat formatNumber:5] string], @"5.00");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.258] string], @"5.26");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.252] string], @"5.25");
    
    numberFormat = NUMBER_FORMAT(@"#,##0");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.75] string], @"6");
    XCTAssertEqualObjects([[numberFormat formatNumber:5] string], @"5");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251.75] string], @"1,252");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251.15] string], @"1,251");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251] string], @"1,251");
    
    numberFormat = NUMBER_FORMAT(@"#,##0.00");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.75] string], @"5.75");
    XCTAssertEqualObjects([[numberFormat formatNumber:5] string], @"5.00");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251.75] string], @"1,251.75");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251.759] string], @"1,251.76");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251.751] string], @"1,251.75");
    XCTAssertEqualObjects([[numberFormat formatNumber:1251] string], @"1,251.00");
    XCTAssertEqualObjects([[numberFormat formatNumber:-1251] string], @"-1,251.00");
    
    numberFormat = NUMBER_FORMAT(@"_($#,##0_);($#,##0)");
    XCTAssertEqualObjects([[numberFormat formatNumber:1241.75] string], @" $1,242 ");
    XCTAssertEqualObjects([[numberFormat formatNumber:-1251] string], @"($1,251)");
    
    numberFormat = NUMBER_FORMAT(@"_($#,##0.00_);[Red]($#,##0.00)");
    XCTAssertEqualObjects([[numberFormat formatNumber:1241] string], @" $1,241.00 ");
    XCTAssertEqualObjects([[numberFormat formatNumber:-1251] string], @"($1,251.00)");
    XCTAssertEqualObjects([[numberFormat formatNumber:1241.999] string], @" $1,242.00 ");
    XCTAssertEqualObjects([[numberFormat formatNumber:-1251.001] string], @"($1,251.00)");
    XCTAssertEqualObjects([[numberFormat formatNumber:1241.999] attribute:NSForegroundColorAttributeName
                                                                  atIndex:0
                                                           effectiveRange:NULL], nil);
    XCTAssertEqualObjects([[numberFormat formatNumber:-1241.999] attribute:NSForegroundColorAttributeName
                                                                  atIndex:0
                                                           effectiveRange:NULL], [UIColor redColor]);
    
    numberFormat = NUMBER_FORMAT(@"0%");
    XCTAssertEqualObjects([[numberFormat formatNumber:.5] string], @"50%");
    XCTAssertEqualObjects([[numberFormat formatNumber:.509] string], @"51%");

    numberFormat = NUMBER_FORMAT(@"0.00%");
    XCTAssertEqualObjects([[numberFormat formatNumber:.5] string], @"50.00%");
    XCTAssertEqualObjects([[numberFormat formatNumber:.509] string], @"50.90%");

    numberFormat = NUMBER_FORMAT(@"0.00E+00");
    XCTAssertEqualObjects([[numberFormat formatNumber:12345] string], @"1.23E+04");
    XCTAssertEqualObjects([[numberFormat formatNumber:.12345] string], @"1.23E-01");
    XCTAssertEqualObjects([[numberFormat formatNumber:.000000012345] string], @"1.23E-08");

    numberFormat = NUMBER_FORMAT(@"0.00E+0");
    XCTAssertEqualObjects([[numberFormat formatNumber:12345] string], @"1.23E+4");
    XCTAssertEqualObjects([[numberFormat formatNumber:.12345] string], @"1.23E-1");
    XCTAssertEqualObjects([[numberFormat formatNumber:.000000012345] string], @"1.23E-8");
    
    numberFormat = NUMBER_FORMAT(@"# ?/?;(# ?/?)");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.25] string], @"5 1/4");
    XCTAssertEqualObjects([[numberFormat formatNumber:-5.25] string], @"(5 1/4)");
    XCTAssertEqualObjects([[numberFormat formatNumber:.25] string], @"1/4");
    XCTAssertEqualObjects([[numberFormat formatNumber:-.25] string], @"(1/4)");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.5] string], @"5 1/2");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.3] string], @"5 2/7");
    XCTAssertEqualObjects([[numberFormat formatNumber:5.66] string], @"5 2/3");
    XCTAssertEqualObjects([[numberFormat formatNumber:125./97.] string], @"1 2/7");
    XCTAssertEqualObjects([[numberFormat formatNumber:8.123456789] string], @"8 1/8");

    numberFormat = NUMBER_FORMAT(@"# ??/??");
//    XCTAssertEqualObjects([[numberFormat formatNumber:5.25] string], @"5 1/4");
//    XCTAssertEqualObjects([[numberFormat formatNumber:.25] string], @"1/4");
//    XCTAssertEqualObjects([[numberFormat formatNumber:5.5] string], @"5 1/2");
//    XCTAssertEqualObjects([[numberFormat formatNumber:5.3] string], @"5 3/10");
//    XCTAssertEqualObjects([[numberFormat formatNumber:5.66] string], @"5 2/3");
//    XCTAssertEqualObjects([[numberFormat formatNumber:125./97.] string], @"1 28/97");
//    XCTAssertEqualObjects([[numberFormat formatNumber:8.123456789] string], @"8 1/8");
}

- (void)testDrawing {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];

    BRADrawing *drawing = [worksheet.relationships anyRelationshipWithType:[BRADrawing fullRelationshipType]];
    XCTAssertEqual(drawing.worksheetDrawings.count, 2, @"This worksheet should contain 2 drawings");
    
    BRAWorksheetDrawing *worksheetDrawing = drawing.worksheetDrawings[0];
    XCTAssert(worksheetDrawing.shouldKeepAspectRatio, @"This image should have the keep aspect ration propertie On");
    XCTAssertEqualObjects(worksheetDrawing.identifier, @"rId1", @"This image should be rId1");
    XCTAssertEqualObjects(worksheetDrawing.name, @"Image 1", @"This image should be named @\"Image 1\"");
    NSLog(@"%@", ((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference);
    XCTAssertEqualObjects(((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellReference, @"G8", @"Top-Left should be G8");
    XCTAssertEqualObjects(((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellReference, @"H14", @"Right-bottom should be H14");
    XCTAssert(CGPointEqualToPoint(((BRAOneCellAnchor *)worksheetDrawing.anchor).topLeftCellOffset, CGPointMake(368300, 139700)), @"First cell offset should be {368300, 139700}");
    XCTAssert(CGPointEqualToPoint(((BRATwoCellAnchor *)worksheetDrawing.anchor).bottomRightCellOffset, CGPointMake(685800, 139700)), @"First cell offset should be {685800, 139700}");
}

- (void)testImage {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    BRADrawing *drawing = [worksheet.relationships anyRelationshipWithType:[BRADrawing fullRelationshipType]];
    BRAImage *image = [drawing.relationships relationshipWithId:@"rId1"];
    XCTAssertNotNil(image, @"Image with relation rId1 should exist for this drawing");
    XCTAssert(CGSizeEqualToSize(image.uiImage.size, CGSizeMake(90., 90.)), @"Image rId1 should have a size of {90, 90}");
    
    XCTAssertEqualObjects(image, [worksheet imageForCellReference:@"G8"], @"rId1 should be the same image as image in G8");
}

- (void)testSaveAs {
    [self measureBlock:^{
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testSaveAs.xlsx"];
        [_spreadsheet saveAs:fullPath];
        XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:fullPath], @"No file exists at %@", fullPath);
    }];
}

- (void)testAdd1Row {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        NSInteger rowsCount = worksheet.rows.count;
        [worksheet addRowAt:18];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count - 1, @"Worksheet should contain 1 more row");
        XCTAssertEqualObjects([[worksheet cellForCellReference:@"D18"] stringValue], @"", @"D18 should be empty");
        XCTAssertEqual([[worksheet cellForCellReference:@"D19"] integerValue], 18, @"D19 should be contain 18 (D18 old value)");
        XCTAssertEqual([[worksheet cellForCellReference:@"D20"] integerValue], 19, @"D20 should be contain 19 (D19 old value)");
    }];
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAdd1Row.xlsx"]];
}

- (void)testAdd1000Rows {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        NSInteger rowsCount = worksheet.rows.count;
        [worksheet addRowsAt:18 count:1000];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count - 1000, @"Worksheet should contain 1000 more rows");
        XCTAssertEqualObjects([[worksheet cellForCellReference:@"D18"] stringValue], @"", @"D18 should be empty");
        XCTAssertEqual([[worksheet cellForCellReference:@"D1018"] integerValue], 18, @"D1018 should be contain 18 (D18 old value)");
        XCTAssertEqual([[worksheet cellForCellReference:@"D1019"] integerValue], 19, @"D1019 should be contain 19 (D19 old value)");
    }];

    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAdd1000Rows.xlsx"]];
}

- (void)testRemove1Row {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        BRACell *firstCell = [worksheet cellForCellReference:@"A17"];
        NSInteger rowsCount = worksheet.rows.count;
        
        [worksheet removeRow:18];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count + 1, @"Worksheet should contain 1 less row");
        XCTAssertEqualObjects(firstCell, [worksheet cellForCellReference:@"A17"], @"The new A17 should have the same content as the old one");
    }];
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemove1Row.xlsx"]];
}

- (void)testRemove1RowAndKeepMergeCellContent {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        BRACell *firstCell = [worksheet cellForCellReference:@"A17"];
        NSInteger rowsCount = worksheet.rows.count;
        
        [worksheet removeRow:16];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count + 1, @"Worksheet should contain 1 less row");
        XCTAssertEqualObjects(firstCell, [worksheet cellForCellReference:@"A16"], @"The new A16 should have the same content as the old A17");
    }];
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemove1RowAndKeepMergeCellContent.xlsx"]];
}

- (void)testRemove1RowAboveAMergedCellAndKeepMergeCellContent {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        NSInteger rowsCount = worksheet.rows.count;
        
        [worksheet removeRow:16];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count + 1, @"Worksheet should contain 1 less row");
        XCTAssertEqualObjects([[worksheet cellForCellReference:@"A16"] stringValue], @"Merged cell 2", @"The new A16 should contain \"Grouped cell\"");
    }];
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemove1RowAboveAMergedCellAndKeepMergeCellContent.xlsx"]];
}

- (void)testRemove4Rows {
    NSString *documentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testWorkbook" ofType:@"xlsx"];
    
    [self measureBlock:^{
        _spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
        
        BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
        
        BRACell *firstCell = [worksheet cellForCellReference:@"A17"];
        NSInteger rowsCount = worksheet.rows.count;
        [worksheet removeRow:16 count:4];
        
        XCTAssertEqual(rowsCount, worksheet.rows.count + 4, @"Worksheet should contain 4 less rows");
        XCTAssertEqualObjects([firstCell value], [[worksheet cellForCellReference:@"A16"] value], @"The new A16 should have the same content as the old A17");
    }];
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemove4Rows.xlsx"]];
}

- (void)testWriteCellContent {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *stringAttributes = @{
                                       NSParagraphStyleAttributeName: paragraphStyle,
                                       NSForegroundColorAttributeName: [UIColor greenColor]
                                       };
    
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testWriteCellContent.xlsx"];
    
    //Write some values
    [[worksheet cellForCellReference:@"Y21" shouldCreate:YES] setBoolValue:YES];
    [[worksheet cellForCellReference:@"Z21" shouldCreate:YES] setBoolValue:NO];
    
    [[worksheet cellForCellReference:@"Y22" shouldCreate:YES] setIntegerValue:15];
    [[worksheet cellForCellReference:@"Z22" shouldCreate:YES] setIntegerValue:12.3];
    
    [[worksheet cellForCellReference:@"Y23" shouldCreate:YES] setFloatValue:15];
    [[worksheet cellForCellReference:@"Z23" shouldCreate:YES] setFloatValue:12.3];
    
    [[worksheet cellForCellReference:@"Y24" shouldCreate:YES] setStringValue:@"FOO / BAR"];
    [[worksheet cellForCellReference:@"Z24" shouldCreate:YES]
     setAttributedStringValue:[[NSAttributedString alloc] initWithString:@"GREEN" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    [[worksheet cellForCellReference:@"Y25" shouldCreate:YES] setDateValue:[df dateFromString:@"10/07/1982"]];
    [[worksheet cellForCellReference:@"Y25"] setNumberFormat:@"m/d/yyyy"];
    [[worksheet cellForCellReference:@"Y26" shouldCreate:YES] setFormulaString:@"TODAY()"];
    [[worksheet cellForCellReference:@"Y26"] setNumberFormat:@"mm/dd/yy"];

    [[worksheet cellForCellReference:@"Y27" shouldCreate:YES] setFormulaString:@"1/0"];
    [[worksheet cellForCellReference:@"Y27" shouldCreate:YES] setError:@"#DIV/0!"];

    
    //Try to read those values
    XCTAssertEqual([[worksheet cellForCellReference:@"Y21"] boolValue], YES, @"Y21 should be TRUE");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z21"] boolValue], NO, @"Z21 should be FALSE");

    XCTAssertEqual([[worksheet cellForCellReference:@"Y22"] integerValue], 15, @"Y22 should be 15");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z22"] integerValue], 12, @"Z22 should be 12");

    XCTAssertEqual([[worksheet cellForCellReference:@"Y23"] floatValue], 15.f, @"Y23 should be 15.");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z23"] floatValue], 12.3f, @"Z23 should be 12.3");

    XCTAssertEqualObjects([[worksheet cellForCellReference:@"Y24"] stringValue], @"FOO / BAR", @"Y24 should be \"FOO / BAR\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"Z24"] attributedStringValue],
                          [[NSAttributedString alloc] initWithString:@"GREEN" attributes:stringAttributes], @"Z24 should be \"GREEN\" with green color");
    
    [_spreadsheet saveAs:savePath];
    _spreadsheet = nil;
    
    //Reopen the saved workbook
    _spreadsheet = [BRAOfficeDocumentPackage open:savePath];
    worksheet = _spreadsheet.workbook.worksheets[0];

    //Try to read (again) the values
    XCTAssertEqual([[worksheet cellForCellReference:@"Y21"] boolValue], YES, @"Y21 should be TRUE");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z21"] boolValue], NO, @"Z21 should be FALSE");
    
    XCTAssertEqual([[worksheet cellForCellReference:@"Y22"] integerValue], 15, @"Y22 should be 15");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z22"] integerValue], 12, @"Z22 should be 12");
    
    XCTAssertEqual([[worksheet cellForCellReference:@"Y23"] floatValue], 15.f, @"Y23 should be 15.");
    XCTAssertEqual([[worksheet cellForCellReference:@"Z23"] floatValue], 12.3f, @"Z23 should be 12.3");
    
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"Y24"] stringValue], @"FOO / BAR", @"Y24 should be \"FOO / BAR\"");
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"Z24"] attributedStringValue],
                          [[NSAttributedString alloc] initWithString:@"GREEN" attributes:stringAttributes], @"Z24 should be \"RED is not GREEN\" with red color");
}

- (void)testColumnName {
    XCTAssertEqualObjects([BRAColumn columnNameForColumnIndex:1], @"A", @"Column name doesn't match");
    XCTAssertEqualObjects([BRAColumn columnNameForColumnIndex:26], @"Z", @"Column name doesn't match");
    XCTAssertEqualObjects([BRAColumn columnNameForColumnIndex:27], @"AA", @"Column name doesn't match");
}

- (void)testColumnIndex {
    XCTAssertEqual([BRAColumn columnIndexForCellReference:@"A1"], 1, @"Column index doesn't match");
    XCTAssertEqual([BRAColumn columnIndexForCellReference:@"Z11236"], 26, @"Column index doesn't match");
    XCTAssertEqual([BRAColumn columnIndexForCellReference:@"AA27"], 27, @"Column index doesn't match");
}

- (void)testAddFormatCode {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    NSInteger numberFormatsCount = worksheet.styles.numberFormats.count;
    
    [worksheet.styles addNumberFormat:NUMBER_FORMAT(@"yyyy/mm")];
    XCTAssertEqual(numberFormatsCount, worksheet.styles.numberFormats.count - 1, @"We should have 1 more format");
}

- (void)testColumnPointWidth {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];

    BRAColumn *col = worksheet.columns[0];
    col.width = 3;
    
    XCTAssertEqual([col pointWidth], 26, @"Col pointWidth should be 26px");
    
    col = worksheet.columns[1];
    col.pointWidth = 61;
    XCTAssertEqual([col width], 8, @"Col width should be 8 characters");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testColumnPointWidth.xlsx"]];
}

- (void)testMergeCell {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];

    XCTAssertEqualObjects([worksheet cellOrFirstCellInMergeCellForCellReference:@"C10"], [worksheet cellForCellReference:@"A9"], @"cellOrFirstCellInMergeCellForCellReference: for C10 should be A9");
    XCTAssertEqualObjects([worksheet cellOrFirstCellInMergeCellForCellReference:@"A9"], [worksheet cellForCellReference:@"A9"], @"cellOrFirstCellInMergeCellForCellReference: for A9 should be A9");
    XCTAssertEqualObjects([worksheet cellOrFirstCellInMergeCellForCellReference:@"D9"], [worksheet cellForCellReference:@"D9"], @"cellOrFirstCellInMergeCellForCellReference: for D9 should be D9");
}

- (void)testCreateNewWorksheet {
    BRAWorksheet *worksheet = [_spreadsheet.workbook createWorksheetNamed:@"Foo"];
    
    XCTAssertNotNil(worksheet, @"worksheet should not be nil");
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 2, @"Workbook should contain 2 worksheets");
    
    [[worksheet cellForCellReference:@"A10" shouldCreate:YES] setStringValue:@"Bar"];
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"A10"] stringValue], @"Bar", @"Bar not set in A10 ?");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testCreateNewWorksheet.xlsx"]];
}

- (void)testCreateNewWorksheetByCopying {
    BRAWorksheet *worksheetToCopy = _spreadsheet.workbook.worksheets[0];
    BRAWorksheet *worksheet = [_spreadsheet.workbook createWorksheetNamed:@"Foo" byCopyingWorksheet:worksheetToCopy];
    
    XCTAssertNotNil(worksheet, @"worksheet should not be nil");
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 2, @"Workbook should contain 2 worksheets");
    
    [[worksheet cellForCellReference:@"A10" shouldCreate:YES] setStringValue:@"Bar"];
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"A10"] stringValue], @"Bar", @"Bar not set in A10 ?");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testCreateNewWorksheetByCopying.xlsx"]];
}

- (void)testRemoveWorksheet1 {
    BRAWorksheet *worksheet = [_spreadsheet.workbook createWorksheetNamed:@"Foo"];
    
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 2, @"Workbook should contain 2 worksheets");
    
    [[worksheet cellForCellReference:@"A10" shouldCreate:YES] setStringValue:@"Bar"];
    XCTAssertEqualObjects([[worksheet cellForCellReference:@"A10"] stringValue], @"Bar", @"Bar not set in A10 ?");
    
    XCTAssertNotNil([_spreadsheet.workbook worksheetNamed:@"Feuil1"], @"Workbook should have a worksheet named Feuil1");
    
    [_spreadsheet.workbook removeWorksheetNamed:@"Feuil1"];
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 1, @"Workbook should contain 1 worksheet");
    
    XCTAssertNil([_spreadsheet.workbook worksheetNamed:@"Feuil1"], @"Workbook doesn't have a worksheet named Feuil1 anymore");
    XCTAssertNotNil([_spreadsheet.workbook worksheetNamed:@"Foo"], @"Workbook should still have a worksheet named Foo");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemoveWorksheet1.xlsx"]];
}

- (void)testRemoveWorksheet2 {
    //In this test, calcChain will be removed
    [_spreadsheet.workbook createWorksheetNamed:@"Foo"];
    
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 2, @"Workbook should contain 2 worksheets");
    
    [_spreadsheet.workbook removeWorksheetNamed:@"Foo"];
    XCTAssertEqual(_spreadsheet.workbook.worksheets.count, 1, @"Workbook should contain 1 worksheet");
    
    XCTAssertNil([_spreadsheet.workbook worksheetNamed:@"Foo"], @"Workbook doesn't have a worksheet named Feuil1 anymore");
    XCTAssertNotNil([_spreadsheet.workbook worksheetNamed:@"Feuil1"], @"Workbook should still have a worksheet named Foo");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testRemoveWorksheet2.xlsx"]];
}

- (void)testAddOneCellAnchoredImage {
    //Need to test more things. Only used to generate an XLSX file
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"photo-1415226481302-c40f24f4d45e" ofType:@"jpeg"]];

    BRAWorksheetDrawing *drawing = [worksheet addImage:image
                                      inCellReferenced:@"G2"
                                            withOffset:CGPointZero
                                                  size:CGSizeMake(400. * 12700, 300 * 12700)
                                  preserveTransparency:NO];
    
    XCTAssertNotNil(drawing, @"No drawing created");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAddOnceCellAnchoredImage.xlsx"]];
}

- (void)testAddTwoCellAnchoredImage {
    //Need to test more things. Only used to generate an XLSX file
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"photo-1415226481302-c40f24f4d45e" ofType:@"jpeg"]];
    BRAWorksheetDrawing *drawing = [worksheet addImage:image betweenCellsReferenced:@"G2" and:@"I10"
                                            withInsets:UIEdgeInsetsZero preserveTransparency:NO];
    
    drawing.insets = UIEdgeInsetsMake(0., 0., .5, .5);
    
    XCTAssertNotNil(drawing, @"No drawing created");
    
    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAddTwoCellAnchoredImage.xlsx"];
    [_spreadsheet saveAs:savePath];
}

- (void)testAddAbsoluteAnchoredImage {
    //Need to test more things. Only used to generate an XLSX file
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"photo-1415226481302-c40f24f4d45e" ofType:@"jpeg"]];
    BRAWorksheetDrawing *drawing = [worksheet addImage:image inFrame:CGRectMake(10. * 12700., 10. * 12700., 1024. * 12700., 768. * 12700.)
                                  preserveTransparency:NO];
    
    XCTAssertNotNil(drawing, @"No drawing created");
    
    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAddAbsoluteAnchoredImage.xlsx"]];
}

- (void)testFillColor {
    BRAWorksheet *worksheet = _spreadsheet.workbook.worksheets[0];

    XCTAssertEqualObjects([[worksheet cellForCellReference:@"A35"] cellFillColor], [UIColor redColor], @"A35 fill should be plain red");
    
    [[worksheet cellForCellReference:@"A36" shouldCreate:YES] setCellFillWithForegroundColor:[UIColor yellowColor] backgroundColor:[UIColor blackColor] andPatternType:kBRACellFillPatternTypeDarkTrellis];

    [_spreadsheet saveAs:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testFillColor.xlsx"]];
}

@end
