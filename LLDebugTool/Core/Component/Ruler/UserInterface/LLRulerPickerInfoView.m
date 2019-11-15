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

#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLRulerPickerInfoView ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation LLRulerPickerInfoView

#pragma mark - Public
- (void)updatePoint:(CGPoint)point {
    [self updateContentText:point];
}

- (void)updateStartPoint:(CGPoint)point {
    self.startPoint = point;
    [self updateContentText:point];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.startPoint = CGPointZero;
    [self addSubview:self.contentLabel];
    
    self.contentLabel.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin, self.LL_height - kLLGeneralMargin - kLLGeneralMargin);
}

#pragma mark - Primary
- (void)updateContentText:(CGPoint)point {
    self.contentLabel.text = [NSString stringWithFormat:@"Top : %0.2f    Bottom : %0.2f\nLeft : %0.2f    Right : %0.2f\n\nStart : {%0.2f , %0.2f}\nEnd : { %0.2f , %0.2f}\nChange : {%0.2f : %0.2f}",point.y,LL_SCREEN_HEIGHT - point.y,point.x,LL_SCREEN_WIDTH - point.x,self.startPoint.x,self.startPoint.y,point.x,point.y,point.x - self.startPoint.x, point.y - self.startPoint.y];
    [self updateHeightIfNeeded];
}

- (void)updateHeightIfNeeded {
    self.contentLabel.LL_width = self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin;
    [self.contentLabel sizeToFit];
    CGFloat height = self.contentLabel.LL_bottom + kLLGeneralMargin;
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

@end
