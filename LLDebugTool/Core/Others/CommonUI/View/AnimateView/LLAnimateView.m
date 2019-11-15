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

#import "LLInternalMacros.h"
#import "LLFactory.h"

#import "UIView+LL_Utils.h"

@interface LLAnimateView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation LLAnimateView

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {

    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

#pragma mark - Public
- (void)show {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
    [window addSubview:self];
    self.alpha = 0;
    self.LL_top = LL_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.LL_top = 0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.LL_top = LL_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    
    [self addSubview:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, self.LL_height - self.contentView.LL_height - LL_BOTTOM_DANGER_HEIGHT, self.LL_width, self.contentView.LL_height);
}

#pragma mark - Getters and setters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [LLFactory getView];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
