//
//  LLPickerView.m
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

#import "LLPickerView.h"

#import "LLThemeManager.h"

#import "UIView+LL_Utils.h"

@implementation LLPickerView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.overflow = YES;
    self.backgroundColor = [UIColor clearColor];
    [self LL_setCornerRadius:self.LL_width / 2.0];
    [self LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    
    CGFloat width = 20;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.LL_width - width) / 2.0, (self.LL_height - width) / 2.0, width, width)].CGPath;
    layer.fillColor = [[LLThemeManager shared].primaryColor colorWithAlphaComponent:0.5].CGColor;
    layer.strokeColor = [LLThemeManager shared].backgroundColor.CGColor;
    layer.lineWidth = 0.5;
    [self.layer addSublayer:layer];
}

@end
