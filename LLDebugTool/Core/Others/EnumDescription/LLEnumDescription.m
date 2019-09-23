//
//  LLEnumDescription.m
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
#import "LLEnumDescription.h"

@implementation LLEnumDescription

+ (NSString *)lineBreakModeDescription:(NSLineBreakMode)mode {
    switch (mode) {
        case NSLineBreakByWordWrapping:
            return @"Word Wrapping";
        case NSLineBreakByCharWrapping:
            return @"Char Wrapping";
        case NSLineBreakByClipping:
            return @"Clipping";
        case NSLineBreakByTruncatingHead:
            return @"Truncating Head";
        case NSLineBreakByTruncatingMiddle:
            return @"Truncating Middle";
        case NSLineBreakByTruncatingTail:
            return @"Truncation Tail";
    }
    return nil;
}

+ (NSString *_Nullable)userInterfaceStyleDescription:(UIUserInterfaceStyle)style {
    switch (style) {
        case UIUserInterfaceStyleUnspecified:
            return @"Unspecified";
        case UIUserInterfaceStyleLight:
            return @"Light User Interface Style";
        case UIUserInterfaceStyleDark:
            return @"Dark User Interface Style";
    }
    return nil;
}

+ (NSString *_Nullable)userInterfaceSizeClassDescription:(UIUserInterfaceSizeClass)sizeClass {
    switch (sizeClass) {
        case UIUserInterfaceSizeClassUnspecified:
            return @"Unspecified";
        case UIUserInterfaceSizeClassCompact:
            return @"Compact Size Class";
        case UIUserInterfaceSizeClassRegular:
            return @"Regular Size Class";
    }
    return nil;
}

+ (NSString *_Nullable)traitEnvironmentLayoutDirectionDescription:(UITraitEnvironmentLayoutDirection)direction {
    switch (direction) {
        case UITraitEnvironmentLayoutDirectionUnspecified:
            return @"Unspecified";
        case UITraitEnvironmentLayoutDirectionLeftToRight:
            return @"Left To Right Layout";
        case UITraitEnvironmentLayoutDirectionRightToLeft:
            return @"Right To Left Layout";
    }
    return nil;
}

+ (NSString *_Nullable)viewContentModeDescription:(UIViewContentMode)mode {
    switch (mode) {
        case UIViewContentModeScaleToFill:
            return @"ScaleToFill";
        case UIViewContentModeScaleAspectFit:
            return @"ScaleAspectFit";
        case UIViewContentModeScaleAspectFill:
            return @"ScaleAspectFill";
        case UIViewContentModeRedraw:
            return @"Redraw";
        case UIViewContentModeCenter:
            return @"Center";
        case UIViewContentModeTop:
            return @"Top";
        case UIViewContentModeBottom:
            return @"Bottom";
        case UIViewContentModeLeft:
            return @"Left";
        case UIViewContentModeRight:
            return @"Right";
        case UIViewContentModeTopLeft:
            return @"TopLeft";
        case UIViewContentModeTopRight:
            return @"TopRight";
        case UIViewContentModeBottomLeft:
            return @"BottomLeft";
        case UIViewContentModeBottomRight:
            return @"BottomRight";
    }
    return nil;
}

+ (NSString *)textAlignmentDescription:(NSTextAlignment)textAlignment {
    switch (textAlignment) {
        case NSTextAlignmentLeft:
            return @"Left";
        case NSTextAlignmentRight:
            return @"Right";
        case NSTextAlignmentCenter:
            return @"Center";
        case NSTextAlignmentJustified:
            return @"Justified";
        case NSTextAlignmentNatural:
            return @"Natural";
    }
    return nil;
}

+ (NSString *)baselineAdjustmentDescription:(UIBaselineAdjustment)baselineAdjustment {
    switch (baselineAdjustment) {
        case UIBaselineAdjustmentAlignBaselines:
            return @"Baselines";
        case UIBaselineAdjustmentAlignCenters:
            return @"Centers";
        case UIBaselineAdjustmentNone:
            return @"None";
    }
    return nil;
}

+ (NSString *)controlContentVerticalAlignmentDescription:(UIControlContentVerticalAlignment)contentVerticalAlignment {
    switch (contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            return @"Centered";
        case UIControlContentVerticalAlignmentTop:
            return @"Top";
        case UIControlContentVerticalAlignmentBottom:
            return @"Bottom";
        case UIControlContentVerticalAlignmentFill:
            return @"Fill";
    }
    return nil;
}

+ (NSString *)controlContentHorizontalAlignmentDescription:(UIControlContentHorizontalAlignment)contentHorizontalAlignment {
    switch (contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentCenter:
            return @"Centered";
        case UIControlContentHorizontalAlignmentLeft:
            return @"Left";
        case UIControlContentHorizontalAlignmentRight:
            return @"Right";
        case UIControlContentHorizontalAlignmentFill:
            return @"Fill";
        case UIControlContentHorizontalAlignmentLeading:
            return @"Leading";
        case UIControlContentHorizontalAlignmentTrailing:
            return @"Trailing";
    }
    return nil;
}

+ (NSString *)buttonTypeDescription:(UIButtonType)buttonType {
    switch (buttonType) {
        case UIButtonTypeCustom:
            return @"Custom";
        case UIButtonTypeSystem:
            return @"System";
        case UIButtonTypeDetailDisclosure:
            return @"Detail Disclosure";
        case UIButtonTypeInfoLight:
            return @"Info Light";
        case UIButtonTypeInfoDark:
            return @"Info Dark";
        case UIButtonTypeContactAdd:
            return @"Contact Add";
#ifdef __IPHONE_13_0
        case UIButtonTypeClose:
            return @"Close";
#endif
        default:
            break;
    }
    return nil;
}

+ (NSString *)controlStateDescription:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            return @"Normal";
        case UIControlStateFocused:
            return @"Focused";
        case UIControlStateDisabled:
            return @"Disabled";
        case UIControlStateReserved:
            return @"Reserved";
        case UIControlStateSelected:
            return @"Selected";
        case UIControlStateApplication:
            return @"Application";
        case UIControlStateHighlighted:
            return @"Highlighted";
    }
    return nil;
}

@end
