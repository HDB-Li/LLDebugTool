//
//  LLEntryStyleModel.h
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

#import "LLBaseModel.h"

#import <UIKit/UIKit.h>

#import "LLConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLEntryStyleModel : LLBaseModel

@property (nonatomic, assign) LLConfigEntryWindowStyle windowStyle;

/// Whether over flow.
@property (nonatomic, assign, getter=isOverflow) BOOL overflow;

/// Whether moveable.
@property (nonatomic, assign, getter=isMoveable) BOOL moveable;

/// Moveable range.
@property (nonatomic, assign) CGRect moveableRect;

/// Inactive alpha.
@property (nonatomic, assign) CGFloat inactiveAlpha;

/// Origin frame.
@property (nonatomic, assign) CGRect frame;

/// Initial method
/// @param windowStyle Window style.
/// @param moveableRect Moveable rect.
/// @param frame Origin frame.
- (instancetype)initWithWindowStyle:(LLConfigEntryWindowStyle)windowStyle moveableRect:(CGRect)moveableRect frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
