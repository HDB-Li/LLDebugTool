//
//  LLEntryBallView.m
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

#import "LLEntryBallView.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"
#import "LLMacros.h"
#import "LLTool.h"

typedef NS_ENUM(NSUInteger, LLEntryBallViewDirection) {
    LLEntryBallViewDirectionLeft,
    LLEntryBallViewDirectionTop,
    LLEntryBallViewDirectionRight,
    LLEntryBallViewDirectionBottom
};

@interface LLEntryBallView ()

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, assign) BOOL statusBarClickable;

@end

@implementation LLEntryBallView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)updateOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:{
            self.logoImageView.transform = CGAffineTransformIdentity;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown: {
            self.logoImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            self.logoImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            self.logoImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        }
            break;
        default:
            break;
    }
}

- (void)viewDidUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeActive];
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
        [self resignActive:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Primary
- (void)initial {
    self.overflow = YES;
    self.moveable = [LLConfig shared].suspensionBallMoveable;
    self.statusBarClickable = [LLTool statusBarClickable];
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:2];
    [self LL_setCornerRadius:self.LL_width / 2];
    self.logoImageView = [LLFactory getImageView:self frame:CGRectMake(self.LL_width / 4.0, self.LL_height / 4.0, self.LL_width / 2.0, self.LL_height / 2.0) image:[UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor]];
    [self resignActive:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeManagerUpdatePrimaryColorNotificaion:) name:kThemeManagerUpdatePrimaryColorNotificaionName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeManagerUpdateBackgroundColorNotificaion:) name:kThemeManagerUpdateBackgroundColorNotificaionName object:nil];
}

- (void)becomeActive {
    self.alpha = [LLConfig shared].activeAlpha;
}

- (void)resignActive:(BOOL)animated {
    if (![LLConfig shared].isAutoAdjustSuspensionWindow) {
        self.alpha = [LLConfig shared].normalAlpha;
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self resetFrame];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self resetFrame];
    }
}

- (void)resetFrame {
    self.alpha = [LLConfig shared].normalAlpha;
    
    CGFloat top = self.LL_centerY;
    CGFloat left = self.LL_centerX;
    CGFloat right = LL_SCREEN_WIDTH - self.LL_centerX;
    CGFloat bottom = LL_SCREEN_HEIGHT - self.LL_centerY;
    CGFloat min = MIN(MIN(MIN(left, right), bottom), top);
    LLEntryBallViewDirection direction = LLEntryBallViewDirectionLeft;
    if (min == right) {
        direction = LLEntryBallViewDirectionRight;
    } else if (min == bottom) {
        direction = LLEntryBallViewDirectionBottom;
    } else if (min == top) {
        if (self.statusBarClickable) {
            direction = LLEntryBallViewDirectionTop;
        } else {
            min = MIN(MIN(left, right), bottom);
            if (min == right) {
                direction = LLEntryBallViewDirectionRight;
            } else if (min == bottom) {
                direction = LLEntryBallViewDirectionBottom;
            }
        }
    }
    
    CGPoint endPoint = self.center;
    switch (direction) {
        case LLEntryBallViewDirectionLeft: {
            endPoint.x = self.LL_width / 2.0 - [LLConfig shared].suspensionWindowHideWidth;
            if (!self.statusBarClickable) {
                endPoint.y = MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
        }
            break;
        case LLEntryBallViewDirectionTop: {
            endPoint.y = self.LL_height / 2.0 - [LLConfig shared].suspensionWindowHideWidth;
        }
            break;
        case LLEntryBallViewDirectionRight: {
            endPoint.x = LL_SCREEN_WIDTH - self.LL_width / 2.0 + [LLConfig shared].suspensionWindowHideWidth;
            if (!self.statusBarClickable) {
                endPoint.y = MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
        }
            break;
        case LLEntryBallViewDirectionBottom: {
            endPoint.y = LL_SCREEN_HEIGHT - self.LL_height / 2.0 + [LLConfig shared].suspensionWindowHideWidth;
        }
            break;
        default:
            break;
    }
    
    self.center = endPoint;
}

#pragma mark - NSNotification
- (void)didReceiveThemeManagerUpdatePrimaryColorNotificaion:(NSNotification *)notification {
    self.layer.borderColor = [LLThemeManager shared].primaryColor.CGColor;
    self.logoImageView.image = [UIImage LL_imageNamed:kLogoImageName color:[LLThemeManager shared].primaryColor];
}

- (void)didReceiveThemeManagerUpdateBackgroundColorNotificaion:(NSNotification *)notification {
    self.backgroundColor = [LLThemeManager shared].backgroundColor;
}

@end
