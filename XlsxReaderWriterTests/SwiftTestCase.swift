//
//  SwiftTestCase.swift
//  XlsxReaderWriter
//
//  Created by René BIGOT on 07/09/2015.
//  Copyright (c) 2015 BRAE. All rights reserved.
//

import UIKit
import XCTest

class SwiftTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSwiftOpenClose() {
        // This is an example of a functional test case.
        let documentPath = NSBundle(forClass: self.classForCoder).pathForResource("testWorkbook", ofType: "xlsx")
        NSLog("%@", documentPath!)
        
        let odp: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(documentPath)
        XCTAssertNotNil(odp, "Office document package should not be nil")

        XCTAssertNotNil(odp.workbook, "Office document package should contain a workbook")

        let worksheet: BRAWorksheet = odp.workbook.worksheets[0] as! BRAWorksheet;
        XCTAssertNotNil(worksheet, "Worksheet should not be nil")

        let paths: Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array
        let fullPath: String = paths[0].stringByAppendingString("/testSwiftOpenClose.xlsx")
        odp.saveAs(fullPath)
        XCTAssert(NSFileManager.defaultManager().fileExistsAtPath(fullPath), "No file exists at %@", file: fullPath)
    }

}
