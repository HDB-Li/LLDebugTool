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

@property (nonatomic, strong) NSHashTable <CLLocationManager *>*managers;

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
- (void)addMockRouteFile:(NSString *)filePath {
    // Check nil.
    if ([filePath length] == 0) {
        return;
    }
    
    // Check file extension.
    if (![filePath.pathExtension isEqualToString:@"json"]) {
        return;
    }
    
    // Get name.
    NSString *name = filePath.lastPathComponent;
        
    LLLocationMockRouteModel *model = [[LLLocationMockRouteModel alloc] initWithJsonFile:filePath timeInterval:1 name:name];
    [self addRoute:model];
}

- (void)addMockRouteDirectory:(NSString *)fileDirectory {
    if ([fileDirectory length] == 0) {
        return;
    }
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory isDirectory:&isDirectory]) {
        return;
    }
    if (!isDirectory) {
        [self addMockRouteFile:fileDirectory];
        return;
    }
    NSArray *filePaths = [[NSFileManager defaultManager] subpathsAtPath:fileDirectory];
    for (NSString *filePath in filePaths) {
        [self addMockRouteFile:[fileDirectory stringByAppendingPathComponent:filePath]];
    }
}

- (void)removeRoute:(LLLocationMockRouteModel *)model {
    pthread_mutex_lock(&route_mutex_t);
    [self.routes removeObject:model];
    _availableRoutes = [self.routes copy];
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

+ (BOOL)isLLDebugToolLocationRouteFile:(NSString *)path {
    return [[self fileExtendedAttributesWithPath:path] objectForKey:@"LLDebugTool"] ? YES : NO;
}

+ (BOOL)addLLDebugToolExtendDataWithPath:(NSString *)path {
    if ([path length] == 0) {
        return NO;
    }
    
    NSDictionary *extendedAttributes = [self fileExtendedAttributesWithPath:path];
    if (extendedAttributes[@"LLDebugTool"]) {
        return YES;
    }
    
    NSMutableDictionary *newExtendedAttributes = [[NSMutableDictionary alloc] init];
    if (extendedAttributes) {
        [newExtendedAttributes addEntriesFromDictionary:extendedAttributes];
    }
    
    NSData *data = [@"LLDebugTool" dataUsingEncoding:NSUTF8StringEncoding];
    [newExtendedAttributes setObject:data forKey:@"LLDebugTool"];
    
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        return NO;
    }
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    if (attributes) {
        [newAttributes addEntriesFromDictionary:attributes];
    }
    [newAttributes setObject:newExtendedAttributes forKey:@"NSFileExtendedAttributes"];
    
    if (![[NSFileManager defaultManager] setAttributes:newAttributes ofItemAtPath:path error:&error]) {
        return NO;
    }
    if (error) {
        return NO;
    }
    return YES;
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
- (void)addRoute:(LLLocationMockRouteModel *)model {
    pthread_mutex_lock(&route_mutex_t);
    if ([model.name length] && model.isAvailable) {
        if (![self.routes containsObject:model]) {
            [self.routes addObject:model];
            _availableRoutes = [self.routes copy];
        }
    }
    pthread_mutex_unlock(&route_mutex_t);
}

- (void)registerManager:(CLLocationManager *)manager {
    if (!manager || ![manager isKindOfClass:[CLLocationManager class]]) {
        return;
    }
    pthread_mutex_lock(&mutex_t);
    [self.managers addObject:manager];
    pthread_mutex_unlock(&mutex_t);
}

- (void)unregisterManager:(CLLocationManager *)manager {
    if (!manager || ![manager isKindOfClass:[CLLocationManager class]]) {
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
            if (obj.LL_isUpdatingLocation && [obj.delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
                [obj.delegate locationManager:obj didUpdateLocations:@[location]];
            }
        }];
    } else {
        [self stopTimer];
    }
}

+ (NSDictionary *)fileExtendedAttributesWithPath:(NSString *)path {
    if ([path length] == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error || !attributes) {
        return nil;
    }
    
    NSDictionary *extendedAttributes = attributes[@"NSFileExtendedAttributes"];
    if (!extendedAttributes || ![extendedAttributes isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return extendedAttributes;
}

#pragma mark - Getters and setters
- (NSHashTable<CLLocationManager *> *)managers {
    if (!_managers) {
        _managers = [NSHashTable weakObjectsHashTable];
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
