//
//  LLHierarchySheetView.h
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

#import "LLAnimateView.h"

NS_ASSUME_NONNULL_BEGIN

@class LLHierarchySheetView;

@protocol LLHierarchySheetViewDelegate <NSObject>

@optional

/// Did select cancel.
/// @param sheetView LLHierarchySheetView.
- (void)LLHierarchySheetViewDidSelectCancel:(LLHierarchySheetView *)sheetView;

/// Did select confirm.
/// @param sheetView LLHierarchySheetView.
/// @param view Selected view.
- (void)LLHierarchySheetView:(LLHierarchySheetView *)sheetView didSelectAtView:(UIView *)view;

/// Did preview view.
/// @param sheetView LLHierarchySheetView.
/// @param view Preview view.
- (void)LLhierarchySheetView:(LLHierarchySheetView *)sheetView didPreviewAtView:(UIView *)view;

@end

@interface LLHierarchySheetView : LLAnimateView

/// Delegate.
@property (nonatomic, weak, nullable) id<LLHierarchySheetViewDelegate> delegate;

/// Show with data.
/// @param data Data.
- (void)showWithData:(nullable NSArray<UIView *> *)data index:(NSInteger)index;

#pragma mark - UNAVAILABLE
- (void)show NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
