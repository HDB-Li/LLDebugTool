//
//  LLAppHelper.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Notifications when CPU / Memory / FPS updates.
 Cpu is between 0.0% to 100.0%.
 Memory's unit is byte.
 Fps is float between 0.0 to 60.0
 */
UIKIT_EXTERN NSNotificationName const LLAppHelperDidUpdateAppInfosNotificationName;
UIKIT_EXTERN NSString * const LLAppHelperCPUKey;
UIKIT_EXTERN NSString * const LLAppHelperMemoryUsedKey;
UIKIT_EXTERN NSString * const LLAppHelperMemoryFreeKey;
UIKIT_EXTERN NSString * const LLAppHelperMemoryTotalKey;
UIKIT_EXTERN NSString * const LLAppHelperFPSKey;

/**
 Monitoring app's properties.
 */
@interface LLAppHelper : NSObject

/**
 Singleton to monitoring appinfos.
 
 @return Singleton
 */
+ (instancetype)sharedHelper;

/**
 Start monitoring CPU/FPS/Memory
 */
- (void)startMonitoring;

/**
 Stop monitoring CPU/FPS/Memory
 */
- (void)stopMonitoring;

/**
 Get current app infos.Include "CPU Usage","Memory Usage","FPS","App Name","Bundle Identifier","App Version","App Start Time","Device Model","Phone Name","System Version","Screen Resolution","Language Code","Battery Level","CPU Type","Disk","Network States" and "SSID".
 */
- (NSMutableArray <NSArray <NSDictionary *>*>*)appInfos;

/**
 Get this time launchDate. LaunchDate means the start time of the app, also it's the identity for crash model.
 */
- (NSString *)launchDate;

@end
