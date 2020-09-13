//
//  LLAppInfoHelperDelegate.h
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

#import "LLComponentHelperDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Notifications will post each second on main thread.
 Cpu is between 0.0% to 100.0%.
 Memory's unit is byte.
 Fps is float between 0.0 to 60.0.
 Request data traffic is upload data.
 Response data traffic is download data.
 Total data traffic is total data.
 */
FOUNDATION_EXPORT NSNotificationName const LLDebugToolUpdateAppInfoNotification;

typedef NSString *LLAppInfoHelperKey NS_TYPED_ENUM;

FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperCPUKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperCPUDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryUsedKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryUsedDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryFreeKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryFreeDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryTotalKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMemoryTotalDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperFPSKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperStuckCountKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMaxIntervalKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperMaxIntervalDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperRequestDataTrafficKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperRequestDataTrafficDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperResponseDataTrafficKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperResponseDataTrafficDescriptionKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperTotalDataTrafficKey;
FOUNDATION_EXPORT LLAppInfoHelperKey const LLAppInfoHelperTotalDataTrafficDescriptionKey;

@protocol LLAppInfoHelperDelegate <LLComponentHelperDelegate>

/**
 Current cpu usage.
 */
- (NSString *)cpuUsage;

/**
 Free memory usage.
 */
- (NSString *)freeMemory;

/**
 Used memory usage.
 */
- (NSString *)usedMemory;

/**
 Total memory usage.
 */
- (NSString *)totalMemory;

/**
 Current memory usage.
 */
- (NSString *)memoryUsage;

/**
 Current FPS.
 */
- (NSString *)fps;

/**
 Total data traffic.
 */
- (NSString *)totalDataTraffic;

/**
 Request data traffic.
 */
- (NSString *)requestDataTraffic;

/**
 Response data traffic.
 */
- (NSString *)responseDataTraffic;

/**
 Current data traffic.
 Format is "{total} ({upload}↑ / {download}↓)"
 */
- (NSString *)dataTraffic;

/**
 Application name.
 */
- (NSString *)appName;

/**
 Application bundle identifier.
 */
- (NSString *)bundleIdentifier;

/**
 Application version.
 */
- (NSString *)appVersion;

/**
 Application start time consuming.
 */
- (NSString *)appStartTimeConsuming;

/**
 Device model.
 */
- (NSString *)deviceModel;

/**
 Device name.
 */
- (NSString *)deviceName;

/**
 Device system version.
 */
- (NSString *)systemVersion;

/**
 Device screen resolution.
 */
- (NSString *)screenResolution;

/**
 Current languageCode.
 */
- (NSString *)languageCode;

/**
 Current battery level.
 */
- (NSString *)batteryLevel;

/**
 Current cpu type.
 */
- (NSString *)cpuType;

/**
 Current disk infos.
 */
- (NSString *)disk;

/**
 Current network state.
 */
- (NSString *)networkState;

/**
 Current ssid.
 */
- (NSString *_Nullable)ssid;

/**
 Update data traffic when finish a network request.
 */
- (void)updateRequestDataTraffic:(unsigned long long)requestDataTraffic responseDataTraffic:(unsigned long long)responseDataTraffic;

/**
 Get current app infos. Include "CPU Usage","Memory Usage","FPS","Data Traffic","App Name","Bundle Identifier","App Version","App Start Time","Device Model","Device Name","System Version","Screen Resolution","Language Code","Battery Level","CPU Type","Disk","Network State" and "SSID".
 */
- (NSString *)appInfoDescription;

/**
 Add app info observer.
 */
- (void)addAppInfoObserver:(id)observer selector:(SEL)aSelector;

/**
 Remove app info observer.
 */
- (void)removeAppInfoObserver:(id)observer;

/**
 Analysis app info notification.
 */
- (NSString *)analysisAppInfoNotification:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
