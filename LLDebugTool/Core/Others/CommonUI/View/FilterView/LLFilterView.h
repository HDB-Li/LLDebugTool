//
//  LLFilterView.h
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

/// Filter view.
@interface LLFilterView : LLBaseView

/// Filter titles.
@property (nonatomic, strong) NSArray <NSString *>*titles;

/// Filter views.
@property (nonatomic, strong) NSArray <UIView *>*filterViews;

/// Filter change state.
@property (nonatomic, copy, nullable) void(^filterChangeStateBlock)(void);

/// Is filtering.
- (BOOL)isFiltering;

/// Cancel filter.
- (void)cancelFiltering;

/// Update filter count.
/// @param filterView Filter button
/// @param count Count.
- (void)updateFilterButton:(UIView *)filterView count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
