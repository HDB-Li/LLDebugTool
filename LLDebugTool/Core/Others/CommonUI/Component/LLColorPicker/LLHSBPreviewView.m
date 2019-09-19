//
//  LLHSBPreviewView.m
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

#import "LLHSBPreviewView.h"
#import "UIView+LL_Utils.h"

@interface LLHSBPreviewView ()

@property (nonatomic, assign) CGFloat brightness;

@end

@implementation LLHSBPreviewView

#pragma mark - Over write
- (void)initUI {
    _brightness = 1.0;
    [super initUI];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    CGFloat widthItem = self.frame.size.width / 100;
    CGFloat heightItem = self.frame.size.height / 100;
    for (NSInteger i = 0; i < 100; i++) {
        for (NSInteger j = 0; j < 100; j++) {
            CGRect rect = CGRectMake(j * widthItem, i * heightItem, widthItem, heightItem);
            UIColor *color = [UIColor colorWithHue:i / 100.0 saturation:j / 100.0 brightness:self.brightness alpha:1];
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillRect(context, rect);
        }
    }
    
    UIGraphicsEndImageContext();
}

#pragma mark - Primary


@end
