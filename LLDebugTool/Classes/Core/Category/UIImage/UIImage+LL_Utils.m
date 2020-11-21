//
//  UIImage+LL_Utils.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UIImage+LL_Utils.h"

#import "LLDebugConfig.h"

#import "UIColor+LL_Utils.h"

@implementation UIImage (LL_Utils)

+ (UIImage *)LL_imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[LLDebugConfig shared].imageBundle compatibleWithTraitCollection:nil];
}

+ (UIImage *)LL_imageNamed:(NSString *)name size:(CGSize)size {
    return [[self LL_imageNamed:name] LL_resizeTo:size];
}

+ (UIImage *)LL_imageWithGIFData:(NSData *)data {
    if (!data) {
        return nil;
    }

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            duration += [self LL_frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)LL_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)LL_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)LL_resizeTo:(CGSize)size {
    // Create a context for the bitmap and set it to the current context being used.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // Draws a resizing image.
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // Create a resized image from the current context.
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // Causes the current context to exit the stack
    UIGraphicsEndImageContext();
    // Return new image.
    return newImage;
}

- (NSArray<NSArray<NSString *> *> *)LL_hexColors {
    CGImageRef cgimage = [self CGImage];
    size_t width = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char));
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = width * 4;   // RGBA
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    NSMutableArray *hexColors = [[NSMutableArray alloc] initWithCapacity:height];
    for (size_t i = 0; i < height; i++) {
        NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:width];
        for (size_t j = 0; j < width; j++) {
            size_t pixelIndex = i * width * 4 + j * 4;
            unsigned char red = data[pixelIndex];
            unsigned char green = data[pixelIndex + 1];
            unsigned char blue = data[pixelIndex + 2];

            NSString *hexColor = [NSString stringWithFormat:@"#%02x%02x%02x", red, green, blue];
            [colors addObject:hexColor];
        }
        [hexColors addObject:colors];
    }

    CGColorSpaceRelease(space);
    CGContextRelease(context);
    free(data);
    return hexColors;
}

- (NSString *)LL_hexColorAt:(CGPoint)point {
    return [[self LL_ColorAt:point] LL_hexString];
}

- (UIColor *)LL_ColorAt:(CGPoint)point {
    UIColor* color = nil;
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return color;
    }
    
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) {
        return color;
    }

    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(imageRef);
    size_t pixelsHigh = CGImageGetHeight(imageRef);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        return color;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return color;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        CGColorSpaceRelease(colorSpace);
        return color;
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    CGRect rect = {{0,0},{pixelsWide,pixelsHigh}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, rect, imageRef);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (context);
    if (data != NULL) {
            //offset locates the pixel in the data from x,y.
            //4 for 4 bytes of data per pixel, w is width of one row of data.
            int offset = 4*((pixelsWide*round(point.y))+round(point.x));
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
            
    }
    
    // When finished, release the context
    CGContextRelease(context);
    // Free image data memory for the context
    if (data) { free(data); }
    return color;
}

@end
