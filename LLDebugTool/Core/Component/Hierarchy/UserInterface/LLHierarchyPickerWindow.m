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
#import "LLHierarchyHelper.h"
#import "LLWindowManager.h"

@interface LLHierarchyPickerWindow ()

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIView *borderView;

@end

@implementation LLHierarchyPickerWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
- (void)initial {
    
    self.borderView = [LLFactory getView:self frame:CGRectZero backgroundColor:[UIColor clearColor]];
    self.borderView.layer.borderWidth = 2;
    self.borderView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    
    self.circleView = [LLFactory getView:self frame:CGRectMake((self.LL_width - 60) / 2.0, (self.LL_height - 60) / 2.0, 60, 60) backgroundColor:[UIColor clearColor]];
    self.circleView.layer.cornerRadius = 60 / 2.0;
    self.circleView.layer.borderWidth = 2;
    self.circleView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    
    UIView *pointView = [LLFactory getView:self.circleView frame:CGRectMake((self.circleView.LL_width - 16) / 2.0, (self.circleView.LL_height - 16) / 2.0, 16, 16) backgroundColor:LLCONFIG_TEXT_COLOR];
    pointView.layer.cornerRadius = 16 / 2.0;
    pointView.layer.borderWidth = 0.5;
    pointView.layer.borderColor = LLCONFIG_BACKGROUND_COLOR.CGColor;
    pointView.layer.masksToBounds = YES;
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self.circleView addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            self.circleView.alpha = [LLConfig sharedConfig].activeAlpha;
            break;
        default:
            self.circleView.alpha = [LLConfig sharedConfig].normalAlpha;
            break;
    }
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIView *view = [self viewForSelectionAtPoint:self.circleView.center];
    
    CGRect rect = [view convertRect:view.bounds toView:window];
    
    rect = [self convertRect:rect fromView:window];
    
    self.borderView.frame = rect;
    
    [[LLWindowManager shared].hierarchyInfoWindow updateView:view];
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = self.circleView.center;
    center.x += point.x;
    center.y += point.y;
    
    center.x = MIN(center.x, LL_SCREEN_WIDTH);
    center.x = MAX(center.x, 0);
    
    center.y = MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = MAX(center.y, 0);
    
    self.circleView.center = center;
}

- (UIView *)viewForSelectionAtPoint:(CGPoint)tapPointInWindow
{
    // Select in the window that would handle the touch, but don't just use the result of hitTest:withEvent: so we can still select views with interaction disabled.
    // Default to the the application's key window if none of the windows want the touch.
    UIWindow *windowForSelection = [[UIApplication sharedApplication] keyWindow];
    for (UIWindow *window in [[[LLHierarchyHelper sharedHelper] allWindowsIgnoreClass:[LLBaseWindow class]] reverseObjectEnumerator]) {
        if ([window hitTest:tapPointInWindow withEvent:nil]) {
            windowForSelection = window;
            break;
        }
    }
    
    // Select the deepest visible view at the tap point. This generally corresponds to what the user wants to select.
    return [[self recursiveSubviewsAtPoint:tapPointInWindow inView:windowForSelection skipHiddenViews:YES] lastObject];
}

- (NSArray<UIView *> *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view skipHiddenViews:(BOOL)skipHidden
{
    NSMutableArray<UIView *> *subviewsAtPoint = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (skipHidden && isHidden) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
        }
        
        // If this view doesn't clip to its bounds, we need to check its subviews even if it doesn't contain the selection point.
        // They may be visible and contain the selection point.
        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview skipHiddenViews:skipHidden]];
        }
    }
    return subviewsAtPoint;
}

@end
