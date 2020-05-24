//
//  LLHierarchyBorderView.m
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

#import "LLHierarchyBorderView.h"
#import "LLFactory.h"

#import "LLTool.h"
#import "NSObject+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLHierarchyBorderView ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIView *> *views;

@property (nonatomic, strong) UIView *previewView;

@property (nonatomic, assign) BOOL isInHiddenMode;

@end

@implementation LLHierarchyBorderView

#pragma mark - Public
- (void)reloadDataWithViews:(NSArray<UIView *> *)views {
    [self clearViews];
    for (UIView *view in views) {
        [self drawView:view];
    }
    self.isInHiddenMode = NO;
    [self bringSubviewToFront:self.previewView];
}

- (void)updatePreview:(UIView *)view {
    self.previewView.layer.borderWidth = 1;
    self.previewView.backgroundColor = nil;
    if (self.isInHiddenMode) {
        self.previewView.hidden = YES;
    }
    self.previewView = self.views[@(view.hash)];
    self.previewView.layer.borderWidth = 3;
    if (self.isInHiddenMode) {
        self.previewView.hidden = NO;
    }
    self.previewView.backgroundColor = [[UIColor colorWithCGColor:self.previewView.layer.borderColor] colorWithAlphaComponent:0.3];
    [self bringSubviewToFront:self.previewView];
}

- (void)updateOverlayIfNeeded:(UIView *)view {
    UIView *borderView = self.views[@(view.hash)];
    if (borderView) {
        borderView.frame = [self frameInLocalForView:view];
    }
}

- (void)hideAllSubviews {
    self.isInHiddenMode = YES;
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
}

- (void)showAllSubviews {
    self.isInHiddenMode = NO;
    for (UIView *view in self.subviews) {
        view.hidden = NO;
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.views = [[NSMutableDictionary alloc] init];
}

#pragma mark - Primary
- (void)drawView:(UIView *)view {
    NSNumber *hash = @(view.hash);
    if (self.views[hash]) {
        return;
    }

    UIColor *hashColor = view.LL_hashColor;
    UIView *borderView = [LLFactory getView];
    [self addSubview:borderView];
    if (view == [self.dataSource selectedViewInLLHierarchyBorderView:self]) {
        borderView.backgroundColor = [hashColor colorWithAlphaComponent:0.3];
        [borderView LL_setBorderColor:hashColor borderWidth:3];
        self.previewView = borderView;
    } else {
        borderView.backgroundColor = nil;
        [borderView LL_setBorderColor:hashColor borderWidth:1];
    }
    borderView.frame = [self frameInLocalForView:view];

    [self.views setObject:borderView forKey:hash];
}

- (void)clearViews {
    for (UIView *view in self.views.allValues) {
        [view removeFromSuperview];
    }
    [self.views removeAllObjects];
}

- (CGRect)frameInLocalForView:(UIView *)view {
    UIWindow *window = [LLTool delegateWindow];
    CGRect rect = [view convertRect:view.bounds toView:window];
    rect = [self convertRect:rect fromView:window];
    return rect;
}

@end
