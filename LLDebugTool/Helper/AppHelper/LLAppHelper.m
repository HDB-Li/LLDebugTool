//
//  LLAppHelper.m
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

#import "LLAppHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <malloc/malloc.h>
#import <mach-o/arch.h>
#import <mach/mach.h>
#import "UIDevice+LL_Swizzling.h"
#import "LLMacros.h"
#import "LLTool.h"

static LLAppHelper *_instance = nil;

static uint64_t loadTime;
static NSTimeInterval startLoadTime;
static uint64_t loadDate;
static uint64_t applicationRespondedTime = -1;
static mach_timebase_info_data_t timebaseInfo;

static inline NSTimeInterval MachTimeToSeconds(uint64_t machTime) {
    return ((machTime / 1e9) * timebaseInfo.numer) / timebaseInfo.denom;
}

NSNotificationName const LLAppHelperDidUpdateAppInfosNotificationName = @"LLAppHelperDidUpdateAppInfosNotificationName";
NSString * const LLAppHelperCPUKey = @"LLAppHelperCPUKey";
NSString * const LLAppHelperMemoryUsedKey = @"LLAppHelperMemoryUsedKey";
NSString * const LLAppHelperMemoryFreeKey = @"LLAppHelperMemoryFreeKey";
NSString * const LLAppHelperMemoryTotalKey = @"LLAppHelperMemoryTotalKey";
NSString * const LLAppHelperFPSKey = @"LLAppHelperFPSKey";

@interface LLAppHelper ()
{
    unsigned long long _usedMemory;
    unsigned long long _freeMemory;
    unsigned long long _totalMemory;
    CGFloat _cpu;
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    float _fps;
    NSString *_launchDate;
}

@property (nonatomic , strong) NSTimer *memoryTimer;

@property (nonatomic , copy) NSString *cpuTypeString;

@property (nonatomic , copy) NSString *cpuSubtypeString;

@end

@implementation LLAppHelper

/**
 Record the launch time of App.
 */
+ (void)load {
    loadTime = mach_absolute_time();
    mach_timebase_info(&timebaseInfo);
    
    loadDate = [[NSDate date] timeIntervalSince1970];
    
    @autoreleasepool {
        __block id<NSObject> obs;
        obs = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                                object:nil queue:nil
                                                            usingBlock:^(NSNotification *note) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    applicationRespondedTime = mach_absolute_time();
                                                                    startLoadTime = MachTimeToSeconds(applicationRespondedTime - loadTime);
                                                                });
                                                                [[NSNotificationCenter defaultCenter] removeObserver:obs];
                                                            }];
    }
}

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLAppHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)startMonitoring {
    if ([self.memoryTimer isValid]) {
        [self.memoryTimer invalidate];
        self.memoryTimer = nil;
    }
    self.memoryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(memoryTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.memoryTimer forMode:NSRunLoopCommonModes];
    [self.memoryTimer fire];
    
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_link invalidate];
        _link = nil;
    }
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsDisplayLinkAction:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
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

- (NSMutableArray <NSArray <NSDictionary *>*>*)appInfos {
    
    NSArray *dynamic = [[NSArray alloc] initWithObjects:@{@"CPU Usage" : [NSString stringWithFormat:@"%.2f%%",_cpu]},@{@"Memory Usage" : [NSString stringWithFormat:@"Used:%@, Free:%@",[NSByteCountFormatter stringFromByteCount:_usedMemory countStyle:NSByteCountFormatterCountStyleMemory],[NSByteCountFormatter stringFromByteCount:_freeMemory countStyle:NSByteCountFormatterCountStyleMemory]]},@{@"FPS" : [NSString stringWithFormat:@"%ld FPS",(long)_fps]}, nil];
    
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    // App Info
    NSArray *apps = @[@{@"App Name" : infoDic[@"CFBundleDisplayName"] ?: infoDic[@"CFBundleName"] ?: @"Unknown"},
                      @{@"Bundle Identifier" : infoDic[@"CFBundleIdentifier"] ?:@"Unknown"},
                      @{@"App Version" : [NSString stringWithFormat:@"%@(%@)",infoDic[@"CFBundleShortVersionString"]?:@"Unknown",infoDic[@"CFBundleVersion"]?:@"Unknown"]},
                      @{@"App Start Time" : [NSString stringWithFormat:@"%.2f s",startLoadTime]}];

    // Device Info
    NSArray *devices = @[@{@"Device Model" : [UIDevice currentDevice].LL_modelName ?: @"Unknown"},
                         @{@"Phone Name" : [UIDevice currentDevice].name ?: @"Unknown"},
                         @{@"System Version" : [UIDevice currentDevice].systemVersion ?: @"Unknown"},
                         @{@"Screen Resolution" : [NSString stringWithFormat:@"%ld * %ld",(long)(LL_SCREEN_WIDTH * [UIScreen mainScreen].scale),(long)(LL_SCREEN_HEIGHT * [UIScreen mainScreen].scale)]},
                         @{@"Language Code" : [NSLocale preferredLanguages].firstObject ?: @"Unknown"},
                         @{@"Battery Level" : [UIDevice currentDevice].batteryLevel != -1 ? [NSString stringWithFormat:@"%ld%%",(long)([UIDevice currentDevice].batteryLevel * 100)] : @"Unknown"},
                         @{@"CPU Type" : [self cpuSubtypeString] ?: @"Unknown"},
                         @{@"Disk" : [NSString stringWithFormat:@"%@ / %@", [NSByteCountFormatter stringFromByteCount:[self getFreeDisk] countStyle:NSByteCountFormatterCountStyleFile],[NSByteCountFormatter stringFromByteCount:[self getTotalDisk] countStyle:NSByteCountFormatterCountStyleFile]]},
                         @{@"Network States" : [self networkingStatesFromStatebar]}];
    NSMutableArray *mutDevices = [[NSMutableArray alloc] initWithArray:devices];
    NSString *ssid = [self currentWifiSSID];
    if (ssid) {
        [mutDevices insertObject:@{@"SSID" : ssid} atIndex:7];
    }
    
    return [[NSMutableArray alloc] initWithObjects:dynamic ,apps, devices, nil];
}

- (NSString *)launchDate {
    if (!_launchDate) {
        _launchDate = [[LLTool sharedTool] stringFromDate:[NSDate dateWithTimeIntervalSince1970:loadDate]];
        if (!_launchDate) {
            _launchDate = @"";
        }
    }
    return _launchDate;
}

#pragma mark - Primary
/**
 Initialize something
 */
- (void)initial {
    _fps = 60;
}

#pragma mark - CPU
- (float)getCpuUsage
{
    kern_return_t           kr;
    thread_array_t          thread_list;
    mach_msg_type_number_t  thread_count;
    thread_info_data_t      thinfo;
    mach_msg_type_number_t  thread_info_count;
    thread_basic_info_t     basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float cpu_usage = 0;
    
    for (int i = 0; i < thread_count; i++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE))
        {
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
    switch (cpuType) {
        case CPU_TYPE_VAX:          return @"VAX";
        case CPU_TYPE_MC680x0:      return @"MC680x0";
        case CPU_TYPE_X86:          return @"X86";
        case CPU_TYPE_X86_64:       return @"X86_64";
        case CPU_TYPE_MC98000:      return @"MC98000";
        case CPU_TYPE_HPPA:         return @"HPPA";
        case CPU_TYPE_ARM:          return @"ARM";
        case CPU_TYPE_ARM64:        return @"ARM64";
        case CPU_TYPE_MC88000:      return @"MC88000";
        case CPU_TYPE_SPARC:        return @"SPARC";
        case CPU_TYPE_I860:         return @"I860";
        case CPU_TYPE_POWERPC:      return @"POWERPC";
        case CPU_TYPE_POWERPC64:    return @"POWERPC64";
        default:                    return @"Unknown";
    }
}

#pragma mark - Memory
- (void)memoryTimerAction:(NSTimer *)timer {
    struct mstats stat = mstats();
    _usedMemory = stat.bytes_used;
    _freeMemory = stat.bytes_free;
    _totalMemory = stat.bytes_total;
    _cpu = [self getCpuUsage];
    if ([[NSThread currentThread] isMainThread]) {
        [self postAppHelperDidUpdateAppInfosNotification];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postAppHelperDidUpdateAppInfosNotification];
        });
    }
}

- (void)postAppHelperDidUpdateAppInfosNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LLAppHelperDidUpdateAppInfosNotificationName object:nil userInfo:@{LLAppHelperCPUKey:@(_cpu),LLAppHelperFPSKey:@(_fps),LLAppHelperMemoryFreeKey:@(_freeMemory),LLAppHelperMemoryUsedKey:@(_usedMemory),LLAppHelperMemoryTotalKey:@(_totalMemory)}];
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
    return [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

- (unsigned long long)getFreeDisk {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

#pragma mark - Network
- (NSString *)currentWifiSSID
{
    NSString *ssid = nil;
    NSArray *ifs = (__bridge   id)CNCopySupportedInterfaces();
    for (NSString *ifname in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info[@"SSIDD"])
        {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

- (NSString *)networkingStatesFromStatebar {
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children;
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    } else {
        children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"wifi";
    
    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            stateString = @"unknown";
            break;
    }
    
    return stateString;
}

@end
