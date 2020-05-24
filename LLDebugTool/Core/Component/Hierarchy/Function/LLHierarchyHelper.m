//
//  LLHierarchyHelper.m
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

#import "LLHierarchyHelper.h"

#import <UIKit/UIKit.h>

#import "LLBaseWindow.h"
#import "LLDebugConfig.h"
#import "LLTool.h"

static LLHierarchyHelper *_instance = nil;

@implementation LLHierarchyHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLHierarchyHelper alloc] init];
    });
    return _instance;
}

- (NSArray<UIWindow *> *)allWindows {
    return [self allWindowsIgnoreClass:nil];
}

- (NSArray<UIWindow *> *)allWindowsIgnoreClass:(Class)cls {
    BOOL includeInternalWindows = YES;
    BOOL onlyVisibleWindows = NO;

    SEL allWindowsSelector = NSSelectorFromString(@"allWindowsIncludingInternalWindows:onlyVisibleWindows:");

    NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];

    invocation.target = [UIWindow class];
    invocation.selector = allWindowsSelector;
    [invocation setArgument:&includeInternalWindows atIndex:2];
    [invocation setArgument:&onlyVisibleWindows atIndex:3];
    [invocation invoke];

    __unsafe_unretained NSArray<UIWindow *> *windows = nil;
    [invocation getReturnValue:&windows];

    windows = [windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *obj1, UIWindow *obj2) {
        return obj1.windowLevel > obj2.windowLevel;
    }];

    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:windows];
    NSMutableArray *removeResults = [[NSMutableArray alloc] init];
    if (cls != nil) {
        for (UIWindow *window in results) {
            if ([window isKindOfClass:cls]) {
                [removeResults addObject:window];
            }
        }
    }
    [results removeObjectsInArray:removeResults];

    return [NSArray arrayWithArray:results];
}

- (BOOL)isPrivateClassView:(UIView *)view {
    return view ? [NSStringFromClass(view.class) hasPrefix:@"_"] : NO;
}

- (NSArray<UIView *> *)findParentViewsByView:(UIView *)view {
    if (!view) {
        return @[];
    }
    NSMutableArray *views = [[NSMutableArray alloc] init];
    [views addObject:view];
    UIView *selectedView = view.superview;
    while (selectedView) {
        if (![LLDebugConfig shared].isHierarchyIgnorePrivateClass || ![self isPrivateClassView:selectedView]) {
            [views addObject:selectedView];
        }
        selectedView = selectedView.superview;
    }
    return [views copy];
}

- (NSArray<UIView *> *)findSubviewsByView:(UIView *)view {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *selectedView in view.subviews) {
        if (![LLDebugConfig shared].isHierarchyIgnorePrivateClass || ![self isPrivateClassView:selectedView]) {
            [views addObject:selectedView];
        }
    }
    return [views copy];
}

- (NSArray<UIView *> *)viewForSelectionAtPoint:(CGPoint)tapPointInWindow {
    // Select in the window that would handle the touch, but don't just use the result of hitTest:withEvent: so we can still select views with interaction disabled.
    // Default to the the application's key window if none of the windows want the touch.
    UIWindow *windowForSelection = [LLTool keyWindow];
    for (UIWindow *window in [[self allWindowsIgnoreClass:[LLBaseWindow class]] reverseObjectEnumerator]) {
        if ([window hitTest:tapPointInWindow withEvent:nil]) {
            windowForSelection = window;
            break;
        }
    }

    // Select the deepest visible view at the tap point. This generally corresponds to what the user wants to select.
    return [self recursiveSubviewsAtPoint:tapPointInWindow inView:windowForSelection skipHiddenViews:YES includeParent:[LLDebugConfig shared].isIncludeParent];
}

#pragma mark - Primary
- (NSArray<UIView *> *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view skipHiddenViews:(BOOL)skipHidden includeParent:(BOOL)includeParent {
    NSMutableArray<UIView *> *subviewsAtPoint = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (skipHidden && isHidden) {
            continue;
        }

        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (includeParent && subviewContainsPoint) {
            if (![LLDebugConfig shared].isHierarchyIgnorePrivateClass || ![self isPrivateClassView:subview]) {
                [subviewsAtPoint addObject:subview];
            }
        }
        // If this view doesn't clip to its bounds, we need to check its subviews even if it doesn't contain the selection point.
        // They may be visible and contain the selection point.
        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            NSArray *array = [self recursiveSubviewsAtPoint:pointInSubview inView:subview skipHiddenViews:skipHidden includeParent:includeParent];
            if (array.count || includeParent) {
                [subviewsAtPoint addObjectsFromArray:array];
            } else if (subviewContainsPoint) {
                if (![LLDebugConfig shared].isHierarchyIgnorePrivateClass || ![self isPrivateClassView:subview]) {
                    [subviewsAtPoint addObject:subview];
                }
            }
        }
    }
    return subviewsAtPoint;
}

@end
