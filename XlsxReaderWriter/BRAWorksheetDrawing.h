//
//  BRAWorksheetDrawing.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//
#import "BRAPlatformSpecificDefines.h"
#import "BRAOpenXmlSubElement.h"
#import "BRAImage.h"

@interface BRAAnchor : NSObject

- (NSDictionary *)openXmlAttributesForNewAnchoredDrawing;

@end

@interface BRAAbsoluteAnchor : BRAAnchor

@property (nonatomic) CGRect frame;

@end

@interface BRAOneCellAnchor : BRAAnchor

@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint topLeftCellOffset;
@property (nonatomic, strong) NSString *topLeftCellReference;

@end

@interface BRATwoCellAnchor : BRAOneCellAnchor

@property (nonatomic) CGPoint bottomRightCellOffset;
@property (nonatomic, strong) NSString *bottomRightCellReference;

@end

@interface BRAWorksheetDrawing : BRAOpenXmlSubElement

@property (nonatomic, getter=shouldKeepAspectRatio) BOOL keepAspectRatio;
@property (nonatomic) BRANativeEdgeInsets insets;
@property (nonatomic, strong) BRAAnchor *anchor;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *drawingIdentifier;
@property (nonatomic, strong) BRAImage *image;

- (instancetype)initWithImage:(BRAImage *)image andAnchor:(BRAAnchor *)anchor;

@end
