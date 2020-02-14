//
//  LLDebugTool.m
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

#import "LLDebugTool.h"

#import "LLFunctionItemModel.h"
#import "LLDebugToolMacros.h"
#import "LLSettingManager.h"
#import "LLWindowManager.h"
#import "LLComponent.h"
#import "LLLogDefine.h"
#import "LLTool.h"

#import "UIResponder+LL_Utils.h"
#import "LLRouter+Log.h"

static LLDebugTool *_instance = nil;

@interface LLDebugTool ()

@property (nonatomic, assign) BOOL installed;

@end

@implementation LLDebugTool

/**
 * Singleton
 @return Singleton
 */
+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLDebugTool alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)startWorking{
    if (!_isWorking) {
        _isWorking = YES;

        // Open crash helper
        [LLRouter setCrashHelperEnable:YES];
        // Open log helper
        [LLRouter setLogHelperEnable:YES];
        // Open network monitoring
        [LLRouter setNetworkHelperEnable:YES];
        // Open app monitoring
        [LLRouter setAppInfoHelperEnable:YES];
        // Open screenshot
        [LLRouter setScreenshotHelperEnable:YES];
        // Prepare to start.
        [self prepareToStart];
        // show window
        if (self.installed || ![LLConfig shared].hideWhenInstall) {
            self.installed = YES;
            [self showWindow];
        }
        
        [self registerNotifications];
    }
}

- (void)startWorkingWithConfigBlock:(void (^)(LLConfig *config))configBlock {
    if (configBlock) {
        configBlock([LLConfig shared]);
    }
    [self startWorking];
}

- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        // Close screenshot
        [LLRouter setScreenshotHelperEnable:NO];
        // Close app monitoring
        [LLRouter setAppInfoHelperEnable:NO];
        // Close network monitoring
        [LLRouter setNetworkHelperEnable:NO];
        // Close log helper
        [LLRouter setLogHelperEnable:NO];
        // Close crash helper
        [LLRouter setCrashHelperEnable:NO];
        // hide window
        [self hideWindow];
        
        [self unregisterNotifications];
    }
}

- (void)showWindow
{
    [[LLWindowManager shared] showEntryWindow];
}

- (void)hideWindow
{
    [[LLWindowManager shared] hideEntryWindow];
}

- (void)executeAction:(LLDebugToolAction)action {
    [self executeAction:action data:nil];
}

- (void)executeAction:(LLDebugToolAction)action data:(NSDictionary <NSString *, id>*_Nullable)data {
    LLFunctionItemModel *model = [[LLFunctionItemModel alloc] initWithAction:action];
    [model.component componentDidLoad:data];
}

+ (NSString *)version {
    return [self isBetaVersion] ? [[self versionNumber] stringByAppendingString:@"(BETA)"] : [self versionNumber];
}

+ (NSString *)versionNumber {
    return @"1.3.8";
}

+ (BOOL)isBetaVersion {
    return NO;
}

#pragma mark - Notifications
- (void)didReceiveDidShakeNotification:(NSNotification *)notification {
    if ([LLConfig shared].isShakeToHide) {
        if ([LLWindowManager shared].entryWindow.isHidden) {
            [self showWindow];
        } else {
            [self hideWindow];
        }
    }
}

#pragma mark - Primary
- (void)initial {
    // Check version.
    [self checkVersion];
}

- (void)checkVersion {
    [LLTool createDirectoryAtPath:[LLConfig shared].folderPath];
    __block NSString *filePath = [[LLConfig shared].folderPath stringByAppendingPathComponent:@"LLDebugTool.plist"];
    NSMutableDictionary *localInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (!localInfo) {
        localInfo = [[NSMutableDictionary alloc] init];
    }
    NSString *version = localInfo[@"version"];
    // localInfo will be nil before version 1.1.2
    if (!version) {
        version = @"0.0.0";
    }
    
    if ([[LLDebugTool versionNumber] compare:version] == NSOrderedDescending) {
        [localInfo setObject:[LLDebugTool versionNumber] forKey:@"version"];
        [localInfo writeToFile:filePath atomically:YES];
    }
    
    if ([LLDebugTool isBetaVersion]) {
        // This method called in instancetype, can't use macros to log.
        [LLTool log:kLLDebugToolLogUseBetaAlert];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check whether has a new LLDebugTool version.
        if ([LLConfig shared].autoCheckDebugToolVersion) {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://cocoapods.org/pods/LLDebugTool"]];
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error == nil && data != nil) {
                    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray *array = [htmlString componentsSeparatedByString:@"http://cocoadocs.org/docsets/LLDebugTool/"];
                    if (array.count > 2) {
                        NSString *str = array[1];
                        NSArray *array2 = [str componentsSeparatedByString:@"/preview.png"];
                        if (array2.count >= 2) {
                            NSString *newVersion = array2[0];
                            if ([newVersion componentsSeparatedByString:@"."].count == 3) {
                                if ([[LLDebugTool versionNumber] compare:newVersion] == NSOrderedAscending) {
                                    NSString *message = [NSString stringWithFormat:@"A new version for LLDebugTool is available, New Version : %@, Current Version : %@",newVersion,[LLDebugTool versionNumber]];
                                    [LLTool log:message];
                                }
                            }
                        }
                    }
                }
            }];
            [dataTask resume];
        }
    });
}

- (void)prepareToStart {
    [[LLSettingManager shared] prepareForConfig];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDidShakeNotification:) name:LLDidShakeNotificationName object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation LLDebugTool (Log)

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [LLRouter logInFile:file function:function lineNo:lineNo onEvent:onEvent message:message];
}

- (void)alertLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [LLRouter alertLogInFile:file function:function lineNo:lineNo onEvent:onEvent message:message];
}

- (void)warningLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [LLRouter warningLogInFile:file function:function lineNo:lineNo onEvent:onEvent message:message];
}

- (void)errorLogInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo onEvent:(NSString *)onEvent message:(NSString *)message {
    [LLRouter errorLogInFile:file function:function lineNo:lineNo onEvent:onEvent message:message];
}

@end
