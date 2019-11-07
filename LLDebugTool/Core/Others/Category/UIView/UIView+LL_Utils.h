//
//  UIView+LL_Utils.h
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

/// UIView utils.
@interface UIView (LL_Utils)

/// Horizontal padding.
@property (nonatomic, assign) CGFloat LL_horizontalPadding;

/// Vertical padding.
@property (nonatomic, assign) CGFloat LL_verticalPadding;

/// X
@property (nonatomic, assign) CGFloat LL_x;

/// Y
@property (nonatomic, assign) CGFloat LL_y;

/// CenterX
@property (nonatomic, assign) CGFloat LL_centerX;

/// CenterY
@property (nonatomic, assign) CGFloat LL_centerY;

/// Width
@property (nonatomic, assign) CGFloat LL_width;

/// Height
@property (nonatomic, assign) CGFloat LL_height;

/// Size
@property (nonatomic, assign) CGSize LL_size;

/// Top
@property (nonatomic, assign) CGFloat LL_top;

/// Bottom
@property (nonatomic, assign) CGFloat LL_bottom;

/// Left
@property (nonatomic, assign) CGFloat LL_left;

/// Right
@property (nonatomic, assign) CGFloat LL_right;

/// Set corner radius
/// @param cornerRadius Radius.
- (void)LL_setCornerRadius:(CGFloat)cornerRadius;

/// Set border color and width.
/// @param borderColor Color
/// @param borderWidth Width.
- (void)LL_setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/// Remove all subviews.
- (void)LL_removeAllSubviews;

/// Remove all subviews but ignore in array.
/// @param views Ignore view array.
- (void)LL_removeAllSubviewsIgnoreIn:(NSArray <UIView *>*_Nullable)views;

/// The most bottom view.
- (UIView *_Nullable)LL_bottomView;

/// Add tap to view.
/// @param target Target
/// @param action Action.
- (void)LL_addClickListener:(id)target action:(SEL)action;

/// Convert to image.
- (UIImage *)LL_convertViewToImage;

@end

NS_ASSUME_NONNULL_END
