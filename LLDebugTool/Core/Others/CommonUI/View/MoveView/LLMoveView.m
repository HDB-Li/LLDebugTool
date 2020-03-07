//
//  LLMoveView.m
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

#import "LLMoveView.h"

#import "LLInternalMacros.h"

#import "UIView+LL_Utils.h"

@interface LLMoveView ()

@property (nonatomic, assign) BOOL moved;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation LLMoveView

- (void)initUI {
    [super initUI];
    _moveable = YES;
    _moveableRect = CGRectNull;
    // Pan, to moveable.
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    if (!self.isMoved) {
        self.moved = YES;
    }
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [self viewWillUpdateOffset:sender offset:offsetPoint];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
    
    [self viewDidUpdateOffset:sender offset:offsetPoint];
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = self.center;
    center.x += point.x;
    center.y += point.y;
    
    if (self.isOverflow) {
        center = [self adjustOverflow:center];
    } else {
        center = [self adjustCenter:center];
    }
    
    center = [self adjustMoveableRect:center];
    
    self.center = center;
}

- (void)viewWillUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
}

- (void)viewDidUpdateOffset:(UIPanGestureRecognizer *)sender offset:(CGPoint)offsetPoint {
    
}

#pragma mark - Primary
- (void)setMoveable:(BOOL)moveable {
    if (_moveable != moveable) {
        _moveable = moveable;
        self.panGestureRecognizer.enabled = moveable;
    }
}

- (CGPoint)adjustOverflow:(CGPoint)center {
    CGPoint newCenter = CGPointMake(center.x, center.y);
    newCenter.x = MIN(newCenter.x, self.superview.LL_width);
    newCenter.x = MAX(newCenter.x, 0);
    
    newCenter.y = MIN(newCenter.y, self.superview.LL_height);
    newCenter.y = MAX(newCenter.y, 0);
    
    return newCenter;
}

- (CGPoint)adjustCenter:(CGPoint)center {
    CGPoint newCenter = CGPointMake(center.x, center.y);
    
    if (newCenter.x < self.LL_width / 2.0) {
        newCenter.x = self.LL_width / 2.0;
    } else if (newCenter.x > self.superview.LL_width - self.LL_width / 2.0) {
        newCenter.x = self.superview.LL_width - self.LL_width / 2.0;
    }
    
    if (newCenter.y < self.LL_height / 2.0) {
        newCenter.y = self.LL_height / 2.0;
    } else if (newCenter.y > self.superview.LL_height - self.LL_height / 2.0) {
        newCenter.y = self.superview.LL_height - self.LL_height / 2.0;
    }
    
    return newCenter;
}

- (CGPoint)adjustMoveableRect:(CGPoint)center {
    CGPoint newCenter = CGPointMake(center.x, center.y);
    
    if (!CGRectIsNull(_moveableRect) && !CGRectContainsPoint(_moveableRect, newCenter)) {
        if (newCenter.x < _moveableRect.origin.x) {
            newCenter.x = _moveableRect.origin.x;
        } else if (newCenter.x > _moveableRect.origin.x + _moveableRect.size.width) {
            newCenter.x = _moveableRect.origin.x + _moveableRect.size.width;
        }
        
        if (newCenter.y < _moveableRect.origin.y) {
            newCenter.y = _moveableRect.origin.y;
        } else if (newCenter.y > _moveableRect.origin.y + _moveableRect.size.height) {
            newCenter.y = _moveableRect.origin.y + _moveableRect.size.height;
        }
    }
    return newCenter;
}

@end
