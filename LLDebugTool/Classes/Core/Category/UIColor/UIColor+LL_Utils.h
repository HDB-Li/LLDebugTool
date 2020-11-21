//
//  UIColor+LL_Utils.h
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

NS_ASSUME_NONNULL_BEGIN

/// UIColor utils.
@interface UIColor (LL_Utils)

/// Color with hex.
/// @param hex Hex string.
+ (UIColor *)LL_colorWithHex:(NSString *)hex;

/// Color with hex and error
/// @param hex Hex string.
/// @param error Error.
+ (UIColor *)LL_colorWithHex:(NSString *)hex error:(BOOL *_Nullable)error;

/// Convert to rgba number array.
- (NSArray *)LL_RGBA;

/// Convert to hex string.
- (NSString *)LL_hexString;

/// Description.
- (NSString *)LL_description;

/// System color name if exist.
- (NSString *_Nullable)LL_systemColorName;

/**
 Mixture with another color, radio is between 0.0 to 1.0

 @param color Another color.
 @param radio Mixture radio
 @return New color.
 */
- (UIColor *)LL_mixtureWithColor:(UIColor *)color radio:(CGFloat)radio;

@end

NS_ASSUME_NONNULL_END
