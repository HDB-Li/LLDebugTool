//
//  LLComponent.m
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

#import "LLComponent.h"

#import "LLComponentHelper.h"
#import "LLInternalMacros.h"
#import "LLNavigationController.h"
#import "LLToastUtils.h"
#import "LLWindowManager.h"

LLComponentDelegateKey const LLComponentDelegateRootViewControllerKey = @"LLComponentWindowRootViewControllerKey";
LLComponentDelegateKey const LLComponentDelegateRootViewControllerNeedNavigationKey = @"LLComponentDelegateRootViewControllerNeedNavigationKey";
LLComponentDelegateKey const LLComponentDelegateRootViewControllerPropertiesKey = @"LLComponentWindowRootViewControllerPropertiesKey";

@implementation LLComponent

#pragma mark - LLComponentDelegate
+ (BOOL)componentDidLoad:(NSDictionary<LLComponentDelegateKey, id> *)data {
    NSDictionary *targetData = data;
    if ([self respondsToSelector:@selector(isValid)] && ![self isValid]) {
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"component.invalid")];
        return NO;
    }
    if ([self respondsToSelector:@selector(verificationData:)]) {
        targetData = [self verificationData:data];
    }
    LLBaseWindow *visibleWindow = [[LLWindowManager shared] visibleWindow];
    Class cls = nil;
    if ([self respondsToSelector:@selector(baseViewController)]) {
        cls = [self baseViewController];
    }
    if (cls && [visibleWindow isKindOfClass:[LLFunctionWindow class]]) {
        UIViewController *viewController = [[cls alloc] init];
        if (![viewController isKindOfClass:[UIViewController class]]) {
            return NO;
        }
        LLNavigationController *nav = (LLNavigationController *)visibleWindow.rootViewController;
        [nav pushViewController:viewController animated:YES];
    } else {
        LLBaseWindow *window = self.baseWindow;
        if (!window) {
            return NO;
        }
        if (targetData[LLComponentDelegateRootViewControllerKey]) {
            Class rootViewControllerClass = NSClassFromString(targetData[LLComponentDelegateRootViewControllerKey]);
            if (rootViewControllerClass != nil) {
                UIViewController *viewController = [[rootViewControllerClass alloc] init];
                if ([targetData[LLComponentDelegateRootViewControllerNeedNavigationKey] boolValue]) {
                    window.rootViewController = [[LLNavigationController alloc] initWithRootViewController:viewController];
                } else {
                    window.rootViewController = viewController;
                }
            }
        }
        if (targetData[LLComponentDelegateRootViewControllerPropertiesKey]) {
            NSDictionary *properties = targetData[LLComponentDelegateRootViewControllerPropertiesKey];
            UIViewController *rootViewController = window.rootViewController;
            if ([rootViewController isKindOfClass:[UINavigationController class]]) {
                rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
            }
            for (NSString *key in properties) {
                id value = properties[key];
                [rootViewController setValue:value forKey:key];
            }
        }
        [[LLWindowManager shared] showWindow:window animated:YES];
    }
    return YES;
}

+ (BOOL)componentDidFinish:(NSDictionary<LLComponentDelegateKey, id> *_Nullable)data {
    return [LLComponentHelper executeAction:LLDebugToolActionEntry data:data];
}

+ (LLComponentWindow *)baseWindow {
    NSAssert(NO, @"Sub class must rewrite %@", NSStringFromSelector(_cmd));
    return nil;
}

+ (Class)baseViewController {
    return nil;
}

@end
