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

#import "LLDebugTool.h"

@interface TestLocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation TestLocationAnnotation

@end

@interface TestLocationViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) TestLocationAnnotation *annotation;

@property (nonatomic, strong) UILabel *toastLabel;

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation TestLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"test.location", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testMockLocation)];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.toastLabel];
    [self.manager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    self.toastLabel.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, 80);
    self.mapView.frame = CGRectMake(0, navigationBarHeight + 80, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight - 80);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@, %@",NSStringFromSelector(_cmd), userLocation);
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@, %@",NSStringFromSelector(_cmd), locations);
    if (!locations.firstObject) {
        return;
    }
    self.annotation.coordinate = locations.firstObject.coordinate;
    if (![self.mapView.annotations containsObject:self.annotation]) {
        [self.mapView addAnnotation:self.annotation];
        self.mapView.region = MKCoordinateRegionMake(locations.firstObject.coordinate, MKCoordinateSpanMake(0.05, 0.05));
    } else {
        self.mapView.centerCoordinate = locations.firstObject.coordinate;
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
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
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
    }
    return _manager;
}

@end
