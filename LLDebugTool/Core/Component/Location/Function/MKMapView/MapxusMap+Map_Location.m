//
//  MapxusMap+Map_Location.m
//  LLDebugToolDemo
//
//  Created by Mapxus on 2024/7/16.
//  Copyright © 2024 li. All rights reserved.
//

#import "MapxusMap+Map_Location.h"
#import "NSObject+LL_Runtime.h"
#import "LLSettingManager.h"
#import "LLLocationHelper.h"
#import "LLLocationProxy.h"
#import "LLConfig.h"
#import "CLLocationManager+LL_Location.h"


@interface MapxusMap () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *methodLocationManager;
@property (nonatomic, strong) LLLocationProxy *mapxusMapProxy;

@end

@implementation MapxusMap (Map_Location)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSelector = @selector(setDelegate:);
        SEL newSelector = @selector(hook_setDelegate:);
        Method oldMethod = class_getInstanceMethod([self class], oldSelector);
        Method newMethod = class_getInstanceMethod([self class], newSelector);
        
        // 若未实现代理方法，则先添加代理方法
        BOOL isSuccess = class_addMethod([self class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        if (isSuccess) {
            class_replaceMethod([self class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod));
        } else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
        
        [self LL_swizzleInstanceMethodWithOriginSel:NSSelectorFromString(@"_updateUserLocationViewWithLocation:hadUserLocation:") swizzledSel:@selector(LL_updateUserLocationViewWithLocation:hadUserLocation:)];
    });
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
//        self.mapxusMapProxy = [[LLLocationProxy alloc] initWithTarget:self];
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

- (void)setMapxusMapProxy:(LLLocationProxy *)mapxusMapProxy {
    objc_setAssociatedObject(self, @selector(mapxusMapProxy), mapxusMapProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LLLocationProxy *)mapxusMapProxy {
    return objc_getAssociatedObject(self, @selector(mapxusMapProxy));
}

- (void)hook_setDelegate:(id<MapxusMapDelegate>)delegate
{
    [self exchangeDidSingleTapOnPOIWithDelegate:delegate];
    [self exchangeDidSingleTapOnBlackWithDelegate:delegate];
    [self exchangeDidSingleAtCoordinateWithDelegate:delegate];
    [self exchangeDidSingleAtCoordinateWithDelegate:delegate];
    [self exchangeDidChangeSelectedFloorWithDelegate:delegate];
    [self hook_setDelegate:delegate];
    [self setupLocationManager];
}

- (void)exchangeDidSingleTapOnPOIWithDelegate:(id<MapxusMapDelegate>)delegate {
    SEL oldSelector = @selector(map:didSingleTapOnPOI:atCoordinate:atSite:);
    SEL newSelector = @selector(hook_map:didSingleTapOnPOI:atCoordinate:atSite:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (void)exchangeDidSingleTapOnBlackWithDelegate:(id<MapxusMapDelegate>)delegate {
    SEL oldSelector = @selector(map:didSingleTapOnBlank:atSite:);
    SEL newSelector = @selector(hook_map:didSingleTapOnBlank:atSite:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (void)exchangeDidSingleAtCoordinateWithDelegate:(id<MapxusMapDelegate>)delegate {
    SEL oldSelector = @selector(map:didSingleTapAtCoordinate:);
    SEL newSelector = @selector(hook_map:didSingleTapAtCoordinate:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (void)exchangeDidChangeSelectedFloorWithDelegate:(id<MapxusMapDelegate>)delegate
{
    SEL oldSelector = @selector(map:didChangeSelectedFloor:inSelectedBuildingId:atSelectedVenueId:);
    SEL newSelector = @selector(hook_map:didChangeSelectedFloor:inSelectedBuildingId:atSelectedVenueId:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (void)hook_map:(MapxusMap *)map didSingleTapOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate atSite:(nullable MXMSite *)site {
    [map setUpMockCoordinate:coordinate level:site.floor.ordinal.level];
    [self hook_map:map didSingleTapOnPOI:poi atCoordinate:coordinate atSite:site];
}

- (void)map:(MapxusMap *)map didSingleTapOnPOI:(MXMGeoPOI *)poi atCoordinate:(CLLocationCoordinate2D)coordinate atSite:(nullable MXMSite *)site {
}


- (void)hook_map:(MapxusMap *)map didSingleTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [map setUpMockCoordinate:coordinate level:0];
    [self hook_map:map didSingleTapAtCoordinate:coordinate];
}

- (void)map:(MapxusMap *)map didSingleTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
}


- (void)hook_map:(MapxusMap *)map didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate atSite:(nullable MXMSite *)site {
    [map setUpMockCoordinate:coordinate level:site.floor.ordinal.level];
    [self hook_map:map didSingleTapOnBlank:coordinate atSite:site];
}

- (void)map:(MapxusMap *)map didSingleTapOnBlank:(CLLocationCoordinate2D)coordinate atSite:(nullable MXMSite *)site {
}


- (void)hook_map:(MapxusMap *)map didChangeSelectedFloor:(nullable MXMFloor *)floor inSelectedBuildingId:(nullable NSString *)buildingId atSelectedVenueId:(nullable NSString *)venueId {
    [self hook_map:map didChangeSelectedFloor:floor inSelectedBuildingId:buildingId atSelectedVenueId:venueId];
}

- (void)map:(MapxusMap *)map didChangeSelectedFloor:(nullable MXMFloor *)floor inSelectedBuildingId:(nullable NSString *)buildingId atSelectedVenueId:(nullable NSString *)venueId {
}

- (void)setUpMockCoordinate:(CLLocationCoordinate2D)coordinate level:(NSInteger)level {
    if ([LLLocationHelper shared].enable) {
        [LLConfig shared].mockLocationLatitude = coordinate.latitude;
        [LLConfig shared].mockLocationLongitude = coordinate.longitude;
        [LLSettingManager shared].mockLocationLatitude = @(coordinate.latitude);
        [LLSettingManager shared].mockLocationLongitude = @(coordinate.longitude);
        
        [LLConfig shared].mockLocationLevel = level;
        [LLSettingManager shared].mockLocationLevel = level;
        
        CLLocationCoordinate2D mockCoordinate = CLLocationCoordinate2DMake([LLConfig shared].mockLocationLatitude, [LLConfig shared].mockLocationLongitude);
        CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:mockCoordinate.latitude longitude:mockCoordinate.longitude];
        
        [self.methodLocationManager.LL_delegateProxy locationManager:self.methodLocationManager didUpdateLocations:@[tmpLocation]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
}
@end
