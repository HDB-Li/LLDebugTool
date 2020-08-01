//
//  LLHierarchyInfoSwitchModel.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LLHierarchyInfoSwitchModel;

@protocol LLHierarchyInfoSwitchModelDelegate <NSObject>

- (void)hierarchyInfoSwitchModel:(LLHierarchyInfoSwitchModel *)model didUpdateStatus:(BOOL)isOn;

@end

@interface LLHierarchyInfoSwitchModel : NSObject

/// Delegate.
@property (nonatomic, weak, nullable) id<LLHierarchyInfoSwitchModelDelegate> delegate;

/// Title.
@property (nonatomic, copy) NSAttributedString *title;

/// Switch status.
@property (nonatomic, assign, getter=isOn) BOOL on;

/// Whether is enable.
@property (nonatomic, assign, getter=isEnable) BOOL enable;

/// Value change block.
@property (nonatomic, copy, nullable) void (^changePropertyBlock)(BOOL isOn);

/// Initial method.
/// @param title Title.
+ (instancetype)modelWithTitle:(NSAttributedString *)title on:(BOOL)isOn block:(nullable void (^)(BOOL isOn))block;

@end

NS_ASSUME_NONNULL_END
