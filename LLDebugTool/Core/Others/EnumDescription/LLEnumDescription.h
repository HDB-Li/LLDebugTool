//
//  LLEnumDescription.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLEnumDescription : NSObject

+ (NSString *_Nullable)lineBreakModeDescription:(NSLineBreakMode)mode;

+ (NSString *_Nullable)userInterfaceStyleDescription:(UIUserInterfaceStyle)style API_AVAILABLE(ios(12.0));

+ (NSString *_Nullable)userInterfaceSizeClassDescription:(UIUserInterfaceSizeClass)sizeClass;

+ (NSString *_Nullable)traitEnvironmentLayoutDirectionDescription:(UITraitEnvironmentLayoutDirection)direction API_AVAILABLE(ios(10.0));

+ (NSString *_Nullable)viewContentModeDescription:(UIViewContentMode)mode;

+ (NSString *_Nullable)textAlignmentDescription:(NSTextAlignment)textAlignment;

+ (NSString *_Nullable)baselineAdjustmentDescription:(UIBaselineAdjustment)baselineAdjustment;

+ (NSString *_Nullable)controlContentVerticalAlignmentDescription:(UIControlContentVerticalAlignment)contentVerticalAlignment;

+ (NSString *_Nullable)controlContentHorizontalAlignmentDescription:(UIControlContentHorizontalAlignment)contentHorizontalAlignment;

+ (NSString *_Nullable)buttonTypeDescription:(UIButtonType)buttonType;

+ (NSString *_Nullable)controlStateDescription:(UIControlState)state;

+ (NSString *_Nullable)textBorderStyleDescription:(UITextBorderStyle)style;

+ (NSString *_Nullable)textFieldViewModeDescription:(UITextFieldViewMode)mode;

+ (NSString *_Nullable)textAutocapitalizationTypeDescription:(UITextAutocapitalizationType)type;

+ (NSString *_Nullable)textAutocorrectionTypeDescription:(UITextAutocorrectionType)type;

+ (NSString *_Nullable)keyboardTypeDescription:(UIKeyboardType)type;

+ (NSString *_Nullable)keyboardAppearanceDescription:(UIKeyboardAppearance)appearance;

+ (NSString *_Nullable)returnKeyTypeDescription:(UIReturnKeyType)type;

+ (NSString *_Nullable)activityIndicatorViewStyleDescription:(UIActivityIndicatorViewStyle)style;

+ (NSString *_Nullable)progressViewStyleDescription:(UIProgressViewStyle)style;

+ (NSString *_Nullable)scrollViewIndicatorStyleDescription:(UIScrollViewIndicatorStyle)style;

+ (NSString *_Nullable)scrollViewKeyboardDismissModeDescription:(UIScrollViewKeyboardDismissMode)mode;

+ (NSString *_Nullable)tableViewStyleDescription:(UITableViewStyle)style;

+ (NSString *_Nullable)tableViewCellSeparatorStyleDescription:(UITableViewCellSeparatorStyle)style;

+ (NSString *_Nullable)tableViewSeparatorInsetReferenceDescription:(UITableViewSeparatorInsetReference)reference API_AVAILABLE(ios(11.0));

+ (NSString *_Nullable)tableViewCellSelectionStyleDescription:(UITableViewCellSelectionStyle)style;

+ (NSString *_Nullable)tableViewCellAccessoryTypeDescription:(UITableViewCellAccessoryType)type;

+ (NSString *_Nullable)datePickerModeDescription:(UIDatePickerMode)mode;

+ (NSString *_Nullable)barStyleDescription:(UIBarStyle)style;

+ (NSString *_Nullable)searchBarStyleDescription:(UISearchBarStyle)style;

+ (NSString *_Nullable)tabBarItemPositioningDescription:(UITabBarItemPositioning)positioning;

@end

NS_ASSUME_NONNULL_END
