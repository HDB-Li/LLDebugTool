//
//  LLLocationViewController.m
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
#import "LLTitleSwitchCellView.h"
#import "LLPinAnnotationView.h"
#import "LLInternalMacros.h"
#import "LLLocationHelper.h"
#import "LLThemeManager.h"
#import "LLAnnotation.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"
#import "UIView+LL_Utils.h"

static NSString *const kAnnotationID = @"AnnotationID";

@interface LLLocationViewController () <MKMapViewDelegate>

@property (nonatomic, strong) LLTitleSwitchCellView *switchView;

@property (nonatomic, strong) LLDetailTitleSelectorCellView *locationDescriptView;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) LLAnnotation *annotation;

@property (nonatomic, assign) BOOL isAddAnnotation;

@property (nonatomic, assign) BOOL automicSetRegion;

@end

@implementation LLLocationViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mock Location";
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.locationDescriptView];
    [self.view addSubview:self.mapView];
    
    [self addSwitchViewConstraints];
    [self addLocationDescriptViewConstraints];
    [self loadData];
}

#pragma mark - Over write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = CGRectMake(0, self.locationDescriptView.LL_bottom + kLLGeneralMargin, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT - self.locationDescriptView.LL_bottom - kLLGeneralMargin);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (oldState == MKAnnotationViewDragStateEnding && newState == MKAnnotationViewDragStateNone) {
        id <MKAnnotation> annotation = view.annotation;
        if (![annotation isKindOfClass:[LLAnnotation class]]) {
            return;
        }
        if (CLLocationCoordinate2DIsValid(annotation.coordinate)) {
            [self updateLocationDescriptViewDetailTitle:annotation.coordinate];
            if (annotation.coordinate.latitude != self.mapView.centerCoordinate.latitude || annotation.coordinate.longitude != self.mapView.centerCoordinate.longitude) {
                if (self.automicSetRegion) {
                    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
                } else {
                    [self animatedUpdateMapRegion:view.annotation.coordinate];
                }
            }
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

#pragma mark - Primary
- (void)addSwitchViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.switchView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:LL_NAVIGATION_HEIGHT];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.switchView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.switchView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.switchView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.switchView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.switchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.switchView.superview addConstraints:@[top, left, right]];
}

- (void)addLocationDescriptViewConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.locationDescriptView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.locationDescriptView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.locationDescriptView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    self.locationDescriptView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationDescriptView.superview addConstraints:@[top, left, right]];
}

- (void)updateAnnotationCoordinate:(CLLocationCoordinate2D)coordinate automicSetRegion:(BOOL)automicSetRegion {
    self.annotation.coordinate = coordinate;
    [self updateLocationDescriptViewDetailTitle:coordinate];
    if (automicSetRegion) {
        [self animatedUpdateMapRegion:coordinate];
    }
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
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
}

- (void)updateLocationDescriptViewDetailTitle:(CLLocationCoordinate2D)coordinate {
    self.locationDescriptView.detailTitle = [NSString stringWithFormat:@"%0.6f, %0.6f", coordinate.latitude, coordinate.longitude];
}

- (void)updateSwitchViewValue:(BOOL)isOn {
    [LLLocationHelper shared].enable = isOn;
}

- (void)loadData {
    CLLocationCoordinate2D mockCoordinate = [LLLocationHelper shared].mockCoordinate2D;
    BOOL automicSetRegion = YES;
    if (mockCoordinate.latitude == 0 && mockCoordinate.longitude == 0) {
        mockCoordinate = CLLocationCoordinate2DMake(kLLDefaultMockLocationLatitude, kLLDefaultMockLocationLongitude);
        automicSetRegion = NO;
    }
    [self updateAnnotationCoordinate:mockCoordinate automicSetRegion:automicSetRegion];
}

#pragma mark - Event response
- (void)locationDescriptViewDidSelect {
    __weak typeof(self) weakSelf = self;
    [self LL_showTextFieldAlertControllerWithMessage:@"Lat & Lng" text:self.locationDescriptView.detailTitle handler:^(NSString * _Nullable newText) {
        NSString *text = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *array = [text componentsSeparatedByString:@","];
        if (array.count != 2) {
            return;
        }
        CLLocationDegrees lat = [array[0] doubleValue];
        CLLocationDegrees lng = [array[1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        if (CLLocationCoordinate2DIsValid(coordinate)) {
            [weakSelf updateAnnotationCoordinate:coordinate automicSetRegion:YES];
        }
    }];
}

#pragma mark - Getters and setters
- (LLTitleSwitchCellView *)switchView {
    if (!_switchView) {
        _switchView = [[LLTitleSwitchCellView alloc] init];
        _switchView.backgroundColor = [LLThemeManager shared].containerColor;
        _switchView.title = @"Mock Location";
        _switchView.on = [LLLocationHelper shared].enable;
        __weak typeof(self) weakSelf = self;
        _switchView.changePropertyBlock = ^(BOOL isOn) {
            [weakSelf updateSwitchViewValue:isOn];
        };
        [_switchView needLine];
    }
    return _switchView;
}

- (LLDetailTitleSelectorCellView *)locationDescriptView {
    if (!_locationDescriptView) {
        _locationDescriptView = [[LLDetailTitleSelectorCellView alloc] init];
        _locationDescriptView.backgroundColor = [LLThemeManager shared].containerColor;
        _locationDescriptView.title = @"Lat & Lng";
        _locationDescriptView.detailTitle = @"0, 0";
        [_locationDescriptView needFullLine];
        __weak typeof(self) weakSelf = self;
        _locationDescriptView.block = ^{
            [weakSelf locationDescriptViewDidSelect];
        };
    }
    return _locationDescriptView;
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

@end
