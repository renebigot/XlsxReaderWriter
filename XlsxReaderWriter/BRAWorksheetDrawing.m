//
//  BRAWorksheetDrawing.m
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRAWorksheetDrawing.h"
#import "BRACell.h"
#import "BRAColumn.h"
#import "BRARow.h"

@implementation BRAAnchor

- (NSDictionary *)openXmlAttributesForNewAnchoredDrawing {
    return @{};
}

@end

@implementation BRAOneCellAnchor

- (NSDictionary *)openXmlAttributesForNewAnchoredDrawing {
    return @{
             @"xdr:from": @{
                     @"xdr:colOff": @"",
                     @"xdr:rowOff": @"",
                     @"xdr:col": @"",
                     @"xdr:row": @""
                     },
             @"xdr:ext": @{
                     @"_cx": @"",
                     @"_cy": @""
                     },
             @"xdr:pic": @{
                     @"xdr:nvPicPr": @{
                             @"xdr:cNvPr": @{
                                     @"_name": @"",
                                     @"_id": @""
                                     },
                             @"xdr:cNvPicPr": @{
                                     @"a:picLocks":@{
                                             @"_noChangeAspect": @""
                                             }
                                     }
                             },
                     @"xdr:blipFill": @{
                             @"a:blip": @{
                                     @"_xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
                                     @"_r:embed": @"",
                                     },
                             @"a:srcRect": @{
                                     @"_t": @"",
                                     @"_b": @"",
                                     @"_l": @"",
                                     @"_r": @""
                                     },
                             @"a:stretch": @""
                             },
                     @"xdr:spPr": @{
                             @"a:prstGeom": @{
                                     @"_prst": @"rect",
                                     @"a:avLst": @""
                                     }
                             }
                     },
             @"xdr:clientData": @""
             };
}

@end

@implementation BRATwoCellAnchor

- (NSDictionary *)openXmlAttributesForNewAnchoredDrawing {
    return @{
             @"xdr:from": @{
                     @"xdr:colOff": @"",
                     @"xdr:rowOff": @"",
                     @"xdr:col": @"",
                     @"xdr:row": @"",
                     },
             @"xdr:to": @{
                     @"xdr:colOff": @"",
                     @"xdr:rowOff": @"",
                     @"xdr:col": @"",
                     @"xdr:row": @""
                     },
             @"xdr:pic": @{
                     @"xdr:nvPicPr": @{
                             @"xdr:cNvPr": @{
                                     @"_name": @"",
                                     @"_id": @""
                                     },
                             @"xdr:cNvPicPr": @{
                                     @"a:picLocks":@{
                                             @"_noChangeAspect": @""
                                             }
                                     }
                             },
                     @"xdr:blipFill": @{
                             @"a:blip": @{
                                     @"_xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
                                     @"_r:embed": @"",
                                     },
                             @"a:srcRect": @{
                                     @"_t": @"",
                                     @"_b": @"",
                                     @"_l": @"",
                                     @"_r": @""
                                     },
                             @"a:stretch": @""
                             },
                     @"xdr:spPr": @{
                             @"a:prstGeom": @{
                                     @"_prst": @"rect",
                                     @"a:avLst": @""
                                     }
                             }
                     },
             @"xdr:clientData": @""
             };
}

@end
@implementation BRAAbsoluteAnchor

- (NSDictionary *)openXmlAttributesForNewAnchoredDrawing {
    return @{
             @"xdr:pos": @{
                     @"_x": @"",
                     @"_y": @""
                     },
             @"xdr:ext": @{
                     @"_cx": @"",
                     @"_cy": @""
                     },
             @"xdr:pic": @{
                     @"xdr:nvPicPr": @{
                             @"xdr:cNvPr": @{
                                     @"_name": @"",
                                     @"_id": @""
                                     },
                             @"xdr:cNvPicPr": @{
                                     @"a:picLocks":@{
                                             @"_noChangeAspect": @""
                                             }
                                     }
                             },
                     @"xdr:blipFill": @{
                             @"a:blip": @{
                                     @"_xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
                                     @"_r:embed": @"",
                                     },
                             @"a:srcRect": @{
                                     @"_t": @"",
                                     @"_b": @"",
                                     @"_l": @"",
                                     @"_r": @""
                                     },
                             @"a:stretch": @""
                             },
                     @"xdr:spPr": @{
                             @"a:prstGeom": @{
                                     @"_prst": @"rect",
                                     @"a:avLst": @""
                                     }
                             }
                     },
             @"xdr:clientData": @""
             };
}

@end

@implementation BRAWorksheetDrawing

- (instancetype)initWithImage:(BRAImage *)image andAnchor:(BRAAnchor *)anchor {
    if (self = [super initWithOpenXmlAttributes:[anchor openXmlAttributesForNewAnchoredDrawing]]) {
        self.anchor = anchor;
        self.image = image;
        self.identifier = image.identifier;
    }
    
    return self;
}

- (void)loadAttributes {
    NSDictionary *dictionaryRepresentation = [super dictionaryRepresentation];

    if ([dictionaryRepresentation valueForKeyPath:@"xdr:to"]) {
        //Two cells anchor
        BRATwoCellAnchor *anchor = [[BRATwoCellAnchor alloc] init];
        
        NSInteger firstCellColOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:colOff"] integerValue];
        NSInteger firstCellRowOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:rowOff"] integerValue];
        anchor.topLeftCellOffset = CGPointMake(firstCellColOff, firstCellRowOff);
        
        NSInteger firstCellCol = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:col"] integerValue];
        NSInteger firstCellRow = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:row"] integerValue];
        anchor.topLeftCellReference = [BRACell cellReferenceForColumnIndex:firstCellCol + 1 andRowIndex:firstCellRow + 1];
        
        NSInteger secondCellColOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:to.xdr:colOff"] integerValue];
        NSInteger secondCellRowOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:to.xdr:rowOff"] integerValue];
        anchor.bottomRightCellOffset = CGPointMake(secondCellColOff, secondCellRowOff);
        
        NSInteger secondCellCol = [[dictionaryRepresentation valueForKeyPath:@"xdr:to.xdr:col"] integerValue];
        NSInteger secondCellRow = [[dictionaryRepresentation valueForKeyPath:@"xdr:to.xdr:row"] integerValue];
        anchor.bottomRightCellReference = [BRACell cellReferenceForColumnIndex:secondCellCol + 1 andRowIndex:secondCellRow + 1];

        self.anchor = anchor;
    } else if ([dictionaryRepresentation valueForKeyPath:@"xdr:from"]) {
        //One cells anchor
        BRAOneCellAnchor *anchor = [[BRAOneCellAnchor alloc] init];
        
        NSInteger firstCellColOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:colOff"] integerValue];
        NSInteger firstCellRowOff = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:rowOff"] integerValue];
        anchor.topLeftCellOffset = CGPointMake(firstCellColOff, firstCellRowOff);
        
        NSInteger firstCellCol = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:col"] integerValue];
        NSInteger firstCellRow = [[dictionaryRepresentation valueForKeyPath:@"xdr:from.xdr:row"] integerValue];
        anchor.topLeftCellReference = [BRACell cellReferenceForColumnIndex:firstCellCol + 1 andRowIndex:firstCellRow + 1];

        anchor.size = CGSizeMake([[dictionaryRepresentation valueForKeyPath:@"xdr:ext._cx"] integerValue], [[dictionaryRepresentation valueForKeyPath:@"xdr:ext._cy"] integerValue]);
        
        self.anchor = anchor;
    } else {
        //absolute anchor
        NSInteger x = [[dictionaryRepresentation valueForKeyPath:@"xdr:pos._x"] integerValue];
        NSInteger y = [[dictionaryRepresentation valueForKeyPath:@"xdr:pos._y"] integerValue];
        NSInteger width = [[dictionaryRepresentation valueForKeyPath:@"xdr:ext._cx"] integerValue];
        NSInteger height = [[dictionaryRepresentation valueForKeyPath:@"xdr:ext._cy"] integerValue];
        
        BRAAbsoluteAnchor *anchor = [[BRAAbsoluteAnchor alloc] init];
        anchor.frame = CGRectMake(x, y, width, height);
        
        self.anchor = anchor;
    }
    
    self.keepAspectRatio = [[dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPicPr.a:picLocks._noChangeAspect"] boolValue];
    self.insets = BRANativeEdgeInsetsMake([[dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._t"] floatValue] / 100000.,
                                   [[dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._l"] floatValue] / 100000.,
                                   [[dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._b"] floatValue] / 100000.,
                                   [[dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._r"] floatValue] / 100000.);
    self.drawingIdentifier = [dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPr._id"];
    self.name = [dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPr._name"];
    self.identifier = [dictionaryRepresentation valueForKeyPath:@"xdr:pic.xdr:blipFill.a:blip._r:embed"];
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation].mutableDeepCopy;
    
    if (self.name.length == 0) {
        self.name = [NSString stringWithFormat:@"Image %@", self.drawingIdentifier];
    }
    
    [dictionaryRepresentation setValue:self.drawingIdentifier forKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPr._id"];
    [dictionaryRepresentation setValue:self.name forKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPr._name"];
    [dictionaryRepresentation setValue:self.identifier forKeyPath:@"xdr:pic.xdr:blipFill.a:blip._r:embed"];
    [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)self.keepAspectRatio] forKeyPath:@"xdr:pic.xdr:nvPicPr.xdr:cNvPicPr.a:picLocks._noChangeAspect"];

    if (BRANativeEdgeInsetsEqualToEdgeInsets(self.insets, BRANativeEdgeInsetsZero)) {
        [dictionaryRepresentation setValue:@{@"a:fillRect": @""} forKeyPath:@"xdr:pic.xdr:blipFill.a:stretch"];
        [dictionaryRepresentation[@"xdr:pic"][@"xdr:blipFill"] removeObjectForKey:@"a:srcRect"];
    } else {
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)(self.insets.top * 100000)] forKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._t"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)(self.insets.bottom * 100000)] forKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._b"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)(self.insets.left * 100000)] forKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._l"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)(self.insets.right * 100000)] forKeyPath:@"xdr:pic.xdr:blipFill.a:srcRect._r"];
    }
    
    if ([self.anchor isKindOfClass:[BRAAbsoluteAnchor class]]) {
        BRAAbsoluteAnchor *anchor = (BRAAbsoluteAnchor *)self.anchor;
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.frame.origin.x] forKeyPath:@"xdr:pos._x"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.frame.origin.x] forKeyPath:@"xdr:pos._y"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.frame.size.width] forKeyPath:@"xdr:ext._cx"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.frame.size.height] forKeyPath:@"xdr:ext._cy"];
        
    } else if ([self.anchor isKindOfClass:[BRATwoCellAnchor class]]) {
        BRATwoCellAnchor *anchor = (BRATwoCellAnchor *)self.anchor;
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.topLeftCellOffset.x]
                                    forKeyPath:@"xdr:from.xdr:colOff"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.topLeftCellOffset.y]
                                    forKeyPath:@"xdr:from.xdr:rowOff"];
        
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRAColumn columnIndexForCellReference:anchor.topLeftCellReference] - 1]
                                    forKeyPath:@"xdr:from.xdr:col"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRARow rowIndexForCellReference:anchor.topLeftCellReference] - 1]
                                    forKeyPath:@"xdr:from.xdr:row"];
        
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.bottomRightCellOffset.x]
                                    forKeyPath:@"xdr:to.xdr:colOff"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.bottomRightCellOffset.y]
                                    forKeyPath:@"xdr:to.xdr:rowOff"];
        
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRAColumn columnIndexForCellReference:anchor.bottomRightCellReference] - 1]
                                    forKeyPath:@"xdr:to.xdr:col"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRARow rowIndexForCellReference:anchor.bottomRightCellReference] - 1]
                                    forKeyPath:@"xdr:to.xdr:row"];
        
    } else if ([self.anchor isKindOfClass:[BRAOneCellAnchor class]]) {
        BRAOneCellAnchor *anchor = (BRAOneCellAnchor *)self.anchor;
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.topLeftCellOffset.x]
                                    forKeyPath:@"xdr:from.xdr:colOff"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.topLeftCellOffset.y]
                                    forKeyPath:@"xdr:from.xdr:rowOff"];

        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.size.width]
                                forKeyPath:@"xdr:ext._cx"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)anchor.size.height]
                                forKeyPath:@"xdr:ext._cy"];
        
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRAColumn columnIndexForCellReference:anchor.topLeftCellReference] - 1]
                                    forKeyPath:@"xdr:from.xdr:col"];
        [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%ld", (long)[BRARow rowIndexForCellReference:anchor.topLeftCellReference] - 1]
                                    forKeyPath:@"xdr:from.xdr:row"];
    }

    [super setDictionaryRepresentation:dictionaryRepresentation];

    return dictionaryRepresentation;
}

@end
