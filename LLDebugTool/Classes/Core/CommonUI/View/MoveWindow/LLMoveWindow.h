//
//  LLMoveWindow.h
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

#import "LLComponentWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMoveWindow : LLComponentWindow

/// Whether over flow.
@property (nonatomic, assign, getter=isOverflow) BOOL overflow;

/// Whether is moved.
@property (nonatomic, assign, readonly, getter=isMoved) BOOL moved;

/// Whether moveable.
@property (nonatomic, assign, getter=isMoveable) BOOL moveable;

/// Moveable range.
@property (nonatomic, assign) CGRect moveableRect;

/// Will move.
/// @param sender Sender
/// @param offsetPoint Point.
- (void)viewWillUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint;

/// Did move
/// @param sender Sender
/// @param offsetPoint Point.
- (void)viewDidUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint;

@end

NS_ASSUME_NONNULL_END
