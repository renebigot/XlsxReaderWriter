//
//  NSDictionary+xlsXmlString.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 03/09/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "NSDictionary+OpenXmlString.h"

@implementation NSDictionary (OpenXmlString)

+ (NSDictionary *)openXmlOrderedKeys {
    static NSDictionary *_orderedKeys = nil;
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _orderedKeys = @{
                         @"workbook": @[
                                 @"xmlns", @"xmlns:r", @"fileVersion", @"fileSharing", @"workbookPr", @"workbookProtection", @"mc:AlternateContent", @"bookViews", @"sheets", @"functionGroups", @"externalReferences", @"definedNames", @"calcPr", @"oleSize", @"customWorkbookViews", @"pivotCaches", @"smartTagPr", @"smartTagTypes", @"webPublishing", @"fileRecoveryPr", @"webPublishObjects", @"extLst"
                                 ],
                         @"workbookView": @[
                                 @"xWindow", @"yWindow", @"windowWidth", @"windowHeight", @"tabRatio"
                                 ],
                         @"fileVersion": @[
                                 @"appName", @"lastEdited", @"lowestEdited", @"rupBuild"
                                 ],
                         @"workbookPr": @[
                                 @"showInkAnnotation", @"autoCompressPictures"
                                 ],
                         @"sheet": @[
                                 @"name", @"sheetId", @"state", @"r:id"
                                 ],
                         @"styleSheet": @[
                                 @"xmlns", @"xmlns:r", @"xmlns:mc", @"mc:Ignorable", @"xmlns:x14ac", @"numFmts", @"fonts", @"fills", @"borders", @"cellStyleXfs", @"cellXfs", @"cellStyles", @"dxfs", @"tableStyles", @"colors", @"extLst"
                                 ],
                         @"fonts": @[
                                 @"count", @"x14ac:knownFonts"
                                 ],
                         @"font": @[
                                 @"b", @"i", @"strike", @"condense", @"extend", @"outline", @"shadow", @"u", @"vertAlign", @"sz", @"color", @"name", @"family", @"charset", @"scheme"
                                 ],
                         @"fill": @[
                                 @"patternFill", @"gradientFill"
                                 ],
                         @"borders": @[
                                 @"start", @"end", @"left", @"right", @"top", @"bottom", @"diagonal", @"vertical", @"horizontal"
                                 ],
                         @"cellStyle": @[
                                 @"name", @"xfId", @"builtinId", @"hidden"
                                 ],
                         @"tableStyles": @[
                                 @"count", @"defaultTableStyle", @"defaultPivotStyle"
                                 ],
                         @"dxf": @[
                                 @"font", @"numFmt", @"fill", @"alignment", @"border", @"protection", @"extLst"
                                 ],
                         @"worksheet": @[
                                 @"xmlns", @"xmlns:r", @"xmlns:mc", @"mc:Ignorable", @"xmlns:x14ac", @"sheetPr", @"dimension", @"sheetViews", @"sheetFormatPr", @"cols", @"sheetData", @"sheetCalcPr", @"sheetProtection", @"protectedRanges", @"scenarios", @"autoFilter", @"sortState", @"dataConsolidate", @"customSheetViews", @"mergeCells", @"phoneticPr", @"conditionalFormatting", @"dataValidations", @"hyperlinks", @"printOptions", @"pageMargins", @"pageSetup", @"headerFooter", @"rowBreaks", @"colBreaks", @"customProperties", @"cellWatches", @"ignoredErrors", @"smartTags", @"drawing", @"legacyDrawing", @"legacyDrawingHF", @"drawingHf", @"picture", @"oleObjects", @"controls", @"webPublishItems", @"tableParts", @"extLst"
                                 ],
                         @"sst": @[
                                 @"xmlns", @"count", @"uniqueCount"
                                 ],
                         @"c": @[
                                 @"ph", @"r", @"a", @"i", @"l", @"cm", @"s", @"t", @"vm", @"f", @"v", @"is"
                                 ],
                         @"r": @[
                                 @"rPr", @"t"
                                 ],
                         @"Types": @[
                                 @"Default", @"Override"
                                 ],
                         @"Default": @[
                                 @"Extension", @"ContentType"
                                 ],
                         @"Override": @[
                                 @"PartName", @"ContentType"
                                 ],
                         @"Relationship": @[
                                 @"Id", @"Type", @"Target"
                                 ],
                         @"rPr": @[
                                 @"b", @"i", @"strike", @"condense", @"extend", @"outline", @"shadow", @"u", @"vertAlign", @"sz", @"color", @"rFont", @"family", @"charset", @"scheme"
                                 ],
                         @"border": @[
                                 @"start", @"end", @"left", @"right", @"top", @"bottom", @"diagonal", @"vertical", @"horizontal"
                                 ],
                         @"numFmt": @[
                                 @"numFmtId", @"formatCode"
                                 ],
                         @"xf": @[
                                 @"numFmtId", @"fontId", @"fillId", @"borderId", @"xfId", @"applyNumberFormat", @"applyFont", @"applyFill", @"applyBorder", @"applyAlignment", @"applyProtection", @"alignment", @"protection", @"ExtensionList"
                                 ],
                         @"col": @[
                                 @"min", @"max", @"width", @"bestFit", @"style", @"customWidth"
                                 ],
                         @"row": @[
                                 @"r", @"ht", @"customHeight", @"customFormat", @"x14ac:dyDescent", @"spans", @"thickTop", @"s"
                                 ],
                         @"alignment": @[
                                 @"horizontal", @"vertical", @"wrapText"
                                 ],
                         @"sheetView": @[
                                 @"tabSelected", @"topLeftCell", @"workbookViewId", @"showGridLines", @"defaultGridColor"
                                 ],
                         @"pageMargins": @[
                                 @"left", @"right", @"top", @"bottom", @"header", @"footer"
                                 ],
                         @"pageSetup": @[
                                 @"firstPageNumber", @"fitToHeight", @"fitToWidth", @"scale", @"useFirstPageNumber", @"paperSize", @"orientation", @"pageOrder"
                                 ],
                         @"sheetFormatPr": @[
                                 @"baseColWidth", @"defaultColWidth", @"defaultRowHeight", @"customHeight", @"outlineLevelRow", @"outlineLevelCol"
                                 ],
                         @"patternFill": @[
                                 @"fgColor", @"bgColor"
                                 ],
                         @"wdr:wsDr": @[
                                 @"TwoCellAnchor", @"OneCellAnchor", @"AbsoluteAnchor"
                                 ],
                         @"xdr:twoCellAnchor": @[
                                 @"xdr:from", @"xdr:to", @"xdr:sp", @"xdr:grpSp", @"xdr:graphicFrame", @"xdr:cxnSp", @"xdr:pic", @"xdr:contentPart", @"xdr:clientData"
                                 ],
                         @"xdr:from": @[
                                 @"xdr:col", @"xdr:colOff", @"xdr:row", @"xdr:rowOff"
                                 ],
                         @"xdr:to": @[
                                 @"xdr:col", @"xdr:colOff", @"xdr:row", @"xdr:rowOff"
                                 ],
                         @"xdr:sp": @[
                                 @"xdr:nvSpPr", @"xdr:spPr", @"xdr:style", @"xdr:txBody"
                                 ],
                         @"xdr:nvSpPr": @[
                                 @"xdr:cNvPr", @"xdr:cNvSpPr"
                                 ],
                         @"xdr:cNvPr": @[
                                 @"a:hlinkClick", @"a:extLst"
                                 ],
                         @"xdr:cNvSpPr": @[
                                 @"a:spLocks", @"a:extLst"
                                 ],
                         @"xdr:spPr": @[
                                 @"a:xfrm", @"a:custGeom", @"a:prstGeom", @"a:noFill", @"a:solidFill", @"a:gradFill", @"a:blipFill", @"a:pattFill", @"a:grpFill", @"a:ln", @"a:effectLst", @"a:effectDag", @"a:scene3d", @"a:sp3d", @"a:extLst"
                                 ],
                         @"xdr:style": @[
                                 @"a:lnRef", @"a:fillRef", @"a:effectRef", @"a:fontRef"
                                 ],
                         @"xdr:txBody": @[
                                 @"a:bodyPr", @"a:lstStyle", @"a:p"
                                 ],
                         @"xdr:grpSp": @[
                                 @"xdr:nvGrpSpPr", @"xdr:grpSpPr", @"xdr:sp", @"xdr:grpSp", @"xdr:graphicFrame", @"xdr:cxnSp", @"xdr:pic", @"xdr14:contentPart"
                                 ],
                         @"xdr:graphicFrame": @[
                                 @"xdr:nvGraphicFramePr", @"xdr:xfrm", @"a:graphic"
                                 ],
                         @"xdr:cxnSp": @[
                                 @"xdr:nvCxnSpPr", @"xdr:spPr", @"xdr:style"
                                 ],
                         @"xdr:pic": @[
                                 @"xdr:nvPicPr", @"xdr:blipFill", @"xdr:spPr", @"xdr:style"
                                 ],
                         @"xdr:contentPart": @[
                                 @"xdr14:nvContentPr", @"xdr14:nvContentPartPr", @"xdr14:nvPr", @"xdr14:xfrm", @"xdr14:extLst"
                                 ],
                         @"xdr:blipFill": @[
                                 @"a:blip", @"a:srcRect", @"a:tile", @"a:stretch"
                                 ],
                         @"xdr:oneCellAnchor": @[
                                 @"xdr:from", @"xdr:ext", @"xdr:sp", @"xdr:grpSp", @"xdr:graphicFrame", @"xdr:cxnSp", @"xdr:pic", @"xdr:contentPart", @"xdr:clientData"
                                 ],
                         @"xdr:absoluteAnchor": @[
                                 @"xdr:pos", @"xdr:ext", @"xdr:sp", @"xdr:grpSp", @"xdr:graphicFrame", @"xdr:cxnSp", @"xdr:pic", @"xdr:contentPart", @"xdr:clientData"
                                 ],
                         @"xdr:grpSpPr": @[
                                 @"a:xfrm", @"a:noFill", @"a:solidFill", @"a:gradFill", @"a:blipFill", @"a:pattFill", @"a:grpFill", @"a:effectLst", @"a:effectDag", @"a:scene3d", @"a:extLst"
                                 ],
                         @"xdr:nvCxnSpPr": @[
                                 @"xdr:cNvPr", @"xdr:cNvCxnSpPr"
                                 ],
                         @"xdr:cNvCxnSpPr": @[
                                 @"a:cxnSpLocks", @"a:stCxn", @"a:endCxn", @"a:extLst"
                                 ],
                         @"xdr:cNvGraphicFramePr": @[
                                 @"a:graphicFrameLocks", @"a:extLst"
                                 ],
                         @"xdr:nvGraphicFramePr": @[
                                 @"xdr:cNvPr", @"xdr:cNvGraphicFramePr"
                                 ],
                         @"xdr:cNvGrpSpPr": @[
                                 @"a:grpSpLocks", @"a:extLst"
                                 ],
                         @"xdr:nvGrpSpPr": @[
                                 @"xdr:cNvPr", @"xdr:cNvGrpSpPr"
                                 ],
                         @"xdr:cNvPicPr": @[
                                 @"a:picLocks", @"a:extLst"
                                 ],
                         @"xdr:nvPicPr": @[
                                 @"xdr:cNvPr", @"xdr:cNvPicPr"
                                 ],
                         @"xdr:xfrm": @[
                                 @"a:off", @"a:ext"
                                 ],
                         @"a:ext": @[
                                 @"cx", @"cy"
                                 ],
                         @"ext": @[
                                 @"uri", @"xmlns:x14"
                                 ],
                         @"x15ac:absPath": @[
                                 @"url", @"xmlns:x15ac"
                                 ],
                         @"a:ln": @[
                                 @"w", @"cap", @"a:solidFill", @"a:prstDash", @"a:miter", @"a:headEnd", @"a:tailEnd"
                                 ],
                         @"definedName": @[
                                 @"name", @"localSheetId"
                                 ],
                         @"selection": @[
                                 @"activeCell", @"sqref"
                                 ],
                         @"headerFooter": @[
                                 @"oddHeader", @"oddFooter"
                                 ]
                         };
    });
    
    return _orderedKeys;
}

- (NSString *)openXmlStringInNodeNamed:(NSString *)nodeName {
    NSString *retVal = nil;
    
    retVal = [@{nodeName: self} openXmlInnerXMLInNodeNamed:nodeName];
    
    return [retVal stringByAppendingString:@"\n"];
}

#pragma mark -

- (NSString *)openXmlInnerXMLInNodeNamed:(NSString *)nodeName {
    NSMutableArray *nodes = [NSMutableArray array];
    
    for (NSString *comment in [self comments]) {
        [nodes addObject:[NSString stringWithFormat:@"<!--%@-->", [comment XMLEncodedString]]];
    }
    
    NSDictionary *childNodes = [self childNodes];
    NSMutableArray *allKeys = [childNodes allKeys].mutableCopy;
    
    if ([NSDictionary openXmlOrderedKeys][nodeName]) {
        for (NSString *key in [NSDictionary openXmlOrderedKeys][nodeName]) {
            if (self[key]) {
                [nodes addObject:[NSDictionary openXmlStringForNode:childNodes[key] withNodeName:key]];
                [allKeys removeObject:key];
            }
        }
    }
    
    for (NSString *key in allKeys) {
        [nodes addObject:[NSDictionary openXmlStringForNode:childNodes[key] withNodeName:key]];
    }
    
    NSString *text = [self openXmlInnerText];
    if (text) {
        [nodes addObject:[text XMLEncodedString]];
    }
    
    return [nodes componentsJoinedByString:@""];
}

- (id)openXmlInnerText {
    id text = self[XMLDictionaryTextKey];
    if ([text isKindOfClass:[NSArray class]]) {
        return [text componentsJoinedByString:@"\r\n"];
    } else {
        return text;
    }
}

+ (NSString *)openXmlStringForNode:(NSDictionary *)node withNodeName:(NSString *)nodeName {
    if ([node isKindOfClass:[NSArray class]]) {
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[node count]];
        
        for (id individualNode in node) {
            [nodes addObject:[self openXmlStringForNode:individualNode withNodeName:nodeName]];
        }
        
        return [nodes componentsJoinedByString:@""];
        
        
    } else if ([node isKindOfClass:[NSDictionary class]]) {
        NSDictionary *attributes = [(NSDictionary *)node attributes];
        NSMutableString *attributeString = [NSMutableString string];
        
        NSMutableArray *allKeys = [attributes allKeys].mutableCopy;
        
        //known attributes key
        if ([NSDictionary openXmlOrderedKeys][nodeName]) {
            for (NSString *key in [NSDictionary openXmlOrderedKeys][nodeName]) {
                if (attributes[key]) {
                    [attributeString appendFormat:@" %@=\"%@\"", [[key description] XMLEncodedString], [[attributes[key] description] XMLEncodedString]];
                    [allKeys removeObject:key];
                }
            }
        }
        
        //then all others
        for (NSString *key in allKeys) {
            [attributeString appendFormat:@" %@=\"%@\"", [[key description] XMLEncodedString], [[attributes[key] description] XMLEncodedString]];
        }
        
        NSString *innerXML = [node openXmlInnerXMLInNodeNamed:nodeName];
        
        if ([innerXML length]) {
            return [NSString stringWithFormat:@"<%1$@%2$@>%3$@</%1$@>", nodeName, attributeString, innerXML];
        } else {
            return [NSString stringWithFormat:@"<%@%@/>", nodeName, attributeString];
        }
        
        
    } else {
        return [NSString stringWithFormat:@"<%1$@>%2$@</%1$@>", nodeName, [[node description] XMLEncodedString]];
    }
}

@end
