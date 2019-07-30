//
//  LLHierarchyPickerWindow.m
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

#import "LLHierarchyPickerWindow.h"
#import "UIView+LL_Utils.h"
#import "LLConfig.h"
#import "LLFactory.h"
#import "LLMacros.h"

@interface LLHierarchyPickerWindow ()

@property (nonatomic, strong) UIView *pointView;

@end

@implementation LLHierarchyPickerWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect pointRect = CGRectMake((self.LL_width - 16) / 2.0, (self.LL_height - 16) / 2.0, 16, 16);
    if (!CGRectEqualToRect(self.pointView.frame, pointRect)) {
        self.pointView.frame = pointRect;
    }
}

#pragma mark - Primary
- (void)initial {
    self.layer.cornerRadius = self.LL_height / 2.0;
    self.layer.borderWidth = 2;
    self.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    
    self.pointView = [LLFactory getView:self frame:CGRectZero backgroundColor:LLCONFIG_TEXT_COLOR];
    self.pointView.layer.cornerRadius = 16 / 2.0;
    self.pointView.layer.borderWidth = 0.5;
    self.pointView.layer.borderColor = LLCONFIG_BACKGROUND_COLOR.CGColor;
    self.pointView.layer.masksToBounds = YES;
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = self.center;
    center.x += point.x;
    center.y += point.y;
    
    center.x = MIN(center.x, LL_SCREEN_WIDTH);
    center.x = MAX(center.x, 0);
    
    center.y = MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = MAX(center.y, 0);
    
    self.center = center;
}

@end
