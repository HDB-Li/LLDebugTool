//
//  LLBaseWindow.m
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

#import "LLBaseWindow.h"

#import "LLBaseViewController.h"
#import "LLConst.h"

#import "UIWindow+LL_Utils.h"

@interface LLBaseWindow ()

@property (nonatomic, assign, getter=isShow) BOOL show;

@end

@implementation LLBaseWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = kLLNormalWindowLevel;
        self.layer.masksToBounds = YES;
#ifdef __IPHONE_13_0
        if (@available(iOS 13.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUISceneWillConnectNotification:) name:UISceneWillConnectNotification object:nil];
        }
#endif
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidShow {
    self.show = YES;
    UIViewController *vc = self.rootViewController;
    if ([vc isKindOfClass:[LLBaseViewController class]]) {
        LLBaseViewController *viewController = (LLBaseViewController *)vc;
        [viewController windowDidShow];
    }
}

- (void)windowDidHide {
    self.show = NO;
    UIViewController *vc = self.rootViewController;
    if ([vc isKindOfClass:[LLBaseViewController class]]) {
        LLBaseViewController *viewController = (LLBaseViewController *)vc;
        [viewController windowDidHide];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIViewController *vc = [self LL_currentShowingViewController];
    if ([vc isKindOfClass:[LLBaseViewController class]]) {
        LLBaseViewController *viewController = (LLBaseViewController *)vc;
        return [viewController pointInside:point withEvent:event];
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - UISceneWillConnectNotification
#ifdef __IPHONE_13_0
- (void)didReceiveUISceneWillConnectNotification:(NSNotification *)notification {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *scene = notification.object;
        if (![scene isKindOfClass:[UIWindowScene class]]) {
            return;
        }
        self.windowScene = scene;
    }
}
#endif

@end
