//
//  LLAppInfoHelper.m
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

#import "LLAppInfoHelper.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <mach-o/arch.h>
#import <mach/mach.h>
#import <malloc/malloc.h>

#import "LLInternalMacros.h"

#import "LLRouter+Network.h"
#import "NSObject+LL_Utils.h"
#import "UIDevice+LL_AppInfo.h"

static LLAppInfoHelper *_instance = nil;

NSNotificationName const LLDebugToolUpdateAppInfoNotification = @"LLDebugToolUpdateAppInfoNotification";
LLAppInfoHelperKey const LLAppInfoHelperCPUKey = @"LLAppInfoHelperCPUKey";
LLAppInfoHelperKey const LLAppInfoHelperMemoryUsedKey = @"LLAppInfoHelperMemoryUsedKey";
LLAppInfoHelperKey const LLAppInfoHelperMemoryFreeKey = @"LLAppInfoHelperMemoryFreeKey";
LLAppInfoHelperKey const LLAppInfoHelperMemoryTotalKey = @"LLAppInfoHelperMemoryTotalKey";
LLAppInfoHelperKey const LLAppInfoHelperFPSKey = @"LLAppInfoHelperFPSKey";
LLAppInfoHelperKey const LLAppInfoHelperRequestDataTrafficKey = @"LLAppInfoHelperRequestDataTrafficKey";
LLAppInfoHelperKey const LLAppInfoHelperResponseDataTrafficKey = @"LLAppInfoHelperResponseDataTrafficKey";
LLAppInfoHelperKey const LLAppInfoHelperTotalDataTrafficKey = @"LLAppInfoHelperTotalDataTrafficKey";

@interface LLAppInfoHelper () {
    unsigned long long _usedMemory;
    unsigned long long _freeMemory;
    unsigned long long _totalMemory;
    unsigned long long _requestDataTraffic;
    unsigned long long _responseDataTraffic;
    unsigned long long _totalDataTraffic;
    CGFloat _cpu;
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    float _fps;

    // Cache
    NSString *_appName;
    NSString *_bundleIdentifier;
    NSString *_appVersion;
    NSString *_appStartTimeConsuming;
    NSString *_deviceModel;
    NSString *_deviceName;
    NSString *_systemVersion;
    NSString *_screenResolution;
    NSString *_cpuType;
}

@property (nonatomic, strong) NSTimer *memoryTimer;

@property (nonatomic, copy) NSString *cpuTypeString;

@property (nonatomic, copy) NSString *cpuSubtypeString;

@end

@implementation LLAppInfoHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLAppInfoHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)setEnable:(BOOL)enable {
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self startTimers];
        } else {
            [self removeTimers];
        }
    }
}

- (NSString *)appInfoDescription {
    NSMutableString *desc = [[NSMutableString alloc] init];

    // CPU Usage
    [desc appendFormat:@"CPU : %@\n", self.cpuUsage];
    // Memory Usage
    [desc appendFormat:@"Memory : %@\n", self.memoryUsage];
    // FPS
    [desc appendFormat:@"FPS : %@\n", self.fps];
    // Data Traffic
    [desc appendFormat:@"Data Traffic : %@\n\n", self.dataTraffic];

    // App Name
    [desc appendFormat:@"Name : %@\n", self.appName];
    // Bundle Identifier
    [desc appendFormat:@"Identifier : %@\n", self.bundleIdentifier];
    // App Version
    [desc appendFormat:@"Version : %@\n", self.appVersion];
    // Start Time
    [desc appendFormat:@"Start Time : %@\n\n", self.appStartTimeConsuming];

    // Model
    [desc appendFormat:@"Model : %@\n", self.deviceModel];
    // Name
    [desc appendFormat:@"Name : %@\n", self.deviceName];
    // Version
    [desc appendFormat:@"Version : %@\n", self.systemVersion];
    // Resolution
    [desc appendFormat:@"Resolution : %@\n", self.screenResolution];
    // Language
    [desc appendFormat:@"Language : %@\n", self.languageCode];
    // Battery
    [desc appendFormat:@"Battery : %@\n", self.batteryLevel];
    //CPU
    [desc appendFormat:@"CPU : %@\n", self.cpuType];
    // Disk
    [desc appendFormat:@"Disk : %@\n", self.disk];
    // SSID
    [desc appendFormat:@"SSID : %@\n", self.ssid ?: @"Unknown"];
    // Network
    [desc appendFormat:@"Network : %@\n\n", self.networkState];

    return [desc copy];
}

- (void)updateRequestDataTraffic:(unsigned long long)requestDataTraffic responseDataTraffic:(unsigned long long)responseDataTraffic {
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateRequestDataTraffic:requestDataTraffic responseDataTraffic:responseDataTraffic];
        });
    } else {
        @synchronized(self) {
            _requestDataTraffic += requestDataTraffic;
            _responseDataTraffic += responseDataTraffic;
            _totalDataTraffic = _requestDataTraffic + _responseDataTraffic;
        }
    }
}

- (NSString *)cpuUsage {
    return [NSString stringWithFormat:@"%.2f%%", _cpu];
}

- (NSString *)memoryUsage {
    NSString *used = [NSByteCountFormatter stringFromByteCount:_usedMemory countStyle:NSByteCountFormatterCountStyleMemory];
    NSString *free = [NSByteCountFormatter stringFromByteCount:_freeMemory countStyle:NSByteCountFormatterCountStyleMemory];
    return [NSString stringWithFormat:@"Used:%@, Free:%@", used, free];
}

- (NSString *)fps {
    return [NSString stringWithFormat:@"%ld FPS", (long)_fps];
}

- (NSString *)dataTraffic {
    NSString *total = [NSByteCountFormatter stringFromByteCount:_totalDataTraffic countStyle:NSByteCountFormatterCountStyleFile];
    NSString *request = [NSByteCountFormatter stringFromByteCount:_requestDataTraffic countStyle:NSByteCountFormatterCountStyleFile];
    NSString *response = [NSByteCountFormatter stringFromByteCount:_responseDataTraffic countStyle:NSByteCountFormatterCountStyleFile];
    return [NSString stringWithFormat:@"%@ (%@↑ / %@↓)", total, request, response];
}

- (NSString *)appName {
    if (!_appName) {
        NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        _appName = infoDic[@"CFBundleDisplayName"] ?: infoDic[@"CFBundleName"] ?: @"Unknown";
    }
    return _appName;
}

- (NSString *)bundleIdentifier {
    if (!_bundleIdentifier) {
        NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        _bundleIdentifier = infoDic[@"CFBundleIdentifier"] ?: @"Unknown";
    }
    return _bundleIdentifier;
}

- (NSString *)appVersion {
    if (!_appVersion) {
        NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        _appVersion = [NSString stringWithFormat:@"%@(%@)", infoDic[@"CFBundleShortVersionString"] ?: @"Unknown", infoDic[@"CFBundleVersion"] ?: @"Unknown"];
    }
    return _appVersion;
}

- (NSString *)appStartTimeConsuming {
    if (!_appStartTimeConsuming) {
        _appStartTimeConsuming = [NSString stringWithFormat:@"%.2f s", [NSObject LL_startLoadTime]];
    }
    return _appStartTimeConsuming;
}

- (NSString *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [UIDevice currentDevice].LL_modelName ?: @"Unknown";
    }
    return _deviceModel;
}

- (NSString *)deviceName {
    if (!_deviceName) {
        _deviceName = [UIDevice currentDevice].name ?: @"Unknown";
    }
    return _deviceName;
}

- (NSString *)systemVersion {
    if (!_systemVersion) {
        _systemVersion = [UIDevice currentDevice].systemVersion ?: @"Unknown";
    }
    return _systemVersion;
}

- (NSString *)screenResolution {
    if (!_screenResolution) {
        _screenResolution = [NSString stringWithFormat:@"%ld * %ld", (long)(LL_SCREEN_WIDTH * [UIScreen mainScreen].scale), (long)(LL_SCREEN_HEIGHT * [UIScreen mainScreen].scale)];
    }
    return _screenResolution;
}

- (NSString *)languageCode {
    return [NSLocale preferredLanguages].firstObject ?: @"Unknown";
}

- (NSString *)batteryLevel {
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel == -1) {
        return @"Unknown";
    }
    return [NSString stringWithFormat:@"%ld%%", (long)(batteryLevel * 100)];
}

- (NSString *)cpuType {
    return [self cpuSubtypeString] ?: @"Unknown";
}

- (NSString *)disk {
    NSString *free = [NSByteCountFormatter stringFromByteCount:[self getFreeDisk] countStyle:NSByteCountFormatterCountStyleFile];
    NSString *total = [NSByteCountFormatter stringFromByteCount:[self getTotalDisk] countStyle:NSByteCountFormatterCountStyleFile];
    return [NSString stringWithFormat:@"%@ / %@", free, total];
}

- (NSString *)networkState {
    return [self currentNetworkStatusDescription];
}

- (NSString *)ssid {
    return [self currentWifiSSID];
}

#pragma mark - Primary
/**
 Init something
 */
- (void)initial {
    _fps = 60;
}

- (void)startTimers {
    [self removeTimers];

    self.memoryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(memoryTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.memoryTimer forMode:NSRunLoopCommonModes];
    [self.memoryTimer fire];

    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsDisplayLinkAction:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeTimers {
    if ([self.memoryTimer isValid]) {
        [self.memoryTimer invalidate];
        self.memoryTimer = nil;
    }
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_link invalidate];
        _link = nil;
    }
}

#pragma mark - CPU
- (float)getCpuUsage {
    kern_return_t kr;
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;

    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float cpu_usage = 0;

    for (int i = 0; i < thread_count; i++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            cpu_usage += basic_info_th->cpu_usage;
        }
    }

    cpu_usage = cpu_usage / (float)TH_USAGE_SCALE * 100.0;

    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return cpu_usage;
}

- (NSString *)cpuTypeString {
    if (!_cpuTypeString) {
        _cpuTypeString = [self stringFromCpuType:[self getCpuType]];
    }
    return _cpuTypeString;
}

- (NSString *)cpuSubtypeString {
    if (!_cpuSubtypeString) {
        _cpuSubtypeString = [NSString stringWithUTF8String:NXGetLocalArchInfo()->description];
    }

    return _cpuSubtypeString;
}

- (NSInteger)getCpuType {
    return (NSInteger)(NXGetLocalArchInfo()->cputype);
}
- (NSInteger)getCpuSubtype {
    return (NSInteger)(NXGetLocalArchInfo()->cpusubtype);
}

- (NSString *)stringFromCpuType:(NSInteger)cpuType {
    NSDictionary *json = @{
        @(CPU_TYPE_VAX): @"VAX",
        @(CPU_TYPE_MC680x0): @"MC680x0",
        @(CPU_TYPE_X86) :@"X86",
        @(CPU_TYPE_X86_64) :@"X86_64",
        @(CPU_TYPE_MC98000) :@"MC98000",
        @(CPU_TYPE_HPPA) :@"HPPA",
        @(CPU_TYPE_ARM) :@"ARM",
        @(CPU_TYPE_ARM64) :@"ARM64",
        @(CPU_TYPE_MC88000) :@"MC88000",
        @(CPU_TYPE_SPARC) :@"SPARC",
        @(CPU_TYPE_I860) :@"I860",
        @(CPU_TYPE_POWERPC) :@"POWERPC",
        @(CPU_TYPE_POWERPC64) :@"POWERPC64"
    };
    NSString *desc = json[@(cpuType)];
    if (!desc) {
        desc = @"Unknown";
    }
    return desc;
}

#pragma mark - Memory
- (void)memoryTimerAction:(NSTimer *)timer {
    struct mstats stat = mstats();
    _usedMemory = stat.bytes_used;
    _freeMemory = stat.bytes_free;
    _totalMemory = stat.bytes_total;
    _cpu = [self getCpuUsage];
    [self postDebugToolUpdateAppInfoNotification];
}

- (void)postDebugToolUpdateAppInfoNotification {
    if ([[NSThread currentThread] isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolUpdateAppInfoNotification
                                                            object:self
                                                          userInfo:@{
                                                              LLAppInfoHelperCPUKey: @(_cpu),
                                                              LLAppInfoHelperFPSKey: @(_fps),
                                                              LLAppInfoHelperMemoryFreeKey: @(_freeMemory),
                                                              LLAppInfoHelperMemoryUsedKey: @(_usedMemory),
                                                              LLAppInfoHelperMemoryTotalKey: @(_totalMemory),
                                                              LLAppInfoHelperRequestDataTrafficKey: @(_requestDataTraffic),
                                                              LLAppInfoHelperResponseDataTrafficKey: @(_responseDataTraffic),
                                                              LLAppInfoHelperTotalDataTrafficKey: @(_totalDataTraffic)
                                                          }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postDebugToolUpdateAppInfoNotification];
        });
    }
}

#pragma mark - FPS
- (void)fpsDisplayLinkAction:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }

    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    _fps = _count / delta;
    _count = 0;
}

#pragma mark - Disk
- (unsigned long long)getTotalDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes[NSFileSystemSize] unsignedLongLongValue];
}

- (unsigned long long)getFreeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes[NSFileSystemFreeSize] unsignedLongLongValue];
}

#pragma mark - Network
- (NSString *)currentWifiSSID {
    NSString *ssid = nil;
    CFArrayRef ifRef = CNCopySupportedInterfaces();
    NSArray *ifs = (__bridge id)ifRef;
    for (NSString *ifname in ifs) {
        CFDictionaryRef dictionaryRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        NSDictionary *info = (__bridge id)dictionaryRef;
        if (info[@"SSIDD"]) {
            ssid = info[@"SSID"];
        }
        if (dictionaryRef) {
            CFAutorelease(dictionaryRef);
        }
    }
    if (ifRef) {
        CFAutorelease(ifRef);
    }
    return ssid;
}

- (NSString *)currentNetworkStatusDescription {
    NSString *returnValue = @"Unknown";
    switch ([LLRouter networkStateFromStatebar]) {
        case LLNetworkStatusNotReachable: {
            returnValue = @"Unknown";
        } break;
        case LLNetworkStatusReachableViaWWAN: {
            returnValue = @"WWAN";
        } break;
        case LLNetworkStatusReachableViaWWAN2G: {
            returnValue = @"WWAN 2G";
        } break;
        case LLNetworkStatusReachableViaWWAN3G: {
            returnValue = @"WWAN 3G";
        } break;
        case LLNetworkStatusReachableViaWWAN4G: {
            returnValue = @"WWAN 4G";
        } break;
        case LLNetworkStatusReachableViaWiFi: {
            returnValue = @"WiFi";
        } break;
    }
    return returnValue;
}

@end
