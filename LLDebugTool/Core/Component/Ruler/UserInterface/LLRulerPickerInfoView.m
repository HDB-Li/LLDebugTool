//
//  LLRulerPickerInfoView.m
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

#import "LLRulerPickerInfoView.h"
#import "LLFactory.h"
#import "LLThemeManager.h"
#import "UIView+LL_Utils.h"
#import "LLConst.h"
#import "LLMacros.h"

@interface LLRulerPickerInfoView ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *subContentLabel;

@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation LLRulerPickerInfoView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Public
- (void)updateTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom {
    self.contentLabel.text = [NSString stringWithFormat:@"Top: %0.2f, Left: %0.2f\nRight: %0.2f, Bottom: %0.2f",top,left,right,bottom];
    self.subContentLabel.text = [NSString stringWithFormat:@"Start: {%0.2f, %0.2f}\nCurrent: {%0.2f, %0.2f}",self.startPoint.x,self.startPoint.y,left,top];
    [self updateHeightIfNeeded];
}

- (void)updateStartPoint:(CGPoint)point {
    self.startPoint = point;
    self.subContentLabel.text = [NSString stringWithFormat:@"Start: {%0.2f, %0.2f}",point.x,point.y];
    [self updateHeightIfNeeded];
}

- (void)updateStopPoint:(CGPoint)point {
    self.subContentLabel.text = [NSString stringWithFormat:@"Start: {%0.2f, %0.2f}\nEnd: {%0.2f, %0.2f}",self.startPoint.x,self.startPoint.y,point.x,point.y];
    [self updateHeightIfNeeded];
}

#pragma mark - Primary
- (void)initial {
    [self addSubview:self.contentLabel];
    [self addSubview:self.subContentLabel];
    
    self.contentLabel.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin, self.LL_height - kLLGeneralMargin - kLLGeneralMargin);
    self.subContentLabel.frame = CGRectMake(kLLGeneralMargin, self.contentLabel.LL_bottom, self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin, 0);
}

- (void)updateHeightIfNeeded {
    self.subContentLabel.LL_width = self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin;
    [self.subContentLabel sizeToFit];
    CGFloat height = self.subContentLabel.LL_bottom + kLLGeneralMargin;
    if (height != self.LL_height) {
        self.LL_height = height;
        if (!self.isMoved) {
            if (self.LL_bottom != LL_SCREEN_HEIGHT - kLLGeneralMargin * 2) {
                self.LL_bottom = LL_SCREEN_HEIGHT - kLLGeneralMargin * 2;
            }
        }
    }
}

#pragma mark - Getters and setters
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

- (UILabel *)subContentLabel {
    if (!_subContentLabel) {
        _subContentLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _subContentLabel.numberOfLines = 0;
        _subContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _subContentLabel;
}

@end
