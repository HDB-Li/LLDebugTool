//
//  LLLocationViewController.m
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

#import "LLLocationViewController.h"

#import <MapKit/MapKit.h>

#import "LLDetailTitleSelectorCellView.h"
#import "LLLocationMockRouteModel.h"
#import "LLTitleSwitchCellView.h"
#import "LLPinAnnotationView.h"
#import "LLInternalMacros.h"
#import "LLLocationHelper.h"
#import "LLSettingManager.h"
#import "LLThemeManager.h"
#import "LLAnnotation.h"
#import "LLToastUtils.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"
#import "UIView+LL_Utils.h"

static NSString *const kAnnotationID = @"AnnotationID";

@interface LLLocationViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) LLTitleSwitchCellView *mockLocationSwitch;

@property (nonatomic, strong) LLDetailTitleSelectorCellView *locationDescriptView;

@property (nonatomic, strong) LLDetailTitleSelectorCellView *addressDescriptView;

@property (nonatomic, strong) LLTitleSwitchCellView *mockRouteSwitch;

@property (nonatomic, strong) LLDetailTitleSelectorCellView *routeDescriptView;

@property (nonatomic, strong) LLTitleSwitchCellView *recordRouteSwitch;

@property (nonatomic, strong) NSTimer *recordRouteTimer;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) LLAnnotation *annotation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) BOOL isAddAnnotation;

@property (nonatomic, assign) BOOL automicSetRegion;

@property (nonatomic, strong) LLLocationMockRouteModel *routeModel;

@end

@implementation LLLocationViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"function.location");
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    
    [self.view addSubview:self.mockLocationSwitch];
    [self.view addSubview:self.locationDescriptView];
    [self.view addSubview:self.addressDescriptView];
    [self.view addSubview:self.mockRouteSwitch];
    [self.view addSubview:self.routeDescriptView];
    [self.view addSubview:self.recordRouteSwitch];
    [self.view addSubview:self.mapView];
    
    [self addMockLocationSwitchConstraints];
    [self addLocationDescriptViewConstraints];
    [self addAddressDescriptViewConstraints];
    [self addMockRouteSwitchConstraints];
    [self addRouteDescriptViewConstraints];
    [self addRecordRouteSwitchConstraints];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRecordRouteTimer];
}

#pragma mark - Over write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = CGRectMake(0, self.addressDescriptView.LL_bottom + kLLGeneralMargin, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT - self.addressDescriptView.LL_bottom - kLLGeneralMargin);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (oldState == MKAnnotationViewDragStateEnding && newState == MKAnnotationViewDragStateNone) {
        id <MKAnnotation> annotation = view.annotation;
        if (![annotation isKindOfClass:[LLAnnotation class]]) {
            return;
        }
        if (CLLocationCoordinate2DIsValid(annotation.coordinate)) {
            [self setUpCoordinate:annotation.coordinate automicSetRegion:YES placemark:nil];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[LLAnnotation class]]) {
        LLPinAnnotationView *annotationView = (LLPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationID];
        if (!annotationView) {
            annotationView = [[LLPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:kAnnotationID];
        }
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    if (location) {
        [manager stopUpdatingLocation];
        [self setUpCoordinate:location.coordinate automicSetRegion:YES placemark:nil];
    }
}

#pragma mark - Primary
- (void)addMockLocationSwitchConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.mockLocationSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mockLocationSwitch.superview attribute:NSLayoutAttributeTop multiplier:1 constant:LL_NAVIGATION_HEIGHT];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.mockLocationSwitch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mockLocationSwitch.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.mockLocationSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mockLocationSwitch.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.mockLocationSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mockLocationSwitch.superview addConstraints:@[top, left, right]];
}

- (void)addLocationDescriptViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mockLocationSwitch attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.locationDescriptView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.locationDescriptView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.locationDescriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationDescriptView.superview addConstraints:@[top, left, right]];
}

- (void)addAddressDescriptViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.addressDescriptView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.locationDescriptView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.addressDescriptView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.addressDescriptView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.addressDescriptView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.addressDescriptView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.addressDescriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.addressDescriptView.superview addConstraints:@[top, left, right]];
}

- (void)addMockRouteSwitchConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.mockRouteSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addressDescriptView attribute:NSLayoutAttributeBottom multiplier:1 constant:kLLGeneralMargin];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.mockRouteSwitch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mockRouteSwitch.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.mockRouteSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mockRouteSwitch.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.mockRouteSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mockRouteSwitch.superview addConstraints:@[top, left, right]];
}

- (void)addRouteDescriptViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.routeDescriptView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.self.mockRouteSwitch attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.routeDescriptView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.routeDescriptView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.routeDescriptView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.routeDescriptView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.routeDescriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.routeDescriptView.superview addConstraints:@[top, left, right]];
}

- (void)addRecordRouteSwitchConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.recordRouteSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.self.routeDescriptView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.recordRouteSwitch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.recordRouteSwitch.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.recordRouteSwitch attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.recordRouteSwitch.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.recordRouteSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordRouteSwitch.superview addConstraints:@[top, left, right]];
}

- (void)setUpCoordinate:(CLLocationCoordinate2D)coordinate automicSetRegion:(BOOL)automicSetRegion placemark:(CLPlacemark *)placemark {
    // Set annotation.
    self.annotation.coordinate = coordinate;
    if ([LLLocationHelper shared].enable) {
        [self setUpMockCoordinate:coordinate];
    }
    // Automic set map region
    if (automicSetRegion) {
        if (self.automicSetRegion) {
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        } else {
            [self animatedUpdateMapRegion:coordinate];
        }
    }
    // Set location title
    [self updateLocationDescriptViewDetailTitle:coordinate];
    if (placemark) {
        [self updateAddressDescriptViewDetailTitle:placemark];
    } else {
        [self reverseGeocode:coordinate];
    }
    // Update
    if (!self.isAddAnnotation) {
        self.isAddAnnotation = YES;
        [self.mapView addAnnotation:self.annotation];
        [self.mapView selectAnnotation:self.annotation animated:YES];
    } else {
        [self.mapView deselectAnnotation:self.annotation animated:NO];
        [self.mapView selectAnnotation:self.annotation animated:NO];
    }
}

- (void)animatedUpdateMapRegion:(CLLocationCoordinate2D)coordinate {
    self.automicSetRegion = YES;
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
}

- (void)updateLocationDescriptViewDetailTitle:(CLLocationCoordinate2D)coordinate {
    self.locationDescriptView.detailTitle = [NSString stringWithFormat:@"%0.6f, %0.6f", coordinate.latitude, coordinate.longitude];
}

- (void)updateAddressDescriptViewDetailTitle:(CLPlacemark *)placemark {
    NSString *name = placemark.name;
    NSString *locality = placemark.locality;
    NSString *administrativeArea = placemark.administrativeArea;
    
    NSString *description = @"";
    if (name) {
        description = [description stringByAppendingString:name];
    }
    if (locality && ![description hasPrefix:locality]) {
        if (!administrativeArea || ![description hasPrefix:[NSString stringWithFormat:@"%@%@",administrativeArea, locality]]) {
            description = [locality stringByAppendingString:description];
        }
    }
    if (administrativeArea && ![description hasPrefix:administrativeArea]) {
        description = [administrativeArea stringByAppendingString:description];
    }
    self.addressDescriptView.detailTitle = description;
}

- (void)updateMockLocationSwitchValue:(BOOL)isOn {
    [LLLocationHelper shared].enable = isOn;
    [LLSettingManager shared].mockLocationEnable = @(isOn);
    if (isOn) {
        [self setUpMockCoordinate:self.annotation.coordinate];
    }
}

- (void)setUpMockCoordinate:(CLLocationCoordinate2D)coordinate {
    [LLConfig shared].mockLocationLatitude = coordinate.latitude;
    [LLConfig shared].mockLocationLongitude = coordinate.longitude;
    [LLSettingManager shared].mockLocationLatitude = @(coordinate.latitude);
    [LLSettingManager shared].mockLocationLongitude = @(coordinate.longitude);
}

- (void)reverseGeocode:(CLLocationCoordinate2D)coordinate {
    [self.geocoder cancelGeocode];
    __weak typeof(self) weakSelf = self;
    [self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            [weakSelf updateAddressDescriptViewDetailTitle:placemark];
        }
    }];
}

- (void)geocodeAddress:(NSString *)address {
    [self.geocoder cancelGeocode];
    __weak typeof(self) weakSelf = self;
    [self.geocoder geocodeAddressString:address inRegion:nil completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            [weakSelf setUpCoordinate:placemark.location.coordinate automicSetRegion:YES placemark:placemark];
        }
    }];
}

- (void)updateMockRouteSwitchValue:(BOOL)isOn {
    if (isOn) {
        if (self.routeModel) {
            [[LLLocationHelper shared] startMockRoute:self.routeModel];
        } else {
            [[LLToastUtils shared] toastMessage:LLLocalizedString(@"location.select.route")];
            self.mockRouteSwitch.on = NO;
        }
    } else {
        [[LLLocationHelper shared] stopMockRoute];
    }
}

- (void)selectMockRoute:(LLLocationMockRouteModel *)model {
    if (model.isAvailable) {
        self.routeModel = model;
        [[LLLocationHelper shared] startMockRoute:model];
        self.mockRouteSwitch.on = YES;
        [LLSettingManager shared].mockRouteFilePath = model.filePath;
        [LLSettingManager shared].mockRouteFileName = model.name;
    } else {
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"location.route.file.error")];
    }
}

- (void)updateRecordRouteSwitchValue:(BOOL)isOn {
    if (isOn) {
        if ([LLLocationHelper shared].isMockRoute || [LLLocationHelper shared].enable) {
            __weak typeof(self) weakSelf = self;
            [self LL_showAlertControllerWithMessage:LLLocalizedString(@"location.record.route.alert")  handler:^(NSInteger action) {
                if (action == 1) {
                    [weakSelf startRecordRoute];
                } else {
                    [weakSelf stopRecordRoute];
                }
            }];
        } else {
            [self startRecordRoute];
        }
    } else {
        [self stopRecordRoute];
    }
}

- (void)startRecordRoute {
    self.recordRouteSwitch.on = YES;
    self.recordRouteSwitch.detailTitle = LLLocalizedString(@"location.record.route.recording");
    [self startRecordRouteTimer];
}

- (void)stopRecordRoute {
    self.recordRouteSwitch.on = NO;
    self.recordRouteSwitch.detailTitle = nil;
    [self stopRecordRouteTimer];
}

- (void)startRecordRouteTimer {
    [self stopRecordRouteTimer];
    self.recordRouteTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordRouteTimerAction:) userInfo:nil repeats:YES];
}

- (void)stopRecordRouteTimer {
    if ([self.recordRouteTimer isValid]) {
        [self.recordRouteTimer invalidate];
        self.recordRouteTimer = nil;
    }
}

- (void)recordRouteTimerAction:(NSTimer *)timer {
    if ([self.recordRouteSwitch.detailTitle hasSuffix:@"..."]) {
        self.recordRouteSwitch.detailTitle = [self.recordRouteSwitch.detailTitle substringToIndex:self.recordRouteSwitch.detailTitle.length - 3];
    } else {
        self.recordRouteSwitch.detailTitle = [self.recordRouteSwitch.detailTitle stringByAppendingString:@"."];
    }
}

- (void)loadData {
    CLLocationCoordinate2D mockCoordinate = CLLocationCoordinate2DMake([LLConfig shared].mockLocationLatitude, [LLConfig shared].mockLocationLongitude);
    BOOL automicSetRegion = YES;
    if (mockCoordinate.latitude == 0 && mockCoordinate.longitude == 0) {
        mockCoordinate = CLLocationCoordinate2DMake(kLLDefaultMockLocationLatitude, kLLDefaultMockLocationLongitude);
        automicSetRegion = NO;
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager startUpdatingLocation];
        }
    }
    [self setUpCoordinate:mockCoordinate automicSetRegion:automicSetRegion placemark:nil];
}

#pragma mark - Event response
- (void)locationDescriptViewDidSelect {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertControllerWithMessage:LLLocalizedString(@"location.lat.lng") text:self.locationDescriptView.detailTitle handler:^(NSString * _Nullable newText) {
        NSString *text = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *array = [text componentsSeparatedByString:@","];
        if (array.count != 2) {
            return;
        }
        CLLocationDegrees lat = [array[0] doubleValue];
        CLLocationDegrees lng = [array[1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        if (CLLocationCoordinate2DIsValid(coordinate)) {
            [weakSelf setUpCoordinate:coordinate automicSetRegion:YES placemark:nil];
        }
    }];
}

- (void)addressDescriptViewDidSelect {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertControllerWithMessage:LLLocalizedString(@"location.address") text:self.addressDescriptView.detailTitle handler:^(NSString * _Nullable newText) {
        [weakSelf geocodeAddress:newText];
    }];
}

- (void)routeDescriptViewDidSelect {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    __block NSArray *models = [[LLLocationHelper shared].availableRoutes copy];
    for (LLLocationMockRouteModel *model in models) {
        [actions addObject:model.name];
    }
    [self LL_showActionSheetWithTitle:LLLocalizedString(@"location.select.route") actions:actions currentAction:nil completion:^(NSInteger index) {
        [weakSelf selectMockRoute:models[index]];
    }];
}

#pragma mark - Getters and setters
- (LLTitleSwitchCellView *)mockLocationSwitch {
    if (!_mockLocationSwitch) {
        _mockLocationSwitch = [[LLTitleSwitchCellView alloc] init];
        _mockLocationSwitch.backgroundColor = [LLThemeManager shared].containerColor;
        _mockLocationSwitch.title = LLLocalizedString(@"location.mock.location");
        _mockLocationSwitch.on = [LLLocationHelper shared].enable;
        __weak typeof(self) weakSelf = self;
        _mockLocationSwitch.changePropertyBlock = ^(BOOL isOn) {
            [weakSelf updateMockLocationSwitchValue:isOn];
        };
        [_mockLocationSwitch needLine];
    }
    return _mockLocationSwitch;
}

- (LLDetailTitleSelectorCellView *)locationDescriptView {
    if (!_locationDescriptView) {
        _locationDescriptView = [[LLDetailTitleSelectorCellView alloc] init];
        _locationDescriptView.backgroundColor = [LLThemeManager shared].containerColor;
        _locationDescriptView.title = LLLocalizedString(@"location.lat.lng");
        _locationDescriptView.detailTitle = @"0, 0";
        [_locationDescriptView needLine];
        __weak typeof(self) weakSelf = self;
        _locationDescriptView.block = ^{
            [weakSelf locationDescriptViewDidSelect];
        };
    }
    return _locationDescriptView;
}

- (LLDetailTitleSelectorCellView *)addressDescriptView {
    if (!_addressDescriptView) {
        _addressDescriptView = [[LLDetailTitleSelectorCellView alloc] init];
        _addressDescriptView.backgroundColor = [LLThemeManager shared].containerColor;
        _addressDescriptView.title = LLLocalizedString(@"location.address");
        [_addressDescriptView needFullLine];
        __weak typeof(self) weakSelf = self;
        _addressDescriptView.block = ^{
            [weakSelf addressDescriptViewDidSelect];
        };
    }
    return _addressDescriptView;
}

- (LLTitleSwitchCellView *)mockRouteSwitch {
    if (!_mockRouteSwitch) {
        _mockRouteSwitch = [[LLTitleSwitchCellView alloc] init];
        _mockRouteSwitch.backgroundColor = [LLThemeManager shared].containerColor;
        _mockRouteSwitch.title = LLLocalizedString(@"location.mock.route");
        _mockRouteSwitch.on = [LLLocationHelper shared].isMockRoute;
        __weak typeof(self) weakSelf = self;
        _mockRouteSwitch.changePropertyBlock = ^(BOOL isOn) {
            [weakSelf updateMockRouteSwitchValue:isOn];
        };
        [_mockRouteSwitch needLine];
    }
    return _mockRouteSwitch;
}

- (LLDetailTitleSelectorCellView *)routeDescriptView {
    if (!_routeDescriptView) {
        _routeDescriptView = [[LLDetailTitleSelectorCellView alloc] init];
        _routeDescriptView.backgroundColor = [LLThemeManager shared].containerColor;
        _routeDescriptView.title = LLLocalizedString(@"location.route");
        _routeDescriptView.detailTitle = [LLSettingManager shared].mockRouteFileName ? : LLLocalizedString(@"location.select.route");
        [_routeDescriptView needLine];
        __weak typeof(self) weakSelf = self;
        _routeDescriptView.block = ^{
            [weakSelf routeDescriptViewDidSelect];
        };
    }
    return _routeDescriptView;
}

- (LLTitleSwitchCellView *)recordRouteSwitch {
    if (!_recordRouteSwitch) {
        _recordRouteSwitch = [[LLTitleSwitchCellView alloc] init];
        _recordRouteSwitch.backgroundColor = [LLThemeManager shared].containerColor;
        _recordRouteSwitch.title = LLLocalizedString(@"location.record.route");
        __weak typeof(self) weakSelf = self;
        _recordRouteSwitch.changePropertyBlock = ^(BOOL isOn) {
            [weakSelf updateRecordRouteSwitchValue:isOn];
        };
        [_recordRouteSwitch needFullLine];
    }
    return _recordRouteSwitch;
}

- (void)setRouteModel:(LLLocationMockRouteModel *)routeModel {
    if (_routeModel != routeModel) {
        _routeModel = routeModel;
        self.routeDescriptView.detailTitle = routeModel.name ?: LLLocalizedString(@"unknown");
    }
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (LLAnnotation *)annotation {
    if (!_annotation) {
        _annotation = [[LLAnnotation alloc] init];
    }
    return _annotation;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
