//
//  LLThemeManager.m
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

#import "LLThemeManager.h"
#import "UIColor+LL_Utils.h"
#import "LLConfig.h"

static LLThemeManager *_instance = nil;

@interface LLThemeManager ()

@property (nonatomic, strong) NSHashTable *primaryColorItems;

@end

@implementation LLThemeManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLThemeManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

#pragma mark - Primary
- (void)initial {
    _primaryColor = LLCONFIG_TEXT_COLOR;
    _backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    _containerColor = [LLCONFIG_BACKGROUND_COLOR LL_mixtureWithColor:LLCONFIG_TEXT_COLOR radio:0.1];
    _primaryColorItems = [NSHashTable weakObjectsHashTable];
}

- (void)addPrimaryColorObject:(id)object {
    if ([object isKindOfClass:[CALayer class]]) {
        CALayer *layer = (CALayer *)object;
        layer.borderColor = self.primaryColor.CGColor;
    }
    @synchronized (self) {
        [self.primaryColorItems addObject:object];
    }
}

@end
