//
//  LLSuspensionWindow.m
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

#import "LLSuspensionWindow.h"
#import "UIView+LL_Utils.h"
#import "LLConfig.h"
#import "LLDebugTool.h"
#import "LLScreenshotHelper.h"
#import "LLMacros.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "LLConst.h"
#import "LLThemeManager.h"

@interface LLSuspensionWindow ()

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation LLSuspensionWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat logoImageViewWidth = [LLConfig sharedConfig].suspensionBallWidth / 2;
    CGRect logoImageViewRect = CGRectMake((self.LL_width - logoImageViewWidth) / 2, (self.LL_height - logoImageViewWidth) / 2, logoImageViewWidth, logoImageViewWidth);
    if (!CGRectEqualToRect(self.logoImageView.frame, logoImageViewRect)) {
        self.logoImageView.frame = logoImageViewRect;
    }
}

#pragma mark - Primary
- (void)initial {
    if (!self.rootViewController) {
        self.rootViewController = [[UIViewController alloc] init];
    }
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    [self LL_setCornerRadius:self.LL_width / 2];
    
    self.logoImageView = [LLFactory getImageView:self frame:CGRectZero image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
        
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    if ([LLConfig sharedConfig].suspensionBallMoveable) {
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGPoint point = [sender locationInView:window];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
            [self becomeActive];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            [self changeFrameWithPoint:point];
        } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
            [self resignActive];
        }
    }
}

- (void)tapGR:(UITapGestureRecognizer *)sender {
    [_delegate llSuspensionWindow:self didTapAt:1];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
    [_delegate llSuspensionWindow:self didTapAt:2];
}

- (void)becomeActive {
    self.alpha = [LLConfig sharedConfig].activeAlpha;
}

- (void)resignActive {
    if (![LLConfig sharedConfig].isAutoAdjustSuspensionWindow) {
        return;
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = [LLConfig sharedConfig].normalAlpha;
        // Calculate End Point
        CGFloat x = self.LL_centerX;
        CGFloat y = self.LL_centerY;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
        
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.LL_width / 2.0 + [LLConfig sharedConfig].suspensionWindowHideWidth;
            } else {
                // to left
                endPoint.x = self.LL_width / 2.0 - [LLConfig sharedConfig].suspensionWindowHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.LL_height / 2.0 + [LLConfig sharedConfig].suspensionWindowHideWidth;
            } else {
                // to top
                endPoint.y = self.LL_height / 2.0 - [LLConfig sharedConfig].suspensionWindowHideWidth;
            }
        }
        self.center = endPoint;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = point;
    
    center.x = MIN(center.x, LL_SCREEN_WIDTH);
    center.x = MAX(center.x, 0);
    
    center.y = MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = MAX(center.y, 0);
    
    self.center = center;
}


@end
