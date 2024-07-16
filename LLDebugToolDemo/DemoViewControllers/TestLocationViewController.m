//
//  TestLocationViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2019/11/19.
//  Copyright © 2019 li. All rights reserved.
//

#import "TestLocationViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapxusMapSDK/MapxusMapSDK.h>

#import "LLDebugTool.h"

@interface TestLocationAnnotation : NSObject <MGLAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation TestLocationAnnotation

@end

@interface TestLocationViewController () <CLLocationManagerDelegate, MGLMapViewDelegate, MapxusMapDelegate>

@property (nonatomic, strong) MGLMapView *mapVView;
@property (nonatomic, strong) MapxusMap *mapxusMap;
@property (nonatomic, assign) CGFloat mapViewZoomLevel;

@property (nonatomic, strong) TestLocationAnnotation *annotation;

@property (nonatomic, strong) UILabel *toastLabel;

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation TestLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapViewZoomLevel = 17.0;
    self.title = NSLocalizedString(@"test.location", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testMockLocation)];
    
    [self.view addSubview:self.mapVView];
    
    MXMConfiguration *configuration = [[MXMConfiguration alloc] init];
    self.mapxusMap = [[MapxusMap alloc] initWithMapView:self.mapVView configuration:configuration];
    self.mapxusMap.delegate = self;
    [self.mapxusMap setMapStyleWithName:@"drop_in_ui_v2"];
    self.mapxusMap.collapseCopyright = YES;
    
    [self.view addSubview:self.toastLabel];
    [self.manager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.manager startUpdatingLocation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    self.toastLabel.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, 80);
    self.mapVView.frame = CGRectMake(0, navigationBarHeight + 80, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - 80);
}

#pragma mark - MGLMapViewDelegate

#pragma mark - MapxusMapDelegate

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"*** %@, %@, %ld",NSStringFromSelector(_cmd), manager, locations.firstObject.floor.level);
    if (!locations.firstObject) {
        return;
    }
    self.annotation.coordinate = locations.firstObject.coordinate;
    if (![self.mapVView.annotations containsObject:self.annotation]) {
        [self.mapVView addAnnotation:self.annotation];
//        self.mapVView.region = MKCoordinateRegionMake(locations.firstObject.coordinate, MKCoordinateSpanMake(0.05, 0.05));
        [self.mapVView setCenterCoordinate:locations.firstObject.coordinate];
    } else {
        self.mapVView.centerCoordinate = locations.firstObject.coordinate;
    }
    _toastLabel.text = [NSString stringWithFormat:@"Lat & Lng : %0.6f, %0.6f", self.annotation.coordinate.latitude, self.annotation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _toastLabel.text = @"Failed";
    NSLog(@"%@, %@",NSStringFromSelector(_cmd), error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - Event responses
- (void)testMockLocation {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionLocation];
}

#pragma mark - Getters and setters

- (MGLMapView *)mapVView {
    if (!_mapVView) {
        _mapVView = [[MGLMapView alloc] initWithFrame:CGRectZero];
        _mapVView.delegate = self;
        _mapVView.zoomLevel = self.mapViewZoomLevel;
        _mapVView.showsUserLocation = YES;
//        _mapVView.locationManager = self.manager;
    }
    return _mapVView;
}

- (TestLocationAnnotation *)annotation {
    if (!_annotation) {
        _annotation = [[TestLocationAnnotation alloc] init];
    }
    return _annotation;
}

- (UILabel *)toastLabel {
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] init];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.text = @"Lat & Lng : 0, 0";
    }
    return _toastLabel;
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _manager;
}

@end
