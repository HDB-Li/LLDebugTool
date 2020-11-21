//
//  LLFeatureItemView.m
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

#import "LLFeatureItemView.h"

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLFactory.h"
#import "LLFeatureItemModel.h"
#import "LLThemeManager.h"

#import "UIImage+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLFeatureItemView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LLFeatureItemView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.imageView = [LLFactory getImageView:self];
    self.imageView.tintColor = [LLThemeManager shared].primaryColor;
    self.titleLabel = [LLFactory getLabel:self frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)themeColorChanged {
    [super themeColorChanged];
    self.titleLabel.textColor = [LLThemeManager shared].primaryColor;
    self.imageView.tintColor = [LLThemeManager shared].primaryColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, kLLGeneralMargin, 40, 40);
    self.imageView.LL_centerX = self.LL_width / 2.0;
    self.titleLabel.frame = CGRectMake(0, self.imageView.LL_bottom + kLLGeneralMargin, self.LL_width, 20);
}

#pragma mark - Primary
- (void)updateUI:(LLFeatureItemModel *)model {
    self.imageView.tintColor = [LLThemeManager shared].primaryColor;
    self.imageView.image = [[UIImage LL_imageNamed:model.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleLabel.text = model.title;
}

#pragma mark - Getters and setters
- (void)setModel:(LLFeatureItemModel *)model {
    if (_model != model) {
        _model = model;
        [self updateUI:model];
    }
}

@end
