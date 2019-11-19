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

@interface TestLocationViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) TestLocationAnnotation *annotation;

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation TestLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"test.location", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testMockLocation)];
    
    [self.view addSubview:self.mapView];
    [self.manager startUpdatingLocation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
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
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
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
    }
    return _mapView;
}

- (TestLocationAnnotation *)annotation {
    if (!_annotation) {
        _annotation = [[TestLocationAnnotation alloc] init];
    }
    return _annotation;
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

@end
