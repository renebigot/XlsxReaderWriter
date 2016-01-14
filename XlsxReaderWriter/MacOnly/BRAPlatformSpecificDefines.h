#ifndef BRAPlatformSpecificDefines_h
#define BRAPlatformSpecificDefines_h

#import <Cocoa/Cocoa.h>

#define BRANativeColor NSColor
#define BRANativeImage NSImage
#define BRANativeFont NSFont
#define BRANativeFontDescriptor NSFontDescriptor
#define BRANativeFontDescriptorSizeAttribute NSFontSizeAttribute
#define BRANativeScreen NSScreen
#define BRANativeEdgeInsets NSEdgeInsets
#define BRANativeEdgeInsetsMake NSEdgeInsetsMake
#define BRANativeEdgeInsetsZero NSEdgeInsetsZero

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


#endif /* BRAPlatformSpecificDefines_h */
