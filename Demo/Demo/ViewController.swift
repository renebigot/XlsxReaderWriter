//
//  ViewController.swift
//  Demo
//
//  Created by Denis Martin on 02/03/2018.
//  Copyright © 2018 charlymr. All rights reserved.
//

import UIKit
import XlsxReaderWriter

class ViewController: UIViewController {
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let documentPath = Bundle(for: self.classForCoder).path(forResource: "testWorkbook", ofType: "xlsx"),
              let odp =  BRAOfficeDocumentPackage(contentsOfFile: documentPath)
            
        else {
            return 
        }
        
        let worksheet: BRAWorksheet = odp.workbook.worksheets[0] as! BRAWorksheet;
        
        first.text = worksheet.cell(forCellReference:   "B6").stringValue()
        
        second.text = worksheet.cell(forCellReference:  "B7").stringValue()
        
        third.text = worksheet.cell(forCellReference:   "B4").stringValue()
        
        
    }
    
    
}

