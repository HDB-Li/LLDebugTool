//
//  LLHierarchyBorderView.h
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

#import "LLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class LLHierarchyBorderView;

@protocol LLHierarchyBorderViewDataSource <NSObject>

// Current selected view.
- (UIView *_Nullable)selectedViewInLLHierarchyBorderView:(LLHierarchyBorderView *)view;

@end

/// Visiable border view.
@interface LLHierarchyBorderView : LLBaseView

/// Data source.
@property (nonatomic, weak, nullable) id<LLHierarchyBorderViewDataSource> dataSource;

///// Reload data.
///// @param observeViews New observe views.
///// @param originObserveViews Origin observe views.
//- (void)reloadDataWithObserveViews:(NSArray<UIView *> *_Nullable)observeViews originObserveViews:(NSArray<UIView *> *_Nullable)originObserveViews;

/// Reload data.
- (void)reloadDataWithViews:(NSArray<UIView *> *)views;

/// Update preview.
/// @param view View.
- (void)updatePreview:(UIView *)view;

/// Update view frame.
/// @param view View.
- (void)updateOverlayIfNeeded:(UIView *)view;

/// Enter hide mode.
- (void)hideAllSubviews;

/// Exit hide mode.
- (void)showAllSubviews;

@end

NS_ASSUME_NONNULL_END
