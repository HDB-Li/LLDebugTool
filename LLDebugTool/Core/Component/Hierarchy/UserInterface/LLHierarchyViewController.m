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

#import "LLConst.h"
#import "LLFactory.h"
#import "LLHierarchyBorderView.h"
#import "LLHierarchyDetailViewController.h"
#import "LLHierarchyHelper.h"
#import "LLHierarchyInfoView.h"
#import "LLHierarchyPickerView.h"
#import "LLHierarchySheetView.h"
#import "LLInternalMacros.h"
#import "LLNavigationController.h"
#import "LLThemeManager.h"
#import "LLTool.h"
#import "LLWindowManager.h"

#import "NSArray+LL_Utils.h"
#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

@interface LLHierarchyViewController () <LLHierarchyPickerViewDelegate, LLHierarchyInfoViewDelegate, LLHierarchyInfoViewDataSource, LLHierarchySheetViewDelegate, LLHierarchyBorderViewDataSource>

@property (nonatomic, strong) LLHierarchyPickerView *pickerView;

@property (nonatomic, strong) LLHierarchyInfoView *infoView;

@property (nonatomic, strong) LLHierarchySheetView *sheetView;

@property (nonatomic, strong) LLHierarchyBorderView *borderView;

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) NSMutableArray<UIView *> *observeViews;

@end

@implementation LLHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.observeViews = [[NSMutableArray alloc] init];

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:self.borderView];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.pickerView];
}

- (void)dealloc {
    [self stopObserve];
}

#pragma mark - LLHierarchyPickerViewDelegate
- (void)LLHierarchyPickerView:(LLHierarchyPickerView *)view didMoveTo:(NSArray<UIView *> *)selectedViews {
    [self loadData:selectedViews];
}

#pragma mark - LLBaseInfoViewDelegate
- (void)LLInfoViewDidSelectCloseButton:(LLInfoView *)view {
    [self componentDidFinish];
}

#pragma mark - LLHierarchyInfoViewDelegate
- (void)LLHierarchyInfoView:(LLHierarchyInfoView *)view didSelectAt:(LLHierarchyInfoViewAction)action {
    UIView *selectView = self.selectedView;
    if (selectView == nil) {
        [LLTool log:@"Failed to show hierarchy detail viewController"];
        return;
    }
    switch (action) {
        case LLHierarchyInfoViewActionShowMoreInfo: {
            [self showHierarchyInfo:selectView];
        } break;
        case LLHierarchyInfoViewActionShowParent: {
            [self showParentSheet:selectView];
        } break;
        case LLHierarchyInfoViewActionShowLevel: {
            [self showSameLevelSheet:selectView];
        } break;
        case LLHierarchyInfoViewActionShowSubview: {
            [self showSubviewSheet:selectView];
        } break;
    }
}

- (void)showSameLevelSheet:(UIView *)selectView {
    self.infoView.hidden = YES;
    NSInteger index = [self.observeViews indexOfObject:selectView];
    if (index == NSNotFound) {
        index = 0;
    }
    [self.borderView hideAllSubviews];
    [self.borderView updatePreview:selectView];
    [self.sheetView showWithData:self.observeViews index:index];
}

- (void)showParentSheet:(UIView *)selectView {
    self.infoView.hidden = YES;
    NSArray *parentViews = [[LLHierarchyHelper shared] findParentViewsByView:selectView];
    [self.borderView hideAllSubviews];
    [self.borderView reloadDataWithViews:parentViews];
    [self.sheetView showWithData:parentViews index:0];
}

- (void)showSubviewSheet:(UIView *)selectView {
    self.infoView.hidden = YES;
    NSArray *subviews = [[LLHierarchyHelper shared] findSubviewsByView:selectView];
    [self.borderView hideAllSubviews];
    [self.borderView reloadDataWithViews:subviews];
    [self.sheetView showWithData:subviews index:0];
}

#pragma mark - LLHierarchyInfoViewDataSource
- (UIView *)displayViewInLLHierarchyInfoView:(LLHierarchyInfoView *)view {
    return self.selectedView;
}

- (BOOL)LLHierarchyInfoView:(LLHierarchyInfoView *)view canClickAtAction:(LLHierarchyInfoViewAction)action {
    switch (action) {
        case LLHierarchyInfoViewActionShowParent: {
            return [[LLHierarchyHelper shared] findParentViewsByView:self.selectedView].count > 1;
        }
        case LLHierarchyInfoViewActionShowSubview: {
            return [[LLHierarchyHelper shared] findSubviewsByView:self.selectedView].count > 0;
        }
        case LLHierarchyInfoViewActionShowLevel: {
            return self.observeViews.count > 1;
        }
        case LLHierarchyInfoViewActionShowMoreInfo: {
            return self.selectedView;
        }
        default:
            break;
    }
    return NO;
}

- (void)showHierarchyInfo:(UIView *)selectView {
    LLHierarchyDetailViewController *vc = [[LLHierarchyDetailViewController alloc] init];
    vc.selectView = selectView;
    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LLHierarchySheetViewDelegate
- (void)LLHierarchySheetViewDidSelectCancel:(LLHierarchySheetView *)sheetView {
    [self.borderView reloadDataWithViews:self.observeViews];
    [self.sheetView hide];
    self.infoView.hidden = NO;
}

- (void)LLHierarchySheetView:(LLHierarchySheetView *)sheetView didSelectAtView:(UIView *)view {
    self.selectedView = view;
    if (![self.observeViews containsObject:view]) {
        [self loadData:@[view]];
    } else {
        [self.borderView reloadDataWithViews:self.observeViews];
    }
    [self.sheetView hide];
    self.infoView.hidden = NO;
}

- (void)LLhierarchySheetView:(LLHierarchySheetView *)sheetView didPreviewAtView:(UIView *)view {
    [self.borderView updatePreview:view];
}

#pragma mark - LLHierarchyBorderViewDataSource
- (UIView *)selectedViewInLLHierarchyBorderView:(LLHierarchyBorderView *)view {
    return self.selectedView;
}

#pragma mark - Observes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)object;
        [self.borderView updateOverlayIfNeeded:view];
    }
}

#pragma mark - Primary
- (void)loadData:(NSArray *)data {
    if ([self.observeViews isEqualToArray:data]) {
        return;
    }

    // Stop observe.
    [self stopObserve];

    // Data
    [self.observeViews removeAllObjects];
    [self.observeViews addObjectsFromArray:[[data reverseObjectEnumerator] allObjects]];

    // Start observe.
    [self startObserve];

    self.selectedView = [self findBestViewInData:data];

    [self.borderView reloadDataWithViews:self.observeViews];
}

- (void)startObserve {
    for (UIView *view in self.observeViews) {
        [view addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    }
}

- (void)stopObserve {
    for (UIView *view in self.observeViews) {
        [view removeObserver:self forKeyPath:@"frame"];
    }
}

- (UIView *)findBestViewInData:(NSArray<UIView *> *)data {
    for (UIView *view in data) {
        if ([[LLHierarchyHelper shared] hasTextPropertyInClass:view.class]) {
            return view;
        }
    }
    return data.firstObject;
}

#pragma mark - Getters and setters
- (LLHierarchyInfoView *)infoView {
    if (!_infoView) {
        CGFloat height = 100;
        _infoView = [[LLHierarchyInfoView alloc] initWithFrame:CGRectMake(kLLGeneralMargin, LL_SCREEN_HEIGHT - kLLGeneralMargin * 2 - height, LL_SCREEN_WIDTH - kLLGeneralMargin * 2, height)];
        _infoView.delegate = self;
        _infoView.dataSource = self;
    }
    return _infoView;
}

- (LLHierarchyPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[LLHierarchyPickerView alloc] initWithFrame:CGRectMake((self.view.LL_width - 60) / 2.0, (self.view.LL_height - 60) / 2.0, 60, 60)];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (LLHierarchySheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [[LLHierarchySheetView alloc] init];
        _sheetView.delegate = self;
    }
    return _sheetView;
}

- (LLHierarchyBorderView *)borderView {
    if (!_borderView) {
        _borderView = [[LLHierarchyBorderView alloc] initWithFrame:self.view.bounds];
        _borderView.dataSource = self;
    }
    return _borderView;
}

- (void)setSelectedView:(UIView *)selectedView {
    if (_selectedView != selectedView) {
        _selectedView = selectedView;
        [self.infoView reloadData];
    }
}

@end
