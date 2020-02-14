//
//  LLBaseTableViewCell.m
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

#import "LLBaseTableViewCell.h"

#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

@implementation LLBaseTableViewCell

#pragma mark - Life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self configSubviews:self];
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)initUI {
    self.tintColor = [LLThemeManager shared].primaryColor;
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.selectedBackgroundView = [LLFactory getView];
    self.selectedBackgroundView.backgroundColor = [[LLThemeManager shared].primaryColor colorWithAlphaComponent:0.2];
    
    self.textLabel.textColor = [LLThemeManager shared].primaryColor;
    self.detailTextLabel.textColor = [LLThemeManager shared].primaryColor;
}

- (void)themeColorChanged {
    self.tintColor = [LLThemeManager shared].primaryColor;
    self.textLabel.textColor = [LLThemeManager shared].primaryColor;
    self.detailTextLabel.textColor = [LLThemeManager shared].primaryColor;
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self configSubviews:self];
}

#pragma mark - Over write
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            for (UIView *view in subview.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)view;
                    UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
                    if (imageView.image != nil && imageView.image.renderingMode != mode) {
                        imageView.image = [imageView.image imageWithRenderingMode:mode];
                    }
                    break;
                }
            }
        } else if ([subview isKindOfClass: [UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            if (button.currentBackgroundImage != nil && button.currentBackgroundImage.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                [button setBackgroundImage:[button.currentBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:button.state];
            }
        }
    }
}

#pragma mark - LLDebugToolUpdateThemeNotificationName
- (void)didReceiveDebugToolUpdateThemeNotification:(NSNotification *)notification {
    [self themeColorChanged];
}

#pragma mark - Primary
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugToolUpdateThemeNotification:) name:LLDebugToolUpdateThemeNotificationName object:nil];
}

- (void)configSubviews:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel *)view).textColor = [LLThemeManager shared].primaryColor;
    }
    if (view.subviews) {
        for (UIView *subView in view.subviews) {
            [self configSubviews:subView];
        }
    }
}

@end
