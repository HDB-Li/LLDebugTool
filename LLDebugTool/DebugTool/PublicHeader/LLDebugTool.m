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
#import "LLScreenshotHelper.h"
#import "LLStorageManager.h"
#import "LLNetworkHelper.h"
#import "LLCrashHelper.h"
#import "LLLogHelper.h"
#import "LLAppInfoHelper.h"
#import "LLWindow.h"
#import "LLWindowViewController.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"
#import "LLConfig.h"
#import "LLTool.h"

static LLDebugTool *_instance = nil;

@interface LLDebugTool () <LLWindowDelegate>

@property (nonatomic , strong , nonnull) LLWindow *window;

@property (nonatomic , strong , nonnull) LLWindowViewController *windowViewController;

@property (nonatomic , copy , nonnull) NSString *versionNumber;

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
        LLConfigAvailableFeature available = [LLConfig sharedConfig].availables;
        if (available & LLConfigAvailableCrash) {
            // Open crash helper
            [[LLCrashHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableLog) {
            // Open log helper
            [[LLLogHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableNetwork) {
            // Open network monitoring
            [[LLNetworkHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableAppInfo) {
            // Open app monitoring
            [[LLAppInfoHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableScreenshot) {
            // Open screenshot
            [[LLScreenshotHelper sharedHelper] setEnable:YES];
        }
        // show window
        [self showWindow];
    }
}

- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        // Close screenshot
        [[LLScreenshotHelper sharedHelper] setEnable:NO];
        // Close app monitoring
        [[LLAppInfoHelper sharedHelper] setEnable:NO];
        // Close network monitoring
        [[LLNetworkHelper sharedHelper] setEnable:NO];
        // Close log helper
        [[LLLogHelper sharedHelper] setEnable:NO];
        // Close crash helper
        [[LLCrashHelper sharedHelper] setEnable:NO];
        // hide window
        [self hideWindow];
    }
}

- (void)showWindow
{
    self.window.hidden = NO;
    [self.windowViewController showExplorerView];
}

- (void)hideWindow
{
    self.window.hidden = YES;
    [self.windowViewController hideExplorerView];
}

- (void)showExplorerView {
    [self.windowViewController showExplorerView];
}

- (void)hideExplorerView {
    [self.windowViewController hideExplorerView];
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
    [self showDebugViewControllerWithIndex:index params:nil];
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index params:(NSDictionary <NSString *,id>*)params {
    [self.windowViewController presentTabbarWithIndex:index params:params];
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message {
    if (![LLConfig sharedConfig].showDebugToolLog) {
        NSArray *toolEvent = @[kLLLogHelperDebugToolEvent,kLLLogHelperFailedLoadingResourceEvent];
        if ([toolEvent containsObject:onEvent]) {
            return;
        }
    }
    [[LLLogHelper sharedHelper] logInFile:file function:function lineNo:lineNo level:level onEvent:onEvent message:message];
}

#pragma mark - LLWindowDelegate
- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    return [self.windowViewController shouldReceiveTouchAtWindowPoint:pointInWindow];
}

- (BOOL)canBecomeKeyWindow {
    return [self.windowViewController wantsWindowToBecomeKey];
}

#pragma mark - Primary
/**
 Initial something.
 */
- (void)initial {
    // Set Default
    _isBetaVersion = YES;

    _versionNumber = @"1.3.0";

    _version = _isBetaVersion ? [_versionNumber stringByAppendingString:@"(BETA)"] : _versionNumber;
    
    // Check version.
    [self checkVersion];
}

- (void)checkVersion {
    [LLTool createDirectoryAtPath:[LLConfig sharedConfig].folderPath];
    __block NSString *filePath = [[LLConfig sharedConfig].folderPath stringByAppendingPathComponent:@"LLDebugTool.plist"];
    NSMutableDictionary *localInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (!localInfo) {
        localInfo = [[NSMutableDictionary alloc] init];
    }
    NSString *version = localInfo[@"version"];
    // localInfo will be nil before version 1.1.2
    if (!version) {
        version = @"0.0.0";
    }
    
    if ([self.versionNumber compare:version] == NSOrderedDescending) {
        // Do update if needed.
        [self updateSomethingWithVersion:version completion:^(BOOL result) {
            if (!result) {
                NSLog(@"Failed to update old data");
            }
            [localInfo setObject:self.versionNumber forKey:@"version"];
            [localInfo writeToFile:filePath atomically:YES];
        }];
    }
    
    if (self.isBetaVersion) {
        // This method called in instancetype, can't use macros to log.
        [self logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ level:LLConfigLogLevelAlert onEvent:kLLLogHelperDebugToolEvent message:kLLLogHelperUseBetaAlert];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check whether has a new LLDebugTool version.
        if ([LLConfig sharedConfig].autoCheckDebugToolVersion) {
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
                                if ([self.version compare:newVersion] == NSOrderedAscending) {
                                    NSString *message = [NSString stringWithFormat:@"A new version for LLDebugTool is available, New Version : %@, Current Version : %@",newVersion,self.version];
                                    [self logInFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) lineNo:__LINE__ level:LLConfigLogLevelAlert onEvent:kLLLogHelperDebugToolEvent message:message];
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

- (void)updateSomethingWithVersion:(NSString *)version completion:(void (^)(BOOL result))completion {
    // Refactory database. Need rename tableName and table structure.
    if ([version compare:@"1.1.3"] == NSOrderedAscending) {
        [[LLStorageManager sharedManager] updateDatabaseWithVersion:@"1.1.3" complete:^(BOOL result) {
            if (completion) {
                completion(result);
            }
        }];
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

#pragma mark - Lazy
- (LLWindow *)window {
    if (!_window) {
        _window = [[LLWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.rootViewController = self.windowViewController;
        _window.delegate = self;
    }
    return _window;
}

- (LLWindowViewController *)windowViewController {
    if (!_windowViewController) {
        _windowViewController = [[LLWindowViewController alloc] init];
    }
    return _windowViewController;
}

@end
