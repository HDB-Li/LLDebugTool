//
//  LLHierarchyViewController.m
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

#import "LLHierarchyViewController.h"

#import "LLHierarchyDetailViewController.h"
#import "LLNavigationController.h"
#import "LLHierarchyInfoView.h"
#import "LLHierarchyPickerView.h"
#import "LLInternalMacros.h"
#import "LLWindowManager.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"
#import "LLTool.h"

#import "UIViewController+LL_Utils.h"
#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLHierarchyViewController ()<LLHierarchyPickerViewDelegate, LLHierarchyInfoViewDelegate>

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) LLHierarchyPickerView *pickerView;

@property (nonatomic, strong) LLHierarchyInfoView *infoView;

@property (nonatomic, strong) NSMutableSet *observeViews;

@property (nonatomic, strong) NSMutableDictionary *borderViews;

@end

@implementation LLHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.observeViews = [NSMutableSet set];
    self.borderViews = [[NSMutableDictionary alloc] init];
    
    CGFloat height = 100;
    self.infoView = [[LLHierarchyInfoView alloc] initWithFrame:CGRectMake(kLLGeneralMargin, LL_SCREEN_HEIGHT - kLLGeneralMargin * 2 - height, LL_SCREEN_WIDTH - kLLGeneralMargin * 2, height)];
    self.infoView.delegate = self;
    [self.view addSubview:self.infoView];
    
    [self.view addSubview:self.borderView];
    
    self.pickerView = [[LLHierarchyPickerView alloc] initWithFrame:CGRectMake((self.view.LL_width - 60) / 2.0, (self.view.LL_height - 60) / 2.0, 60, 60)];
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}

- (void)dealloc {
    for (UIView *view in self.observeViews) {
        [self stopObserveView:view];
    }
    [self.observeViews removeAllObjects];
}

#pragma mark - Primary
- (void)beginObserveView:(UIView *)view borderWidth:(CGFloat)borderWidth {
    if ([self.observeViews containsObject:view]) {
        return;
    }
    
    UIView *borderView = [LLFactory getView];
    borderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:borderView];
    [self.view sendSubviewToBack:borderView];
    [borderView LL_setBorderColor:view.LL_hashColor borderWidth:borderWidth];
    borderView.frame = [self frameInLocalForView:view];
    [self.borderViews setObject:borderView forKey:@(view.hash)];

    [view addObserver:self forKeyPath:@"frame" options:0 context:NULL];
}

- (void)stopObserveView:(UIView *)view {
    if (![self.observeViews containsObject:view]) {
        return;
    }
    
    UIView *borderView = self.borderViews[@(view.hash)];
    [borderView removeFromSuperview];
    [view removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)object;
        [self updateOverlayIfNeeded:view];
    }
}

- (void)updateOverlayIfNeeded:(UIView *)view {
    UIView *borderView = self.borderViews[@(view.hash)];
    if (borderView) {
        borderView.frame = [self frameInLocalForView:view];
    }
}

- (CGRect)frameInLocalForView:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect rect = [view convertRect:view.bounds toView:window];
    rect = [self.view convertRect:rect fromView:window];
    return rect;
}

- (UIView *)findSelectedViewInViews:(NSArray *)selectedViews {
    if ([LLConfig shared].isHierarchyIgnorePrivateClass) {
        NSMutableArray *views = [[NSMutableArray alloc] init];
        for (UIView *view in selectedViews) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        }
        return [views lastObject];
    } else {
        return [selectedViews lastObject];
    }
}

- (NSArray <UIView *>*)findParentViewsBySelectedView:(UIView *)selectedView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    UIView *view = [selectedView superview];
    while (view) {
        if ([LLConfig shared].isHierarchyIgnorePrivateClass) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        } else {
            [views addObject:view];
        }
        view = view.superview;
    }
    return [views copy];
}

- (NSArray <UIView *>*)findSubviewsBySelectedView:(UIView *)selectedView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *view in selectedView.subviews) {
        if ([LLConfig shared].isHierarchyIgnorePrivateClass) {
            if (![NSStringFromClass(view.class) hasPrefix:@"_"]) {
                [views addObject:view];
            }
        } else {
            [views addObject:view];
        }
    }
    return [views copy];
}

#pragma mark - LLHierarchyPickerViewDelegate
- (void)LLHierarchyPickerView:(LLHierarchyPickerView *)view didMoveTo:(NSArray <UIView *>*)selectedViews {
    
    @synchronized (self) {
        for (UIView *view in self.observeViews) {
            [self stopObserveView:view];
        }
        [self.observeViews removeAllObjects];
        
        for (NSInteger i = selectedViews.count - 1; i >= 0; i--) {
            UIView *view = selectedViews[i];
            CGFloat borderWidth = 1;
            if (i == selectedViews.count - 1) {
                borderWidth = 2;
            }
            [self beginObserveView:view borderWidth:borderWidth];
        }
        [self.observeViews addObjectsFromArray:selectedViews];
    }

    [self.infoView updateSelectedView:[self findSelectedViewInViews:selectedViews]];
}

#pragma mark - LLBaseInfoViewDelegate
- (void)LLInfoViewDidSelectCloseButton:(LLInfoView *)view {
    [self componentDidLoad:nil];
}

#pragma mark - LLHierarchyInfoViewDelegate
- (void)LLHierarchyInfoView:(LLHierarchyInfoView *)view didSelectAt:(LLHierarchyInfoViewAction)action {
    UIView *selectView = self.infoView.selectedView;
    if (selectView == nil) {
        [LLTool log:@"Failed to show hierarchy detail viewController"];
        return;
    }
    switch (action) {
        case LLHierarchyInfoViewActionShowMoreInfo:{
            [self showHierarchyInfo:selectView];
        }
            break;
        case LLHierarchyInfoViewActionShowParent: {
            [self showParentSheet:selectView];
        }
            break;
        case LLHierarchyInfoViewActionShowSubview: {
            [self showSubviewSheet:selectView];
        }
            break;
    }
}

- (void)showHierarchyInfo:(UIView *)selectView {
    LLHierarchyDetailViewController *vc = [[LLHierarchyDetailViewController alloc] init];
    vc.selectView = selectView;
    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showParentSheet:(UIView *)selectView {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSArray *parentViews = [self findParentViewsBySelectedView:selectView];
    for (UIView *view in parentViews) {
        [actions addObject:NSStringFromClass(view.class)];
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"hierarchy.parent") actions:actions currentAction:nil completion:^(NSInteger index) {
        [weakSelf setNewSelectView:parentViews[index]];
    }];
}

- (void)showSubviewSheet:(UIView *)selectView {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSArray *subviews = [self findSubviewsBySelectedView:selectView];
    for (UIView *view in subviews) {
        [actions addObject:NSStringFromClass(view.class)];
    }
    __weak typeof(self) weakSelf = self;
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"hierarchy.subview") actions:actions currentAction:nil completion:^(NSInteger index) {
        [weakSelf setNewSelectView:subviews[index]];
    }];
}

- (void)setNewSelectView:(UIView *)view {
    [self LLHierarchyPickerView:self.pickerView didMoveTo:@[view]];
}

#pragma mark - Getters and setters
- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [LLFactory getView];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderWidth = 2;
    }
    return _borderView;
}

@end
