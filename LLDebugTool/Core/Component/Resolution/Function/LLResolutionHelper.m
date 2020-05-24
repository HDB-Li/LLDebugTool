//
//  LLResolutionHelper.m
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

#import "LLResolutionHelper.h"

#import "LLResolutionModel.h"
#import "LLTool.h"

#import "UIScreen+LL_Resolution.h"

static LLResolutionHelper *_instance = nil;

@interface LLResolutionHelper ()

@property (nonatomic, strong) LLResolutionModel *model;

@property (nonatomic, assign) LLResolutionStyle realStyle;

@end

@implementation LLResolutionHelper

#pragma mark - Public
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLResolutionHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (CGRect)bounds {
    return CGRectMake(0, 0, _model.size.width, _model.size.height);
}

- (CGFloat)scale {
    return _model.scale;
}

- (BOOL)addResolutionStatusBarView {
    if (self.mockStyle == LLResolutionStyleInvalid || self.realStyle == LLResolutionStyleInvalid) {
        return NO;
    }
    if ([self isSpecialScreen:self.mockStyle] != [self isSpecialScreen:self.realStyle]) {
        return YES;
    }
    return NO;
}

- (CGFloat)resolutionStatusBarViewHeight {
    if ([self isSpecialScreen:self.mockStyle]) {
        return 44;
    }
    return 20;
}

#pragma mark - Primary
- (void)initial {
    _realStyle = [self styleFromSize:[UIScreen mainScreen].LL_realBounds.size scale:[UIScreen mainScreen].LL_realScale];
    if (_realStyle == LLResolutionStyleInvalid) {
        [LLTool log:@"Unknown real style, try to fix it."];
    }
    NSInteger style = [LLTool resolutionStyle];
    if (style > LLResolutionStyleIPhoneXR) {
        style = LLResolutionStyleInvalid;
        [LLTool setResolutionStyle:style];
    }
    _mockStyle = style;
    if (style != LLResolutionStyleInvalid) {
        self.model = [[LLResolutionModel alloc] initWithStyle:style];
    }
    if (_realStyle != LLResolutionStyleInvalid && style != LLResolutionStyleInvalid) {
        LLResolutionModel *realModel = [[LLResolutionModel alloc] initWithStyle:_realStyle];
        _horizontalPadding = (realModel.size.width - self.model.size.width) / 2.0;
        _verticalPadding = (realModel.size.height - self.model.size.height) / 2.0;
    }
}

- (LLResolutionStyle)styleFromSize:(CGSize)size scale:(CGFloat)scale {
    if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
        if (scale == 2) {
            return LLResolutionStyleIPhone4;
        }
        return LLResolutionStyleInvalid;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
        if (scale == 2) {
            return LLResolutionStyleIPhoneSE;
        }
        return LLResolutionStyleInvalid;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
        if (scale == 2) {
            return LLResolutionStyleIPhone6;
        }
        return LLResolutionStyleInvalid;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
        if (scale == 3) {
            return LLResolutionStyleIPhone6Plus;
        }
        return LLResolutionStyleInvalid;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
        if (scale == 3) {
            return LLResolutionStyleIPhoneX;
        }
        return LLResolutionStyleInvalid;
    }

    if (CGSizeEqualToSize(size, CGSizeMake(414, 896))) {
        if (scale == 3) {
            return LLResolutionStyleIPhoneXSMax;
        } else if (scale == 2) {
            return LLResolutionStyleIPhoneXR;
        }
        return LLResolutionStyleInvalid;
    }

    return LLResolutionStyleInvalid;
}

- (BOOL)isSpecialScreen:(LLResolutionStyle)style {
    if (style >= LLResolutionStyleIPhoneX) {
        return YES;
    }
    return NO;
}

#pragma mark - Getters and setters
- (NSArray<NSNumber *> *)availableResolutions {
    if (!_availableResolutions) {
        _availableResolutions = @[@(LLResolutionStyleIPhone4), @(LLResolutionStyleIPhoneSE), @(LLResolutionStyleIPhone6), @(LLResolutionStyleIPhone6Plus), @(LLResolutionStyleIPhoneX), @(LLResolutionStyleIPhoneXSMax), @(LLResolutionStyleIPhoneXR)];
    }
    return _availableResolutions;
}

- (void)setMockStyle:(LLResolutionStyle)mockStyle {
    _mockStyle = mockStyle;
    [LLTool setResolutionStyle:mockStyle];
}

@end
