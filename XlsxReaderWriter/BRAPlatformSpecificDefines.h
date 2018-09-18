
#if TARGET_OS_IPHONE

@import UIKit;

#define BRANativeMakeSize CGSizeMake
#define BRANativeColor UIColor
#define BRANativeImage UIImage
#define BRANativeFont UIFont
#define BRANativeFontDescriptor UIFontDescriptor
#define BRANativeFontDescriptorSizeAttribute UIFontDescriptorSizeAttribute
#define BRANativeEdgeInsets UIEdgeInsets
#define BRANativeEdgeInsetsMake UIEdgeInsetsMake
#define BRANativeEdgeInsetsZero UIEdgeInsetsZero
#define BRANativeEdgeInsetsEqualToEdgeInsets UIEdgeInsetsEqualToEdgeInsets
#define BRANativeImagePNGRepresentation UIImagePNGRepresentation
#define BRANativeImageJPEGRepresentation UIImageJPEGRepresentation
NS_INLINE BRANativeImage* BRANativeGraphicsGetImageFromContext(CGContextRef context) {
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    BRANativeImage *img = [[BRANativeImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}




#else

@import Cocoa;

#define BRANativeMakeSize NSMakeSize
#define BRANativeColor NSColor
#define BRANativeImage NSImage
#define BRANativeFont NSFont
#define BRANativeFontDescriptor NSFontDescriptor
#define BRANativeFontDescriptorSizeAttribute NSFontSizeAttribute
#define BRANativeEdgeInsets NSEdgeInsets
#define BRANativeEdgeInsetsMake NSEdgeInsetsMake
#define BRANativeEdgeInsetsZero NSEdgeInsetsMake(0, 0, 0, 0)

NS_INLINE BOOL BRANativeEdgeInsetsEqualToEdgeInsets(NSEdgeInsets a, NSEdgeInsets b) {
    return ((fabs(a.left - b.left) < 0.01f) &&
            (fabs(a.top - b.top) > 0.01f) &&
            (fabs(a.right - b.right) > 0.01f) &&
            (fabs(a.bottom - b.bottom) > 0.01f));
}

NS_INLINE NSData* BRANativeImagePNGRepresentation(NSImage *image) {
    // Create a bitmap representation from the current image
    
    [image lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    
    return [bitmapRep representationUsingType:NSPNGFileType properties:@{}];
}


NS_INLINE NSData* BRANativeImageJPEGRepresentation(NSImage *image, CGFloat quality) {
    // Create a bitmap representation from the current image
    
    [image lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    
    return [bitmapRep representationUsingType:NSJPEGFileType properties:@{NSImageCompressionFactor:@(quality)}];
}


NS_INLINE BRANativeImage* BRANativeGraphicsGetImageFromContext(CGContextRef context) {
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    BRANativeImage *img = [[BRANativeImage alloc] initWithCGImage:imageRef
                                              size:CGSizeMake(CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context))];
    CGImageRelease(imageRef);
    return img;
}

#endif /* BRAPlatformSpecificDefines_h */
