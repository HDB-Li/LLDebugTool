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

+ (NSString *)textBorderStyleDescription:(UITextBorderStyle)style {
    switch (style) {
        case UITextBorderStyleNone:
            return @"None";
        case UITextBorderStyleLine:
            return @"Line";
        case UITextBorderStyleBezel:
            return @"Bezel";
        case UITextBorderStyleRoundedRect:
            return @"Rounded Rect";
    }
    return nil;
}

+ (NSString *)textFieldViewModeDescription:(UITextFieldViewMode)mode {
    switch (mode) {
        case UITextFieldViewModeNever:
            return @"Never appears";
        case UITextFieldViewModeWhileEditing:
            return @"While editing";
        case UITextFieldViewModeUnlessEditing:
            return @"Unless editing";
        case UITextFieldViewModeAlways:
            return @"Always appears";
    }
    return nil;
}

+ (NSString *_Nullable)textAutocapitalizationTypeDescription:(UITextAutocapitalizationType)type {
    switch (type) {
        case UITextAutocapitalizationTypeNone:
            return @"None";
        case UITextAutocapitalizationTypeWords:
            return @"Words";
        case UITextAutocapitalizationTypeSentences:
            return @"Sentences";
        case UITextAutocapitalizationTypeAllCharacters:
            return @"All Characters";
    }
    return nil;
}

+ (NSString *)textAutocorrectionTypeDescription:(UITextAutocorrectionType)type {
    switch (type) {
        case UITextAutocorrectionTypeDefault:
            return @"Default";
        case UITextAutocorrectionTypeYes:
            return @"YES";
        case UITextAutocorrectionTypeNo:
            return @"NO";
    }
    return nil;
}

+ (NSString *_Nullable)keyboardTypeDescription:(UIKeyboardType)type {
    switch (type) {
        case UIKeyboardTypeDefault:
            return @"Default";
        case UIKeyboardTypeASCIICapable:
            return @"ASCII capable";
        case UIKeyboardTypeNumbersAndPunctuation:
            return @"Numbers and punctuation";
        case UIKeyboardTypeURL:
            return @"URL";
        case UIKeyboardTypeNumberPad:
            return @"Number pad";
        case UIKeyboardTypePhonePad:
            return @"Phone pad";
        case UIKeyboardTypeNamePhonePad:
            return @"Name phone pad";
        case UIKeyboardTypeEmailAddress:
            return @"Email address";
        case UIKeyboardTypeDecimalPad:
            return @"Decimal pad";
        case UIKeyboardTypeTwitter:
            return @"Twitter";
        case UIKeyboardTypeWebSearch:
            return @"Web search";
        case UIKeyboardTypeASCIICapableNumberPad:
            return @"ASCII capable number pad";
    }
    return nil;
}

+ (NSString *)keyboardAppearanceDescription:(UIKeyboardAppearance)appearance {
    switch (appearance) {
        case UIKeyboardAppearanceDefault:
            return @"Default";
        case UIKeyboardAppearanceDark:
            return @"Dark";
        case UIKeyboardAppearanceLight:
            return @"Light";
    }
    return nil;
}

+ (NSString *)returnKeyTypeDescription:(UIReturnKeyType)type {
    switch (type) {
        case UIReturnKeyDefault:
            return @"Default";
        case UIReturnKeyGo:
            return @"Go";
        case UIReturnKeyGoogle:
            return @"Google";
        case UIReturnKeyJoin:
            return @"Join";
        case UIReturnKeyNext:
            return @"Next";
        case UIReturnKeyRoute:
            return @"Route";
        case UIReturnKeySearch:
            return @"Search";
        case UIReturnKeySend:
            return @"Send";
        case UIReturnKeyYahoo:
            return @"Yahoo";
        case UIReturnKeyDone:
            return @"Done";
        case UIReturnKeyEmergencyCall:
            return @"Emergency call";
        case UIReturnKeyContinue:
            return @"Continue";
    }
    return nil;
}

+ (NSString *_Nullable)activityIndicatorViewStyleDescription:(UIActivityIndicatorViewStyle)style {
    switch (style) {
#ifdef __IPHONE_13_0
        case UIActivityIndicatorViewStyleMedium:
            return @"Medium";
        case UIActivityIndicatorViewStyleLarge:
            return @"Large";
#endif
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case UIActivityIndicatorViewStyleWhiteLarge:
            return @"White Large";
        case UIActivityIndicatorViewStyleWhite:
            return @"White";
        case UIActivityIndicatorViewStyleGray:
            return @"Gray";
#pragma clang diagnostic pop
    }
    return nil;
}

+ (NSString *_Nullable)progressViewStyleDescription:(UIProgressViewStyle)style {
    switch (style) {
        case UIProgressViewStyleDefault:
            return @"Default";
        case UIProgressViewStyleBar:
            return @"Bar";
    }
    return nil;
}

+ (NSString *_Nullable)scrollViewIndicatorStyleDescription:(UIScrollViewIndicatorStyle)style {
    switch (style) {
        case UIScrollViewIndicatorStyleDefault:
            return @"Default";
        case UIScrollViewIndicatorStyleBlack:
            return @"Black";
        case UIScrollViewIndicatorStyleWhite:
            return @"White";
    }
    return nil;
}

+ (NSString *_Nullable)scrollViewKeyboardDismissModeDescription:(UIScrollViewKeyboardDismissMode)mode {
    switch (mode) {
        case UIScrollViewKeyboardDismissModeNone:
            return @"Do not dismiss";
        case UIScrollViewKeyboardDismissModeOnDrag:
            return @"Dismiss on drag";
        case UIScrollViewKeyboardDismissModeInteractive:
            return @"Dismiss interactively";
    }
    return nil;
}

+ (NSString *_Nullable)tableViewStyleDescription:(UITableViewStyle)style {
    switch (style) {
        case UITableViewStylePlain:
            return @"Plain";
        case UITableViewStyleGrouped:
            return @"Grouped";
#ifdef __IPHONE_13_0
        case UITableViewStyleInsetGrouped:
            return @"Inset Grouped";
#endif
    }
    return nil;
}

+ (NSString *_Nullable)tableViewCellSeparatorStyleDescription:(UITableViewCellSeparatorStyle)style {
    switch (style) {
        case UITableViewCellSeparatorStyleNone:
            return @"None";
        case UITableViewCellSeparatorStyleSingleLine:
            return @"Single Line";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case UITableViewCellSeparatorStyleSingleLineEtched:
            return @"Single Line Etched";
#pragma clang diagnostic pop
    }
    return nil;
}

+ (NSString *_Nullable)tableViewSeparatorInsetReferenceDescription:(UITableViewSeparatorInsetReference)reference {
    switch (reference) {
        case UITableViewSeparatorInsetFromCellEdges:
            return @"From Cell Edges";
        case UITableViewSeparatorInsetFromAutomaticInsets:
            return @"Automatic Insets";
    }
    return nil;
}

+ (NSString *_Nullable)tableViewCellSelectionStyleDescription:(UITableViewCellSelectionStyle)style {
    switch (style) {
        case UITableViewCellSelectionStyleNone:
            return @"None";
        case UITableViewCellSelectionStyleBlue:
            return @"Blue";
        case UITableViewCellSelectionStyleGray:
            return @"Gray";
        case UITableViewCellSelectionStyleDefault:
            return @"Default";
    }
    return nil;
}

+ (NSString *_Nullable)tableViewCellAccessoryTypeDescription:(UITableViewCellAccessoryType)type {
    switch (type) {
        case UITableViewCellAccessoryNone:
            return @"None";
        case UITableViewCellAccessoryDisclosureIndicator:
            return @"Disclosure Indicator";
        case UITableViewCellAccessoryDetailDisclosureButton:
            return @"Disclosure Button";
        case UITableViewCellAccessoryCheckmark:
            return @"Checkmark";
        case UITableViewCellAccessoryDetailButton:
            return @"Detail Button";
    }
    return nil;
}

+ (NSString *_Nullable)datePickerModeDescription:(UIDatePickerMode)mode {
    switch (mode) {
        case UIDatePickerModeDate:
            return @"Date";
        case UIDatePickerModeTime:
            return @"Time";
        case UIDatePickerModeDateAndTime:
            return @"Date and Time";
        case UIDatePickerModeCountDownTimer:
            return @"Count Down Timer";
    }
    return nil;
}

+ (NSString *_Nullable)barStyleDescription:(UIBarStyle)style {
    switch (style) {
        case UIBarStyleDefault:
            return @"Default";
        case UIBarStyleBlack:
            return @"Black";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case UIBarStyleBlackTranslucent:
            return @"Black Translucent";
#pragma clang diagnostic pop
        }
    return nil;
}

+ (NSString *_Nullable)searchBarStyleDescription:(UISearchBarStyle)style {
    switch (style) {
        case UISearchBarStyleDefault:
            return @"Default";
        case UISearchBarStyleMinimal:
            return @"Minimal";
        case UISearchBarStyleProminent:
            return @"Prominent";
    }
    return nil;
}

+ (NSString *_Nullable)tabBarItemPositioningDescription:(UITabBarItemPositioning)positioning {
    switch (positioning) {
        case UITabBarItemPositioningAutomatic:
            return @"Automatic";
        case UITabBarItemPositioningFill:
            return @"Fill";
        case UITabBarItemPositioningCentered:
            return @"Centered";
    }
    return nil;
}

@end
