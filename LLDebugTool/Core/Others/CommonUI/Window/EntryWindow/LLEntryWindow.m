//
//  LLEntryWindow.m
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

#import "LLEntryWindow.h"

#import "LLEntryViewController.h"
#import "LLFunctionItemModel.h"
#import "LLEntryStyleModel.h"
#import "LLInternalMacros.h"
#import "LLConfig.h"
#import "LLTool.h"

#import "UIWindow+LL_Utils.h"
#import "UIView+LL_Utils.h"

typedef NS_ENUM(NSUInteger, LLEntryWindowDirection) {
    LLEntryWindowDirectionLeft,
    LLEntryWindowDirectionRight,
    LLEntryWindowDirectionTop,
    LLEntryWindowDirectionBottom
};

@interface LLEntryWindow () <LLEntryViewControllerDelegate>

@property (nonatomic, assign, getter=isActive) BOOL active;

@property (nonatomic, assign) BOOL statusBarClickable;

@property (nonatomic, assign) LLEntryWindowDirection direction;

@property (nonatomic, strong) LLEntryStyleModel *styleModel;

@end

@implementation LLEntryWindow

#pragma mark - Over write
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (!self.rootViewController) {
            LLEntryViewController *viewController = [[LLEntryViewController alloc] init];
            viewController.delegate = self;
            self.rootViewController = viewController;
        }
        
        self.statusBarClickable = [LLTool statusBarClickable];
        
        // Double tap, to screenshot.
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
        doubleTap.numberOfTapsRequired = 2;
        
        // Tap, to show tool view.
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (BOOL)LL_canBecomeKeyWindow {
    return NO;
}

- (void)becomeKeyWindow {
    [self resignKeyWindow];
}

- (void)becomeVisiable {
    [super becomeVisiable];
    [self resignActive:NO];
}

- (void)viewDidUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeActive];
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
        [self resignActive:YES];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point)) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

#pragma mark - Events
- (void)tapGR:(UITapGestureRecognizer *)sender {
    [self animatedBecomeActive];
    [[[LLFunctionItemModel alloc] initWithAction:[LLConfig shared].clickAction].component componentDidLoad:nil];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
    [self animatedBecomeActive];
    [[[LLFunctionItemModel alloc] initWithAction:[LLConfig shared].doubleClickAction].component componentDidLoad:nil];
}

#pragma mark - Primary
- (void)becomeActive {
    self.active = YES;
    self.alpha = [LLConfig shared].activeAlpha;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)animatedBecomeActive {
    self.active = YES;
    self.alpha = [LLConfig shared].activeAlpha;
    if (!self.moveable) {
        return;
    }
    if (![LLConfig shared].isShrinkToEdgeWhenInactive) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        switch (self.direction) {
            case LLEntryWindowDirectionLeft:{
                self.LL_left = 0;
            }
                break;
            case LLEntryWindowDirectionRight: {
                self.LL_right = LL_SCREEN_WIDTH;
            }
                break;
            case LLEntryWindowDirectionTop: {
                self.LL_top = 0;
            }
                break;
            case LLEntryWindowDirectionBottom: {
                self.LL_bottom = LL_SCREEN_HEIGHT;
            }
                break;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)resignActive:(BOOL)animated {
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
    if (!self.isMoveable) {
        return;
    }
    CGFloat top = self.LL_centerY;
    CGFloat left = self.LL_centerX;
    CGFloat right = LL_SCREEN_WIDTH - self.LL_centerX;
    CGFloat bottom = LL_SCREEN_HEIGHT - self.LL_centerY;
    CGFloat min = MIN(MIN(MIN(left, right), bottom), top);
    LLEntryWindowDirection direction = LLEntryWindowDirectionLeft;
    if (min == right) {
        direction = LLEntryWindowDirectionRight;
    } else if (min == bottom) {
        direction = LLEntryWindowDirectionBottom;
    } else if (min == top) {
        if (self.statusBarClickable) {
            direction = LLEntryWindowDirectionTop;
        } else {
            min = MIN(MIN(left, right), bottom);
            if (min == right) {
                direction = LLEntryWindowDirectionRight;
            } else if (min == bottom) {
                direction = LLEntryWindowDirectionBottom;
            }
        }
    }
    
    CGPoint endPoint = self.center;
    switch (direction) {
        case LLEntryWindowDirectionLeft: {
            endPoint.x = self.LL_width / 2.0;
            if (!self.statusBarClickable) {
                endPoint.y = MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
        }
            break;
        case LLEntryWindowDirectionTop: {
            endPoint.y = self.LL_height / 2.0;
        }
            break;
        case LLEntryWindowDirectionRight: {
            endPoint.x = LL_SCREEN_WIDTH - self.LL_width / 2.0;
            if (!self.statusBarClickable) {
                endPoint.y = MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
        }
            break;
        case LLEntryWindowDirectionBottom: {
            endPoint.y = LL_SCREEN_HEIGHT - self.LL_height / 2.0;
        }
            break;
    }
    self.direction = direction;
    self.center = endPoint;
    [self performSelector:@selector(shrinkToEdgeWhenInactiveIfNeeded) withObject:nil afterDelay:2];
}

- (void)shrinkToEdgeWhenInactiveIfNeeded {
    self.alpha = self.styleModel.inactiveAlpha;
    self.active = NO;
    if (![LLConfig shared].isShrinkToEdgeWhenInactive) {
        return;
    }
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        switch (self.direction) {
            case LLEntryWindowDirectionLeft: {
                self.LL_right = [LLConfig shared].entryWindowDisplayPercent * self.LL_width;
            }
                break;
            case LLEntryWindowDirectionTop: {
                self.LL_bottom = [LLConfig shared].entryWindowDisplayPercent * self.LL_height;
            }
                break;
            case LLEntryWindowDirectionRight: {
                self.LL_left = LL_SCREEN_WIDTH - [LLConfig shared].entryWindowDisplayPercent * self.LL_width;
            }
                break;
            case LLEntryWindowDirectionBottom: {
                self.LL_top = LL_SCREEN_HEIGHT - [LLConfig shared].entryWindowDisplayPercent * self.LL_height;
            }
                break;
        }
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark - LLEntryViewControllerDelegate
- (void)LLEntryViewController:(LLEntryViewController *)viewController style:(LLEntryStyleModel *)style {
    self.frame = style.frame;
    self.styleModel = style;
    self.overflow = style.overflow;
    self.moveable = style.moveable;
    self.moveableRect = style.moveableRect;
}

@end
