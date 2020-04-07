//
//  LLScreenshotActionView.m
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

#import "LLScreenshotActionView.h"

#import "LLConst.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"

#import "UIView+LL_Utils.h"

@interface LLScreenshotActionView ()

@property (nonatomic, strong) UIButton *lastSelectButton;

@end

@implementation LLScreenshotActionView

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case LLScreenshotActionRect:
        case LLScreenshotActionRound:
        case LLScreenshotActionLine:
        case LLScreenshotActionPen:
        case LLScreenshotActionText: {
            if (self.lastSelectButton != sender) {
                self.lastSelectButton.selected = NO;
                sender.selected = YES;
                self.lastSelectButton = sender;
            } else {
                sender.selected = NO;
                self.lastSelectButton = nil;
            }
        } break;
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(LLScreenshotActionView:didSelectedAction:isSelected:position:)]) {
        CGFloat position = sender.frame.origin.x + sender.frame.size.width / 2.0;
        [_delegate LLScreenshotActionView:self didSelectedAction:sender.tag isSelected:sender.isSelected position:position];
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self LL_setCornerRadius:5];
    [self addButtons];
}

#pragma mark - Primary
- (void)addButtons {
    LLScreenshotAction count = LLScreenshotActionConfirm;
    CGFloat gap = kLLGeneralMargin;
    CGFloat itemWidth = (self.frame.size.width - gap * 2) / count;
    CGFloat itemHeight = self.frame.size.height;
    CGFloat top = (self.frame.size.height - itemHeight) / 2.0;

    for (LLScreenshotAction i = LLScreenshotActionRect; i <= count; i++) {
        UIButton *button = [self buttonWithImageName:[self imageNameWithAction:i] selectImageName:[self selectImageNameWithAction:i] tag:i];
        button.frame = CGRectMake(gap + (i - 1) * itemWidth, top, itemWidth, itemHeight);
    }
}

- (UIButton *)buttonWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName tag:(NSInteger)tag {
    UIButton *button = [LLFactory getButton:self frame:CGRectZero target:self action:@selector(buttonClicked:)];
    [button setImage:[UIImage LL_imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage LL_imageNamed:selectImageName] forState:UIControlStateSelected];
    button.tag = tag;
    button.showsTouchWhenHighlighted = NO;
    return button;
}

- (NSString *)imageNameWithAction:(LLScreenshotAction)action {
    switch (action) {
        case LLScreenshotActionRect:
            return kRectImageName;
        case LLScreenshotActionRound:
            return kRoundImageName;
        case LLScreenshotActionLine:
            return kLineImageName;
        case LLScreenshotActionPen:
            return kPenImageName;
        case LLScreenshotActionText:
            return kTextImageName;
        case LLScreenshotActionBack:
            return kUndoImageName;
        case LLScreenshotActionCancel:
            return kCancelImageName;
        case LLScreenshotActionConfirm:
            return kSureImageName;
        default:
            break;
    }
    return @"";
}

- (NSString *)selectImageNameWithAction:(LLScreenshotAction)action {
    switch (action) {
        case LLScreenshotActionRect:
            return kRectSelectImageName;
        case LLScreenshotActionRound:
            return kRoundSelectImageName;
        case LLScreenshotActionLine:
            return kLineSelectImageName;
        case LLScreenshotActionPen:
            return kPenSelectImageName;
        case LLScreenshotActionText:
            return kTextSelectImageName;
        case LLScreenshotActionBack:
            return kUndoDisableImageName;
        case LLScreenshotActionCancel:
            return kCancelImageName;
        case LLScreenshotActionConfirm:
            return kSureImageName;
        default:
            break;
    }
    return @"";
}

@end
