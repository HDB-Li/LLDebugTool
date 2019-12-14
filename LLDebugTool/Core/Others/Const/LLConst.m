//
//  LLConst.m
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

#import "LLConst.h"

CGFloat const kLLEntryWindowBallWidth = 50;
CGFloat const kLLEntryWindowMinBallWidth = 30;
CGFloat const kLLEntryWindowMaxBallWidth = 70;
CGFloat const kLLEntryWindowDisplayPercent = 1 - 0.618;// Golden section search.
CGFloat const kLLEntryWindowMinDisplayPercent = 0.1;
CGFloat const kLLEntryWindowMaxDisplayPercent = 1;
CGFloat const kLLEntryWindowFirstDisplayPositionX = 0;
CGFloat const kLLEntryWindowFirstDisplayPositionY = 200;
CGFloat const kLLInactiveAlpha = 0.75;
CGFloat const kLLActiveAlpha = 1.0;
CGFloat const kLLEntryWindowBigTitleViewHeight = 30;

NSInteger const kLLMagnifierWindowZoomLevel = 10;
NSInteger const kLLMagnifierWindowMinZoomLevel = 6;
NSInteger const kLLMagnifierWindowMaxZoomLevel = 14;
NSInteger const kLLMagnifierWindowSize = 15;
NSInteger const kLLMagnifierWindowMinSize = 9;
NSInteger const kLLMagnifierWindowMaxSize = 21;

CGFloat const kLLRulerLineWidth = 1;

CGFloat const kLLWidgetBorderWidth = 1;

CGFloat const kLLGeneralMargin = 10;

double const kLLDefaultMockLocationLatitude = 39.908722;
double const kLLDefaultMockLocationLongitude = 116.397499;
NSTimeInterval const kLLDefaultMockRouteTimeInterval = 2;
