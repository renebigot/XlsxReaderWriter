//
//  BRAOfficeDocumentPackage.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

@import Foundation;

#import "BRAElementWithRelationships.h"

@class BRAContentTypes, BRAOfficeDocument;

/*!
 * @brief BRADocumentPackage is the OPC package representation. OpenXml documents are OPC (Open Packaging Convention) packages which uses the ZIP archive format.
 *  Files types contained in the packages are discribed by the [Content-Types].xml file.
 *  The set of explicit relationships for a given package as a whole are stored in _rels/.rels file.
 */
@interface BRAOfficeDocumentPackage : BRAElementWithRelationships
    
    /*! @brief The content type. Files types contained in the packages are discribed by the [Content-Types].xml file. */
    @property (nonatomic, strong, readonly) BRAContentTypes   *  contentTypes;

    /*! @brief The Workbook for the XLSx file. This is your starting poing */
    @property (nonatomic, strong, readonly) BRAOfficeDocument *  workbook;
    
    /*! @brief The cache Directory use by the package */
    @property (nonatomic, strong, readonly) NSString          *  cacheDirectory;
    
    /*!
     * @brief Initialize a spreadsheet document from a file and read its .rels file
     * @param filePath The file path.
     * @return BRAOfficeDocumentPackage
     */
- (instancetype)initWithContentsOfFile:(NSString *)filePath NS_DESIGNATED_INITIALIZER;
  
    /*!
     * @brief Opens an OPC package and unzip it, read its [Content-Types] and _rels/.rels files.
     * @param filePath Path to the OPC package file to read.
     * @return BRAOfficeDocumentPackage
     */
+ (instancetype)open:(NSString *)filePath;

    /*!
     * @brief Saves an OPC package : update [Content-Types] and zip all datas to it's known file path.
     */
- (void)save;

    /*!
     * @brief Saves an OPC package : update [Content-Types] and zip all datas to filePath.
     * @param filePath Destination path
     */
- (void)saveAs:(NSString *)filePath;
    
    /*!
     * @brief TODO: Creates an OPC package with a basic [Content-Types] and _rels/.rels files.
     * @warning Not Implemented.
     * @param filePath Destionation file path.
     * @return BRAOfficeDocumentPackage
     */
+ (instancetype)create:(NSString *)filePath NS_UNAVAILABLE;
    
    /*!
     * @brief Use Designated initializer
     */
- (instancetype)init NS_UNAVAILABLE;
    
@end
