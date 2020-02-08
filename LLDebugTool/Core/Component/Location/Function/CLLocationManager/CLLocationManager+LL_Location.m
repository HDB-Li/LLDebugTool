//
//  CLLocationManager+LL_Location.m
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

#import "CLLocationManager+LL_Location.h"

#import "LLLocationProxy.h"

#import "NSObject+LL_Runtime.h"

NSNotificationName const LLCLLocationRegisterNotificationName = @"LLCLLocationRegisterNotificationName";

NSNotificationName const LLCLLocationUnRegisterNotificationName = @"LLCLLocationUnRegisterNotificationName";

@implementation CLLocationManager (LL_Location)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(setDelegate:) swizzledSel:@selector(LL_setDelegate:)];
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(delegate) swizzledSel:@selector(LL_delegate)];
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(init) swizzledSel:@selector(LL_init)];
        [self LL_swizzleInstanceMethodWithOriginSel:NSSelectorFromString(@"dealloc") swizzledSel:@selector(LL_dealloc)];
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(startUpdatingLocation) swizzledSel:@selector(LL_startUpdatingLocation)];
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(stopUpdatingLocation) swizzledSel:@selector(LL_stopUpdatingLocation)];
    });
}

- (instancetype)LL_init {
    CLLocationManager *manager = [self LL_init];
    [[NSNotificationCenter defaultCenter] postNotificationName:LLCLLocationRegisterNotificationName object:manager];
    return manager;
}

- (void)LL_setDelegate:(id<CLLocationManagerDelegate>)delegate {
    if (delegate) {
        LLLocationProxy *proxy = [[LLLocationProxy alloc] initWithTarget:delegate];
        self.LL_delegateProxy = proxy;
        [self LL_setDelegate:proxy];
    } else {
        self.LL_delegateProxy = nil;
        [self LL_setDelegate:delegate];
    }
}

- (id<CLLocationManagerDelegate>)LL_delegate {
    id delegate = [self LL_delegate];
    if (delegate == self.LL_delegateProxy) {
        return self.LL_delegateProxy.target;
    }
    return delegate;
}

- (void)LL_dealloc {
    [[NSNotificationCenter defaultCenter] postNotificationName:LLCLLocationUnRegisterNotificationName object:self];
    [self LL_dealloc];
}

- (void)LL_startUpdatingLocation {
    self.LL_isUpdatingLocation = YES;
    [self LL_startUpdatingLocation];
}

- (void)LL_stopUpdatingLocation {
    self.LL_isUpdatingLocation = NO;
    [self LL_stopUpdatingLocation];
}

#pragma mark - Getters and setters
- (void)setLL_delegateProxy:(LLLocationProxy *)LL_delegateProxy {
    objc_setAssociatedObject(self, @selector(LL_delegateProxy), LL_delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLLocationProxy *)LL_delegateProxy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_isUpdatingLocation:(BOOL)LL_isUpdatingLocation {
    objc_setAssociatedObject(self, @selector(LL_isUpdatingLocation), @(LL_isUpdatingLocation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)LL_isUpdatingLocation {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
