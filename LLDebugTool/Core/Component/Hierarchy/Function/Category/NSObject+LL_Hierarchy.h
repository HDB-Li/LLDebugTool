//
//  NSObject+LL_Hierarchy.h
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

#import <UIKit/UIKit.h>

@class LLTitleCellCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LL_Hierarchy)

/// Models, subclass rewrite if needed.
- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels;

#pragma mark - Show Alert
- (void)LL_showIntAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showDoubleAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showColorAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showFontAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showPointAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showSizeAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showEdgeInsetsAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showDateAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;
- (void)LL_showAttributeTextAlertAndAutomicSetWithKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
