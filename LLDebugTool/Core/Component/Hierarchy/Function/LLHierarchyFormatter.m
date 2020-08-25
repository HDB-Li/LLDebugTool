//
//  LLHierarchyFormatter.m
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

#import "LLHierarchyFormatter.h"

#import "LLFormatterTool.h"
#import "LLTool.h"

#import "UIColor+LL_Utils.h"

@implementation LLHierarchyFormatter

+ (CGRect)rectFromString:(NSString *)string defaultValue:(CGRect)rect {
    CGRect newRect = CGRectFromString(string);
    if (CGRectEqualToRect(newRect, CGRectZero) && ![string isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong rect string"];
        return rect;
    }
    return newRect;
}

+ (UIColor *)colorFromString:(NSString *)string defaultValue:(UIColor *)color {
    BOOL error = NO;
    UIColor *newColor = [UIColor LL_colorWithHex:string error:&error];
    if (error) {
        return color;
    }
    return newColor;
}

+ (CGPoint)pointFromString:(NSString *)string defaultValue:(CGPoint)point {
    CGPoint newPoint = CGPointFromString(string);
    if (CGPointEqualToPoint(newPoint, CGPointZero) && ![string isEqualToString:NSStringFromCGPoint(CGPointZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong point string"];
        return point;
    }
    return newPoint;
}

+ (UIEdgeInsets)insetsFromString:(NSString *)string defaultValue:(UIEdgeInsets)insets {
    UIEdgeInsets newInsets = UIEdgeInsetsFromString(string);
    if (UIEdgeInsetsEqualToEdgeInsets(newInsets, UIEdgeInsetsZero) && ![string isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong insets string"];
        return insets;
    }
    return newInsets;
}

+ (CGSize)sizeFromString:(NSString *)string defaultValue:(CGSize)size {
    CGSize newSize = CGSizeFromString(string);
    if (CGSizeEqualToSize(newSize, CGSizeZero) && ![string isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        // Wrong text.
        [LLTool log:@"Input a wrong size string"];
        return size;
    }
    return newSize;
}

+ (NSString *)formatSize:(CGSize)size {
    return [NSString stringWithFormat:@"W: %@   H: %@", [LLFormatterTool formatNumber:@(size.width)], [LLFormatterTool formatNumber:@(size.height)]];
}

+ (NSString *)formatPoint:(CGPoint)point {
    return [NSString stringWithFormat:@"X: %@   Y: %@", [LLFormatterTool formatNumber:@(point.x)], [LLFormatterTool formatNumber:@(point.y)]];
}

+ (NSString *)formatColor:(UIColor *)color {
    if (!color) {
        return @"<nil color>";
    }

    NSArray *rgba = [color LL_RGBA];
    NSString *rgb = [NSString stringWithFormat:@"R:%@ G:%@ B:%@ A:%@", [LLFormatterTool formatNumber:rgba[0]], [LLFormatterTool formatNumber:rgba[1]], [LLFormatterTool formatNumber:rgba[2]], [LLFormatterTool formatNumber:rgba[3]]];

    NSString *colorName = [color LL_systemColorName];

    return colorName ? [rgb stringByAppendingFormat:@"\n%@", colorName] : [rgb stringByAppendingFormat:@"\n%@", [color LL_hexString]];
}

+ (NSString *)formatText:(NSString *)text {
    if (text == nil) {
        return @"<nil>";
    }
    if ([text length] == 0) {
        return @"<empty string>";
    }
    return text;
}

+ (NSString *)formatObject:(NSObject *)obj {
    NSString *text = @"<null>";
    if (obj) {
        text = [NSString stringWithFormat:@"%@", obj];
    }
    if ([text length] == 0) {
        text = @"<empty string>";
    }
    return text;
}

+ (NSString *)formatImage:(UIImage *)image {
    return image ? image.description : @"No image";
}

+ (NSString *)formatBool:(BOOL)flag {
    return flag ? @"On" : @"Off";
}

+ (NSString *)formatInsetsLeftRight:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"left %@    right %@", [LLFormatterTool formatNumber:@(insets.left)], [LLFormatterTool formatNumber:@(insets.right)]];
}

+ (NSString *)formatInsetsTopBottom:(UIEdgeInsets)insets {
    return [NSString stringWithFormat:@"top %@    bottom %@", [LLFormatterTool formatNumber:@(insets.top)], [LLFormatterTool formatNumber:@(insets.bottom)]];
}

+ (NSString *)formatOffset:(UIOffset)offset {
    return [NSString stringWithFormat:@"h %@   v %@", [LLFormatterTool formatNumber:@(offset.horizontal)], [LLFormatterTool formatNumber:@(offset.vertical)]];
}

+ (NSString *)formatDate:(NSDate *)date {
    if (!date) {
        return @"<null>";
    }
    return [LLFormatterTool stringFromDate:date style:FormatterToolDateStyle3] ?: @"<null>";
}

@end
