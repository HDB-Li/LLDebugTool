//
//  MKMapView+LL_Location.m
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

#import "MKMapView+LL_Location.h"

#import "LLLocationHelper.h"
#import "LLConfig.h"

#import "NSObject+LL_Runtime.h"

@implementation MKMapView (LL_Location)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceMethodWithOriginSel:NSSelectorFromString(@"_updateUserLocationViewWithLocation:hadUserLocation:") swizzledSel:@selector(LL_updateUserLocationViewWithLocation:hadUserLocation:)];
    });
}

- (void)LL_updateUserLocationViewWithLocation:(CLLocation *)location hadUserLocation:(BOOL)hadUserLocation {
    if ([LLLocationHelper shared].enable) {
        location = [[CLLocation alloc] initWithLatitude:[LLConfig shared].mockLocationLatitude longitude:[LLConfig shared].mockLocationLongitude];
    }
    [self LL_updateUserLocationViewWithLocation:location hadUserLocation:hadUserLocation];
}

@end
