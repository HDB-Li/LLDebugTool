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

#import "LLComponentHelper.h"
#import "LLDebugConfig.h"
#import "LLEntryStyleModel.h"
#import "LLEntryViewController.h"
#import "LLFunctionItemModel.h"
#import "LLInternalMacros.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"
#import "UIWindow+LL_Utils.h"

typedef NS_ENUM(NSUInteger, LLEntryWindowDirection) {
    LLEntryWindowDirectionLeft,
    LLEntryWindowDirectionRight
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
        LLEntryViewController *viewController = [[LLEntryViewController alloc] init];
        viewController.delegate = self;
        self.rootViewController = viewController;

        self.statusBarClickable = [LLTool statusBarClickable];

        // Double tap, to screenshot.
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
        doubleTap.numberOfTapsRequired = 2;

        // Tap, to show tool view.
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
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

- (void)windowDidShow {
    [super windowDidShow];
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
    [LLComponentHelper executeAction:[LLDebugConfig shared].clickAction data:nil];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)sender {
    [self animatedBecomeActive];
    [LLComponentHelper executeAction:[LLDebugConfig shared].doubleClickAction data:nil];
}

#pragma mark - Primary
- (void)becomeActive {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(shrinkToEdgeWhenInactiveIfNeeded) object:nil];
    self.active = YES;
    self.alpha = [LLDebugConfig shared].activeAlpha;
}

- (void)animatedBecomeActive {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(shrinkToEdgeWhenInactiveIfNeeded) object:nil];
    self.active = YES;
    self.alpha = [LLDebugConfig shared].activeAlpha;
    if (!self.moveable) {
        return;
    }
    if (!self.styleModel.isShrinkToEdgeWhenInactive) {
        return;
    }

    [UIView animateWithDuration:0.25
        animations:^{
            switch (self.direction) {
                case LLEntryWindowDirectionLeft: {
                    self.LL_left = 0;
                } break;
                case LLEntryWindowDirectionRight: {
                    self.LL_right = LL_SCREEN_WIDTH;
                } break;
            }
        }
        completion:^(BOOL finished){

        }];
}

- (void)resignActive:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5
            delay:0
            usingSpringWithDamping:0.5
            initialSpringVelocity:2.0
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                [self resetFrame];
            }
            completion:^(BOOL finished){

            }];
    } else {
        [self resetFrame];
    }
}

- (void)resetFrame {
    if (!self.isMoveable) {
        return;
    }
    LLEntryWindowDirection direction = self.LL_centerX <= LL_SCREEN_WIDTH - self.LL_centerX ? LLEntryWindowDirectionLeft : LLEntryWindowDirectionRight;

    CGPoint endPoint = self.center;
    switch (direction) {
        case LLEntryWindowDirectionLeft: {
            endPoint.x = self.LL_width / 2.0;
            if (!self.statusBarClickable) {
                endPoint.y = LL_MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
            if (LL_IS_SPECIAL_SCREEN) {
                endPoint.y = LL_MIN(LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - self.LL_height / 2.0, endPoint.y);
            }
        } break;
        case LLEntryWindowDirectionRight: {
            endPoint.x = LL_SCREEN_WIDTH - self.LL_width / 2.0;
            if (!self.statusBarClickable) {
                endPoint.y = LL_MAX(LL_STATUS_BAR_HEIGHT + self.LL_height / 2.0, endPoint.y);
            }
            if (LL_IS_SPECIAL_SCREEN) {
                endPoint.y = LL_MIN(LL_SCREEN_HEIGHT - LL_BOTTOM_DANGER_HEIGHT - self.LL_height / 2.0, endPoint.y);
            }
        } break;
    }
    self.direction = direction;
    self.center = endPoint;
    [self performSelector:@selector(shrinkToEdgeWhenInactiveIfNeeded) withObject:nil afterDelay:2];
}

- (void)shrinkToEdgeWhenInactiveIfNeeded {
    self.alpha = self.styleModel.inactiveAlpha;
    self.active = NO;
    if (!self.styleModel.isShrinkToEdgeWhenInactive) {
        return;
    }
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25
        animations:^{
            switch (self.direction) {
                case LLEntryWindowDirectionLeft: {
                    self.LL_right = [LLDebugConfig shared].entryWindowDisplayPercent * self.LL_width;
                } break;
                case LLEntryWindowDirectionRight: {
                    self.LL_left = LL_SCREEN_WIDTH - [LLDebugConfig shared].entryWindowDisplayPercent * self.LL_width;
                } break;
            }
        }
        completion:^(BOOL finished) {
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

- (void)LLEntryViewController:(LLEntryViewController *)viewController size:(CGSize)size {
    self.LL_size = size;
    if (!self.isActive) {
        [self resetFrame];
    }
}

@end
