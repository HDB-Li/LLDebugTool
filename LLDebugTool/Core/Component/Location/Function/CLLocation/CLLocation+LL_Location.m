//
//  CLLocation+LL_Location.m
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

#import "CLLocation+LL_Location.h"

#import "NSObject+LL_Runtime.h"

@implementation CLLocation (LL_Location)

+ (void)load
{
    static dispatch_once_t mxmOnceToken;
    dispatch_once(&mxmOnceToken, ^{
        SEL oldSelector = @selector(floor);
        SEL newSelector = @selector(hook_getLLFloor);
        Method oldMethod = class_getInstanceMethod([self class], oldSelector);
        Method newMethod = class_getInstanceMethod([self class], newSelector);
        
        // 若未实现代理方法，则先添加代理方法
        BOOL isSuccess = class_addMethod([self class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        if (isSuccess) {
            class_replaceMethod([self class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod));
        } else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

+ (CLLocation *)createLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude level:(NSInteger)level {
    CLLocation *mockLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLFloor *floor = [CLFloor createFloorWihtLevel:level];
    mockLocation.myLLFloor = floor;
    mockLocation.LL_mock = YES;
    return mockLocation;
}

- (CLFloor *)hook_getLLFloor
{
    if (self.myLLFloor) {
        return self.myLLFloor;
    } else {
        return [self hook_getLLFloor];
    }
}

- (CLFloor *)myLLFloor {
    return objc_getAssociatedObject(self, @selector(myLLFloor));
}

- (void)setMyLLFloor:(CLFloor *)myLLFloor {
    objc_setAssociatedObject(self, @selector(myLLFloor), myLLFloor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLL_mock:(BOOL)LL_mock {
    objc_setAssociatedObject(self, @selector(LL_isMock), @(LL_mock), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)LL_isMock {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@implementation CLFloor (Factory)

+ (CLFloor *)createFloorWihtLevel:(NSInteger)level
{
    CLFloor *floor = [[CLFloor alloc] init];
    [floor setValue:@(level) forKey:@"level"];
    return floor;
}

@end
