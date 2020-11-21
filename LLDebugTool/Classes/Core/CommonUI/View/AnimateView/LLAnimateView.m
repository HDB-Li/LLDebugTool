//
//  LLAnimateView.m
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

#import "LLAnimateView.h"

#import "LLFactory.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"

@interface LLAnimateView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation LLAnimateView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    return [super initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

#pragma mark - Public
- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    UIWindow *window = [LLTool keyWindow];
    [window addSubview:self];
    CGRect frame = [self contentViewFrame];
    if (animated) {
        self.backgroundView.alpha = 0;
        switch (self.showAnimateStyle) {
            case LLAnimateViewShowAnimateStyleFade: {
                self.contentView.frame = frame;
                self.contentView.alpha = 0;
            } break;
            case LLAnimateViewShowAnimateStylePresent: {
                self.contentView.frame = CGRectMake(frame.origin.x, self.LL_height, frame.size.width, frame.size.height);
            } break;
            case LLAnimateViewShowAnimateStylePush: {
                self.contentView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
            } break;
            default:
                break;
        }
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backgroundView.alpha = 1;
                             switch (self.showAnimateStyle) {
                                 case LLAnimateViewShowAnimateStyleFade: {
                                     self.contentView.alpha = 1;
                                 } break;
                                 case LLAnimateViewShowAnimateStylePresent:
                                 case LLAnimateViewShowAnimateStylePush: {
                                     self.contentView.frame = frame;
                                 } break;
                                 default:
                                     break;
                             }
                         }];
    } else {
        self.backgroundView.alpha = 1;
        self.contentView.frame = frame;
    }
}

- (void)hide {
    [self hide:YES];
}

- (void)hide:(BOOL)animated {
    if (animated) {
        CGRect frame = [self contentViewFrame];
        [UIView animateWithDuration:0.25
            animations:^{
                self.backgroundView.alpha = 0;
                switch (self.hideAnimateStyle) {
                    case LLAnimateViewHideAnimateStyleFade: {
                        self.contentView.alpha = 0;
                    } break;
                    case LLAnimateViewHideAnimateStyleDismiss: {
                        self.contentView.frame = CGRectMake(frame.origin.x, self.LL_height, frame.size.width, frame.size.height);
                    } break;
                    case LLAnimateViewHideAnimateStylePop: {
                        self.contentView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
                    } break;
                    default:
                        break;
                }
            }
            completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.backgroundView.alpha = 1;
                self.contentView.frame = frame;
            }];
    } else {
        [self removeFromSuperview];
    }
}

- (CGRect)contentViewFrame {
    return CGRectZero;
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];

    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = [self contentViewFrame];
}

#pragma mark - Getters and setters
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [LLFactory getView];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [LLFactory getView];
        _contentView.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_contentView LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
        [_contentView LL_setCornerRadius:5];
    }
    return _contentView;
}

@end
