//
//  LLButton.m
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

#import "LLButton.h"

@interface LLButton ()

@property (nonatomic, copy) NSAttributedString *attributedTitle;

@property (nonatomic, strong) UIImage *image;

@end

@implementation LLButton

#pragma mark - Public
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image font:(UIFont *)font color:(UIColor *)color
{
    LLButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.tintColor = color;
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : color}];
    button.attributedTitle = attributedTitle;
    button.image = image;
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

#pragma mark - UIButton Layout Overrides

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    // Bottom aligned and centered.
    CGRect titleRect = CGRectZero;
    CGSize titleSize = [self.attributedTitle boundingRectWithSize:contentRect.size options:0 context:nil].size;
    titleSize = CGSizeMake(ceil(titleSize.width), ceil(titleSize.height));
    titleRect.size = titleSize;
    titleRect.origin.y = contentRect.origin.y + CGRectGetMaxY(contentRect) - titleSize.height;
    titleRect.origin.x = contentRect.origin.x + (contentRect.size.width - titleSize.width) / 2.0;
    return titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize imageSize = self.image.size;
    CGRect titleRect = [self titleRectForContentRect:contentRect];
    CGFloat availableHeight = contentRect.size.height - titleRect.size.height - 2;
    CGFloat originY = 2 + (availableHeight - imageSize.height) / 2.0;
    CGFloat originX = (contentRect.size.width - imageSize.width) / 2.0;
    CGRect imageRect = CGRectMake(originX, originY, imageSize.width, imageSize.height);
    return imageRect;
}

@end
