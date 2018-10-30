//
//  LLWindowActionView.m
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

#import "LLWindowActionView.h"
#import "UIImage+LL_Utils.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"
#import "LLButton.h"

@interface LLWindowActionView ()

@property (nonatomic , strong) LLButton *viewButton;

@property (nonatomic , strong) LLButton *selectButton;

@property (nonatomic , strong) LLButton *moveButton;

@property (nonatomic , strong) LLButton *closeButton;

@end

@implementation LLWindowActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

#pragma mark - Actions
- (void)viewButtonTouchUpInside:(UIButton *)sender {
    [self.delegate LLWindowActionViewDidSelectMoveButton:self];
}

- (void)selectButtonTouchUpInside:(UIButton *)sender {
    [self.delegate LLWindowActionViewDidSelectSelectButton:self];
}

- (void)moveButtonTouchUpInside:(UIButton *)sender {
    [self.delegate LLWindowActionViewDidSelectMoveButton:self];
}

- (void)closeButtonTouchUpInside:(UIButton *)sender {
    [self.delegate LLWindowActionViewDidSelectCloseButton:self];
}

#pragma mark - Primary
- (void)initial {
    self.alpha = [LLConfig sharedConfig].normalAlpha;
    self.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    self.layer.borderWidth = 2;
    self.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    [self addSubview:self.viewButton];
    [self addSubview:self.selectButton];
    [self addSubview:self.moveButton];
    [self addSubview:self.closeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat gap = 4;
    CGFloat itemWidth = self.frame.size.width / 4.0 - gap;
    CGFloat itemHeight = self.frame.size.height - gap;
    NSArray *buttons = @[self.viewButton,self.selectButton,self.moveButton,self.closeButton];
    for (int i = 0; i < buttons.count; i++) {
        UIButton *btn = buttons[i];
        btn.frame = CGRectMake(gap / 2.0 + (itemWidth + gap) * i, gap / 2.0, itemWidth, itemHeight);
    }
}

- (LLButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    return [LLButton buttonWithTitle:title image:[[UIImage LL_imageNamed:imageName size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] font:[UIFont systemFontOfSize:11] color:LLCONFIG_TEXT_COLOR];
}

#pragma mark - Lazy
- (LLButton *)viewButton {
    if (!_viewButton) {
        _viewButton = [self buttonWithTitle:@"Views" imageName:kPickImageName];
    }
    return _viewButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [self buttonWithTitle:@"Select" imageName:kPickImageName];
    }
    return _selectButton;
}

- (UIButton *)moveButton {
    if (!_moveButton) {
        _moveButton = [self buttonWithTitle:@"Move" imageName:kPickImageName];
    }
    return _moveButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [self buttonWithTitle:@"Close" imageName:kPickImageName];
    }
    return _closeButton;
}

@end
