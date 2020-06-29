//
//  LLEntryViewController.h
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

#import "LLBaseViewController.h"
#import "LLDebugConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class LLEntryViewController;
@class LLEntryStyleModel;
@class LLEntryAppInfoView;

/// Entry view controller delegate.
@protocol LLEntryViewControllerDelegate <NSObject>

/// Need update window frame.
/// @param viewController Current view controller.
/// @param style New style.
- (void)LLEntryViewController:(LLEntryViewController *)viewController style:(LLEntryStyleModel *)style;

/// Need update window size.
/// @param viewController Current view controller.
/// @param size New size.
- (void)LLEntryViewController:(LLEntryViewController *)viewController size:(CGSize)size;

@end

/// Entry view controller.
@interface LLEntryViewController : LLBaseViewController

@property (nonatomic, weak, nullable) id<LLEntryViewControllerDelegate> delegate;

// Style.
@property (nonatomic, assign, readonly) LLDebugConfigEntryWindowStyle style;

// AppInfo
@property (nonatomic, strong, readonly) LLEntryAppInfoView *appInfoView;

@end

NS_ASSUME_NONNULL_END
