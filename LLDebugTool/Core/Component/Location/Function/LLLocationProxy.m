//
//  LLLocationProxy.m
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

#import "LLLocationProxy.h"

#import "LLLocationHelper.h"
#import "LLConfig.h"

#import "CLLocation+LL_Location.h"

@implementation LLLocationProxy

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(locationManager:didUpdateLocations:)) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([self.target respondsToSelector:_cmd]) {
        if ([LLLocationHelper shared].isMockRoute) {
            CLLocation *location = [locations firstObject];
            // Mocking route.
            if (location && !location.LL_isMock) {
                // Real location, ignore.
                return;
            }
        } else if ([LLLocationHelper shared].enable) {
            // Mock location.
            CLLocation *mockLocation = [[CLLocation alloc] initWithLatitude:[LLConfig shared].mockLocationLatitude longitude:[LLConfig shared].mockLocationLongitude];
            mockLocation.LL_mock = YES;
            locations = @[mockLocation];
        }
        
        [self.target locationManager:manager didUpdateLocations:locations];
    }
}

@end
