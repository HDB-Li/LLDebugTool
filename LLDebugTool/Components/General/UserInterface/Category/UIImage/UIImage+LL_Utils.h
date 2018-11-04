//
//  UIImage+LL_Utils.h
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

#import <UIKit/UIKit.h>

@interface UIImage (LL_Utils)

/**
 * Image in LLDebugTool's bundle.
 */
+ (UIImage *_Nullable)LL_imageNamed:(NSString *_Nonnull)name;

/**
 * Image in LLDebugTool's bundle with the specified size.
 */
+ (UIImage *_Nullable)LL_imageNamed:(NSString *_Nonnull)name size:(CGSize)size;

/**
 * Image in LLDebugTool's bundle with the specified color.
 */
+ (UIImage *_Nullable)LL_imageNamed:(NSString *_Nonnull)name color:(UIColor *_Nonnull)color;

/**
 * Image in LLDebugTool's bundle with the specified size and color.
 */
+ (UIImage *_Nullable)LL_imageNamed:(NSString *_Nonnull)name size:(CGSize)size color:(UIColor *_Nonnull)color;

/**
 * Image from data.
 */
+ (UIImage *_Nullable)LL_imageWithGIFData:(NSData *_Nullable)data;

/**
 * Get a image with the specified size..
 */
- (UIImage *_Nonnull)LL_resizeTo:(CGSize)size;

/**
 * Get a image with the specified color.
 */
- (UIImage *_Nonnull)LL_colorTo:(UIColor *_Nonnull)color;

@end
