//
//  LLHierarchyFormatter.h
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

@interface LLHierarchyFormatter : NSObject

/// Convert string to CGRect if enable.
/// @param string String.
/// @param rect Default rect.
+ (CGRect)rectFromString:(NSString *)string defaultValue:(CGRect)rect;

/// Convert string to UIColor if enable.
/// @param string String.
/// @param color Default color.
+ (UIColor *)colorFromString:(NSString *)string defaultValue:(UIColor *)color;

/// Convert string to CGPoint if enable.
/// @param string String.
/// @param point Default point.
+ (CGPoint)pointFromString:(NSString *)string defaultValue:(CGPoint)point;

/// Convert string to UIEdgeInsets if enable.
/// @param string String.
/// @param insets Default insets.
+ (UIEdgeInsets)insetsFromString:(NSString *)string defaultValue:(UIEdgeInsets)insets;

/// Convert string to CGSize if enable.
/// @param string String.
/// @param size Default size.
+ (CGSize)sizeFromString:(NSString *)string defaultValue:(CGSize)size;

/**
 Format size.
 
 @param size Size.
 @return Format string.
 */
+ (NSString *)formatSize:(CGSize)size;

/**
 Format point.
 
 @param point Point.
 @return Format string.
 */
+ (NSString *)formatPoint:(CGPoint)point;

/**
 Format color.
 
 @param color Color.
 @return Format string.
 */
+ (NSString *)formatColor:(UIColor *)color;

/**
 Format text.
 
 @param text Text.
 @return Format string.
 */
+ (NSString *)formatText:(NSString *)text;

/**
 Format object.
 
 @param obj An object.
 @return Format string.
 */
+ (NSString *)formatObject:(NSObject *)obj;

/**
 Format image.
 
 @param image An image.
 @return Format string.
 */
+ (NSString *)formatImage:(UIImage *)image;

/**
 Format bool.
 
 @param flag Bool.
 @return Format string.
 */
+ (NSString *)formatBool:(BOOL)flag;

/**
 Format insets.
 
 @param insets Insets.
 @return Format string.
 */
+ (NSString *)formatInsetsLeftRight:(UIEdgeInsets)insets;

/**
 Format insets.
 
 @param insets Insets.
 @return Format string.
 */
+ (NSString *)formatInsetsTopBottom:(UIEdgeInsets)insets;
/**
 Format offset.
 
 @param offset Offset.
 @return Format string.
 */
+ (NSString *)formatOffset:(UIOffset)offset;

/**
 Format date.
 
 @param date Date
 @return Format string
 */
+ (NSString *)formatDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
