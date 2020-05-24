//
//  LLResolutionModel.m
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

#import "LLResolutionModel.h"

@implementation LLResolutionModel

- (instancetype)initWithStyle:(LLResolutionStyle)style {
    if (self = [super init]) {
        if (style == LLResolutionStyleInvalid) {
            return nil;
        }
        _size = [self sizeWithStyle:style];
        _scale = [self scaleWithStyle:style];
        _name = [self nameWithStyle:style];
    }
    return self;
}

#pragma mark - Primary
- (CGSize)sizeWithStyle:(LLResolutionStyle)style {
    switch (style) {
        case LLResolutionStyleIPhone4:
            return CGSizeMake(320, 480);
        case LLResolutionStyleIPhoneSE:
            return CGSizeMake(320, 568);
        case LLResolutionStyleIPhone6:
            return CGSizeMake(375, 667);
        case LLResolutionStyleIPhone6Plus:
            return CGSizeMake(414, 736);
        case LLResolutionStyleIPhoneX:
            return CGSizeMake(375, 812);
        case LLResolutionStyleIPhoneXSMax:
        case LLResolutionStyleIPhoneXR:
            return CGSizeMake(414, 896);
        default:
            break;
    }
    return CGSizeZero;
}

- (CGFloat)scaleWithStyle:(LLResolutionStyle)style {
    switch (style) {
        case LLResolutionStyleIPhone4:
        case LLResolutionStyleIPhoneSE:
        case LLResolutionStyleIPhone6:
        case LLResolutionStyleIPhoneXR:
            return 2;
        case LLResolutionStyleIPhone6Plus:
        case LLResolutionStyleIPhoneX:
        case LLResolutionStyleIPhoneXSMax:
            return 3;
        default:
            break;
    }
    return 0;
}

- (NSString *)nameWithStyle:(LLResolutionStyle)style {
    switch (style) {
        case LLResolutionStyleIPhone4:
            return @"iPhone 4/4s/5/5s/5c";
        case LLResolutionStyleIPhoneSE:
            return @"iPhone SE";
        case LLResolutionStyleIPhone6:
            return @"iPhone 6/6s/7/8";
        case LLResolutionStyleIPhone6Plus:
            return @"iPhone 6p/6sp/7p/8p";
        case LLResolutionStyleIPhoneX:
            return @"iPhone X/XS/11 Pro";
        case LLResolutionStyleIPhoneXSMax:
            return @"iPhone XS Max/11 Pro Max";
        case LLResolutionStyleIPhoneXR:
            return @"iPhone XR/11";
        default:
            break;
    }
    return nil;
}

@end
