//
//  LLEntryStyleModel.m
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

#import "LLEntryStyleModel.h"

#import "LLConfig.h"

@implementation LLEntryStyleModel

- (instancetype)initWithWindowStyle:(LLConfigEntryWindowStyle)windowStyle moveableRect:(CGRect)moveableRect frame:(CGRect)frame {
    if (self = [super init]) {
        _windowStyle = windowStyle;
        _moveableRect = moveableRect;
        _frame = frame;
        _moveable = YES;
        _inactiveAlpha = 1.0;
        switch (windowStyle) {
            case LLConfigEntryWindowStyleBall: {
                _overflow = YES;
                _inactiveAlpha = [LLConfig shared].inactiveAlpha;
            }
                break;
            case LLConfigEntryWindowStyleTitle: {
                _inactiveAlpha = [LLConfig shared].inactiveAlpha;
            }
                break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            case LLConfigEntryWindowStyleNetBar:
            case LLConfigEntryWindowStylePowerBar: {
                _moveable = NO;
            }
                break;
#pragma clang diagnostic pop
            default:
                break;
        }
    }
    return self;
}

@end
