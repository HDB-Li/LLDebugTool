//
//  LLLocationHelper.m
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

#import "LLLocationHelper.h"

#import <pthread/pthread.h>

#import "LLLocationMockRouteModel.h"

#import "CLLocationManager+LL_Location.h"

static LLLocationHelper *_instance = nil;

static pthread_mutex_t mutex_t = PTHREAD_MUTEX_INITIALIZER;

static pthread_mutex_t route_mutex_t = PTHREAD_MUTEX_INITIALIZER;

@interface LLLocationHelper ()

@property (nonatomic, strong) NSMutableSet <CLLocationManager *>*managers;

@property (nonatomic, strong) NSMutableArray <LLLocationMockRouteModel *>*routes;

@property (nonatomic, strong) LLLocationMockRouteModel *routeModel;

@property (nonatomic, strong) NSTimer *mockRouteTimer;

@end

@implementation LLLocationHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLLocationHelper alloc] init];
    });
    return _instance;
}

#pragma mark - Public
- (void)addRouteConfig:(LLLocationMockRouteModel *)model {
    pthread_mutex_lock(&route_mutex_t);
    if (![self.routes containsObject:model]) {
        [self.routes addObject:model];
    }
    pthread_mutex_unlock(&route_mutex_t);
}

- (void)removeRouteConfig:(LLLocationMockRouteModel *)model {
    pthread_mutex_lock(&route_mutex_t);
    [self.routes removeObject:model];
    pthread_mutex_unlock(&route_mutex_t);
}

- (void)startMockRoute:(LLLocationMockRouteModel *)model {
    [self.routeModel reload];
    self.routeModel = model;
    _isMockRoute = YES;
    [self startTimer];
}

- (void)stopMockRoute {
    [self.routeModel reload];
    _isMockRoute = NO;
    [self stopTimer];
}

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLCLLocationRegisterNotification:) name:LLCLLocationRegisterNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLCLLocationUnRegisterNotification:) name:LLCLLocationUnRegisterNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLCLLocationRegisterNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLCLLocationUnRegisterNotificationName object:nil];
}

#pragma mark - NSNotification
- (void)didReceiveLLCLLocationRegisterNotification:(NSNotification *)notification {
    [self registerManager:notification.object];
}

- (void)didReceiveLLCLLocationUnRegisterNotification:(NSNotification *)notification {
    [self unregisterManager:notification.object];
}

#pragma mark - Primary
- (void)registerManager:(CLLocationManager *)manager {
    if (!manager || [manager isKindOfClass:[CLLocationManager class]]) {
        return;
    }
    pthread_mutex_lock(&mutex_t);
    [self.managers addObject:manager];
    pthread_mutex_unlock(&mutex_t);
}

- (void)unregisterManager:(CLLocationManager *)manager {
    if (!manager || [manager isKindOfClass:[CLLocationManager class]]) {
        return;
    }
    pthread_mutex_lock(&mutex_t);
    [self.managers removeObject:manager];
    pthread_mutex_unlock(&mutex_t);
}

- (NSArray <CLLocationManager *>*)allManagers {
    NSArray *managers = nil;
    pthread_mutex_lock(&mutex_t);
    managers = [self.managers allObjects];
    pthread_mutex_unlock(&mutex_t);
    return managers;
}

- (void)startTimer {
    [self stopTimer];
    self.mockRouteTimer = [NSTimer scheduledTimerWithTimeInterval:self.routeModel.timeInterval target:self selector:@selector(routeTimerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if ([self.mockRouteTimer isValid]) {
        [self.mockRouteTimer invalidate];
        self.mockRouteTimer = nil;
    }
}

- (void)routeTimerAction:(NSTimer *)timer {
    CLLocation *location = [self.routeModel nextLocation];
    if (location) {
        NSArray *managers = [self allManagers];
        [managers enumerateObjectsUsingBlock:^(CLLocationManager *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
                [obj.delegate locationManager:obj didUpdateLocations:@[location]];
            }
        }];
    } else {
        [self stopTimer];
    }
}

#pragma mark - Getters and setters
- (NSMutableSet<CLLocationManager *> *)managers {
    if (!_managers) {
        _managers = [[NSMutableSet alloc] init];
    }
    return _managers;
}

- (NSMutableArray<LLLocationMockRouteModel *> *)routes {
    if (!_routes) {
        _routes = [[NSMutableArray alloc] init];
    }
    return _routes;
}

@end
