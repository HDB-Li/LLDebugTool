//
//  LLMagnifierInfoView.m
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

#import "LLMagnifierInfoView.h"

#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLWindowManager.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

#import "UIColor+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLMagnifierInfoView ()

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UILabel *colorLabel;

@end

@implementation LLMagnifierInfoView

- (void)update:(NSString *)hexColor point:(CGPoint)point {
    self.colorView.backgroundColor = [UIColor LL_colorWithHex:hexColor];
    self.colorLabel.text = [NSString stringWithFormat:@"%@\nX: %0.1f, Y: %0.1f", hexColor, point.x, point.y];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.colorView.frame = CGRectMake(20, (self.LL_height - 20) / 2.0, 20, 20);
    
    self.colorLabel.frame = CGRectMake(self.colorView.LL_right + 20, 0, self.LL_width - self.colorView.LL_right - 20, self.LL_height);
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    [self addSubview:self.colorView];
    [self addSubview:self.colorLabel];
}

#pragma mark - Getters and setters
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [LLFactory getView];
        [_colorView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:0.5];
    }
    return _colorView;
}

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [LLFactory getLabel];
        _colorLabel.font = [UIFont systemFontOfSize:14];
        _colorLabel.textColor = [LLThemeManager shared].primaryColor;
        _colorLabel.numberOfLines = 0;
    }
    return _colorLabel;
}

@end
