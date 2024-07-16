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

#import <CoreLocation/CoreLocation.h>
#import "MKMapView+LL_Location.h"

#import "NSObject+LL_Runtime.h"
#import "LLSettingManager.h"
#import "LLLocationHelper.h"
#import "LLLocationProxy.h"
#import "LLConfig.h"

@interface MGLMapView () <CLLocationManagerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) dispatch_source_t longPressTimer;

@property (nonatomic, strong) CLLocationManager *methodLocationManager;
@property (nonatomic, assign) CLHeading *currentHeading;
@property (nonatomic, strong) LLLocationProxy *proxy;

@end

@implementation MGLMapView (MGL_Location)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceMethodWithOriginSel:NSSelectorFromString(@"_updateUserLocationViewWithLocation:hadUserLocation:") swizzledSel:@selector(LL_updateUserLocationViewWithLocation:hadUserLocation:)];

        [self LL_swizzleInstanceMethodWithOriginSel:@selector(initWithFrame:) swizzledSel:@selector(LL_initWithFrame:)];
        [self LL_swizzleInstanceMethodWithOriginSel:@selector(initWithCoder:) swizzledSel:@selector(LL_initWithCoder:)];
        //locationManager
        SEL oldSelector = @selector(userLocation);
        SEL newSelector = @selector(hook_myLLUserLocation);
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

- (MGLUserLocation *)hook_myLLUserLocation
{
    if (self.myLLUserLocation) {
        return self.myLLUserLocation;
    } else {
        return [self hook_myLLUserLocation];
    }
}

- (MGLUserLocation *)myLLUserLocation {
    return objc_getAssociatedObject(self, @selector(myLLUserLocation));
}

- (void)setMyLLUserLocation:(MGLUserLocation *)myLLUserLocation {
    objc_setAssociatedObject(self, @selector(myLLUserLocation), myLLUserLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)LL_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originalMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledMethod = class_getInstanceMethod(self, swiSel);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (instancetype)LL_initWithFrame:(CGRect)frame {
    MGLMapView *mapView = [self LL_initWithFrame:frame];
    [mapView addLongPressGestureRecognizer];
    [mapView setupLocationManager];
//    [mapView.locationManager startUpdatingLocation]
    return mapView;
}

- (instancetype)LL_initWithCoder:(NSCoder *)coder {
    MGLMapView *mapView = [self LL_initWithCoder:coder];
    [mapView addLongPressGestureRecognizer];
    [mapView setupLocationManager];
    return mapView;
}

- (void)LL_updateUserLocationViewWithLocation:(CLLocation *)location hadUserLocation:(BOOL)hadUserLocation {
    if ([LLLocationHelper shared].enable) {
        location = [[CLLocation alloc] initWithLatitude:[LLConfig shared].mockLocationLatitude longitude:[LLConfig shared].mockLocationLongitude];
    }
    [self LL_updateUserLocationViewWithLocation:location hadUserLocation:hadUserLocation];
}

// Setup CLLocationManager for heading updates
- (void)setupLocationManager {
    if (!self.methodLocationManager) {
        self.methodLocationManager = [[CLLocationManager alloc] init];
        self.methodLocationManager.delegate = self;
        self.methodLocationManager.headingFilter = 10.0;
        [self.methodLocationManager startUpdatingHeading];
        self.proxy = [[LLLocationProxy alloc] initWithTarget:self];
    }
}

// Override setter for locationManager
- (void)setMethodLocationManager:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(self, @selector(locationManager), locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Getter for locationManager
- (CLLocationManager *)methodLocationManager {
    return objc_getAssociatedObject(self, @selector(locationManager));
}

- (void)setProxy:(LLLocationProxy *)proxy {
    objc_setAssociatedObject(self, @selector(proxy), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLLocationProxy *)proxy {
    return objc_getAssociatedObject(self, @selector(proxy));
}

// Override setter for currentHeading
- (void)setCurrentHeading:(CLHeading *)currentHeading {
    objc_setAssociatedObject(self, @selector(currentHeading), currentHeading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Getter for currentHeading
- (CLHeading *)currentHeading {
    return objc_getAssociatedObject(self, @selector(currentHeading));
}

// Override setter for longPressGestureRecognizer
- (void)setLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    objc_setAssociatedObject(self, @selector(longPressGestureRecognizer), longPressGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Getter for longPressGestureRecognizer
- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    return objc_getAssociatedObject(self, @selector(longPressGestureRecognizer));
}

// Override setter for longPressTimer
- (void)setLongPressTimer:(dispatch_source_t)longPressTimer {
    objc_setAssociatedObject(self, @selector(longPressTimer), longPressTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Getter for longPressTimer
- (dispatch_source_t)longPressTimer {
    return objc_getAssociatedObject(self, @selector(longPressTimer));
}

// Adding the long press gesture recognizer
- (void)addLongPressGestureRecognizer {
    if (!self.longPressGestureRecognizer) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startLongPressTimer];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self stopLongPressTimer];
    }
}

- (void)startLongPressTimer {
    if (!self.longPressTimer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        self.longPressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.longPressTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.longPressTimer, ^{
            [self longPressTimerFired];
        });
        dispatch_resume(self.longPressTimer);
    }
}

- (void)stopLongPressTimer {
    if (self.longPressTimer) {
        dispatch_source_cancel(self.longPressTimer);
        self.longPressTimer = nil;
    }
}

- (void)longPressTimerFired
{
    // You can perform additional actions here.
    if ([LLLocationHelper shared].enable) {
        CLLocationCoordinate2D mockCoordinate = CLLocationCoordinate2DMake([LLConfig shared].mockLocationLatitude, [LLConfig shared].mockLocationLongitude);
        CLLocation *tmpLocation = [LLLocationHelper pointFromPoint:mockCoordinate distance:1 angle:self.currentHeading.trueHeading];
        [LLConfig shared].mockLocationLatitude = tmpLocation.coordinate.latitude;
        [LLConfig shared].mockLocationLongitude = tmpLocation.coordinate.longitude;
        [self.proxy locationManager:self.methodLocationManager didUpdateLocations:@[tmpLocation]];
        
        [self.locationManager startUpdatingLocation];
    }
}

// CLLocationManagerDelegate method to update heading
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.currentHeading = newHeading;
}

@end
