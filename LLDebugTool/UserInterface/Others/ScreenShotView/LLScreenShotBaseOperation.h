//
//  LLScreenShotBaseOperation.h
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
#import <UIKit/UIKit.h>
#import "LLScreenShotSelectorModel.h"
#import "LLScreenShotDefine.h"

@interface LLScreenShotBaseOperation : NSObject

@property (nonatomic , assign , readonly) LLScreenShotAction action;

@property (nonatomic , assign , readonly) LLScreenShotSelectorAction size;

@property (nonatomic , assign , readonly) LLScreenShotSelectorAction color;

@property (nonatomic , strong , readonly) CAShapeLayer *layer;

- (instancetype)initWithSelector:(LLScreenShotSelectorModel *)selector action:(LLScreenShotAction)action;

/**
 Subclasses need to be rewritten.
 */
- (void)drawImageView:(CGRect)rect;

@end

@interface LLScreenShotRectOperation : LLScreenShotBaseOperation

// CGPoint
@property (nonatomic , strong) NSValue *startValue;

// CGPoint
@property (nonatomic , strong) NSValue *endValue;

@end

@interface LLScreenShotRoundOperation : LLScreenShotBaseOperation

// CGPoint
@property (nonatomic , strong) NSValue *startValue;

// CGPoint
@property (nonatomic , strong) NSValue *endValue;

@end

@interface LLScreenShotArrowOperation : LLScreenShotBaseOperation

// CGPoint
@property (nonatomic , strong) NSValue *startValue;

// CGPoint
@property (nonatomic , strong) NSValue *endValue;

@end

@interface LLScreenShotPenOperation : LLScreenShotBaseOperation

// CGPoint
@property (nonatomic , strong) NSMutableArray <NSValue *>*values;

- (void)addValue:(NSValue *)value;

@end
