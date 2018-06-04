//
//  LLScreenShotActionView.m
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

#import "LLScreenShotActionView.h"
#import "LLImageNameConfig.h"

@interface LLScreenShotActionView ()

@property (nonatomic , strong , nullable) UIButton *lastSelectButton;

@end

@implementation LLScreenShotActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case LLScreenShotActionRect:
        case LLScreenShotActionRound:
        case LLScreenShotActionLine:
        case LLScreenShotActionPen:
        case LLScreenShotActionText:{
            if (self.lastSelectButton != sender) {
                self.lastSelectButton.selected = NO;
                sender.selected = YES;
                self.lastSelectButton = sender;
            } else {
                sender.selected = NO;
                self.lastSelectButton = nil;
            }
        }
            break;
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(LLScreenShotActionView:didSelectedAction:isSelected:position:)]) {
        CGFloat position = sender.frame.origin.x + sender.frame.size.width / 2.0;
        [_delegate LLScreenShotActionView:self didSelectedAction:sender.tag isSelected:sender.isSelected position:position];
    }
}

#pragma mark - Primary
- (void)initial {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    int count = 8;
    CGFloat gap = 10;
    CGFloat itemWidth = (self.frame.size.width - gap * 2) / count;
    CGFloat itemHeight = self.frame.size.height;
    CGFloat top = (self.frame.size.height - itemHeight) / 2.0;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(gap + i * itemWidth, top, itemWidth, itemHeight);
        NSString *imageName = @"";
        NSString *selectImageName = @"";
        switch (i) {
            case LLScreenShotActionRect:{
                imageName = kRectImageName;
                selectImageName = kRectSelectImageName;
                break;
            }
            case LLScreenShotActionRound:{
                imageName = kRoundImageName;
                selectImageName = kRoundSelectImageName;
                break;
            }
            case LLScreenShotActionLine:{
                imageName = kLineImageName;
                selectImageName = kLineSelectImageName;
                break;
            }
            case LLScreenShotActionPen:{
                imageName = kPenImageName;
                selectImageName = kPenSelectImageName;
                break;
            }
            case LLScreenShotActionText:{
                imageName = kTextImageName;
                selectImageName = kTextSelectImageName;
                break;
            }
            case LLScreenShotActionBack:{
                imageName = kUndoImageName;
                selectImageName = kUndoDisableImageName;
                break;
            }
            case LLScreenShotActionCancel:{
                imageName = kCancelImageName;
                selectImageName = kCancelImageName;
                break;
            }
            case LLScreenShotActionConfirm:{
                imageName = kSureImageName;
                selectImageName = kSureImageName;
                break;
            }
            default:
                break;
        }
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
        button.tag = i;
        button.showsTouchWhenHighlighted = NO;
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

@end
