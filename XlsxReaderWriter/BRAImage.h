//
//  BRAImage.h
//  BRAXlsxReaderWriter
//
//  Created by René BIGOT on 22/10/2014.
//  Copyright (c) 2014 René Bigot. All rights reserved.
//

#import "BRARelationship.h"

@interface BRAImage : BRARelationship

@property (nonatomic, getter=isJpeg) BOOL jpeg;
@property (nonatomic, strong) BRANativeImage *uiImage;

@end
