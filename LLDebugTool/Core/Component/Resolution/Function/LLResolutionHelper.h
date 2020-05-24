//
//  LLResolutionHelper.h
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

@class LLResolutionModel;

/**
Resolution style

- LLResolutionStyleInvalid: 无效值
- LLResolutionStyleIPhone4: 320 * 480 @2x, like 4/4s/5/5s/5c.
- LLResolutionStyleIPhoneSE: 320 * 568 @2x, like SE.
- LLResolutionStyleIPhone6: 375 * 667 @2x, like 6/6s/7/8.
- LLResolutionStyleIPhone6Plus: 414 * 736 @3x, like 6+/6s+/7+/8+.
- LLResolutionStyleIPhoneX: 375 * 812 @3x, like X/XS/11 Pro.
- LLResolutionStyleIPhoneXSMax: 414 * 896 @3x, like XS Max/11 Pro Max.
- LLResolutionStyleIPhoneXR: 414 * 896 @2x, like XR/11.
*/
typedef NS_ENUM(NSInteger, LLResolutionStyle) {
    LLResolutionStyleInvalid,
    LLResolutionStyleIPhone4,
    LLResolutionStyleIPhoneSE,
    LLResolutionStyleIPhone6,
    LLResolutionStyleIPhone6Plus,
    LLResolutionStyleIPhoneX,
    LLResolutionStyleIPhoneXSMax,
    LLResolutionStyleIPhoneXR
};

NS_ASSUME_NONNULL_BEGIN

/// Resolution helper.
@interface LLResolutionHelper : NSObject

/// Mock style.
@property (nonatomic, assign) LLResolutionStyle mockStyle;

/// Real style.
@property (nonatomic, assign, readonly) LLResolutionStyle realStyle;

/// Mock bounds.
@property (nonatomic, assign, readonly) CGRect bounds;

/// Mock scale.
@property (nonatomic, assign, readonly) CGFloat scale;

/// Available resolutions.
@property (nonatomic, strong) NSArray<NSNumber *> *availableResolutions;

/// Padding when mock resolution in horizontal.
@property (nonatomic, assign, readonly) CGFloat horizontalPadding;

/// Padding when mock resolution in vertical.
@property (nonatomic, assign, readonly) CGFloat verticalPadding;

/// Shared instance.
+ (instancetype)shared;

/// Whether add resolution status bar view. Add when special screen mock normal screen, or normal screen mock special screen.
- (BOOL)addResolutionStatusBarView;

/// Resolution status bar view height.
- (CGFloat)resolutionStatusBarViewHeight;

@end

NS_ASSUME_NONNULL_END
