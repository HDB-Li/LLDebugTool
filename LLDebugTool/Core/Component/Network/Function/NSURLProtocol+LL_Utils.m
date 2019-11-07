//
//  NSURLProtocol+LL_Utils.m
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

#import "NSURLProtocol+LL_Utils.h"

#import "NSObject+LL_Runtime.h"

@implementation NSURLProtocol (LL_Utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"_NSCFURLProtocol");
        Method method1 = class_getInstanceMethod(cls, @selector(startLoading));
        Method method2 = class_getInstanceMethod([NSURLProtocol class], @selector(LL_startLoading));
        [NSURLProtocol LL_swizzleMethod:method1 anotherMethod:method2];
        
        Method method3 = class_getInstanceMethod(cls, @selector(stopLoading));
        Method method4 = class_getInstanceMethod([NSURLProtocol class], @selector(LL_stopLoading));
        [NSURLProtocol LL_swizzleMethod:method3 anotherMethod:method4];
    });
}

+ (void)initialize {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class cls = NSClassFromString(@"_NSCFURLProtocol");
//        Method method1 = class_getInstanceMethod(cls, @selector(startLoading));
//        Method method2 = class_getInstanceMethod([NSURLProtocol class], @selector(LL_startLoading));
//        [NSURLProtocol LL_swizzleMethod:method1 anotherMethod:method2];
//
//        Method method3 = class_getInstanceMethod(cls, @selector(stopLoading));
//        Method method4 = class_getInstanceMethod([NSURLProtocol class], @selector(LL_stopLoading));
//        [NSURLProtocol LL_swizzleMethod:method3 anotherMethod:method4];
//    });
}

- (void)LL_startLoading {
    [self LL_startLoading];
}

- (void)LL_stopLoading {
    [self LL_stopLoading];
}

@end
