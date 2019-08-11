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
#import "LLFactory.h"

static LLThemeManager *_instance = nil;

@interface LLThemeManager ()

@property (nonatomic, strong) UIColor *systemTintColor;

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

- (void)setPrimaryColor:(UIColor * _Nonnull)primaryColor {
    if (_primaryColor != primaryColor) {
        _primaryColor = primaryColor;
        [self calculateColorIfNeeded];
    }
}

- (void)setBackgroundColor:(UIColor * _Nonnull)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        [self calculateColorIfNeeded];
    }
}

#pragma mark - Primary
- (void)initial {
    // Get system tint color.
    if ([[NSThread currentThread] isMainThread]) {
        _systemTintColor = [LLFactory getView].tintColor;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.systemTintColor = [LLFactory getView].tintColor;
        });
    }
    _primaryColor = [UIColor blackColor];
    _backgroundColor = [UIColor whiteColor];
    [self calculateColorIfNeeded];
    _primaryColorItems = [NSHashTable weakObjectsHashTable];
}

- (void)calculateColorIfNeeded {
    if (_primaryColor == nil || _backgroundColor == nil) {
        return;
    }
    
    _containerColor = [_backgroundColor LL_mixtureWithColor:_primaryColor radio:0.1];
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
