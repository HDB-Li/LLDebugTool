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
#import "LLAppHelper.h"
#import "LLWindow.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"
#import "LLConfig.h"
#import "LLTool.h"

static LLDebugTool *_instance = nil;

@interface LLDebugTool ()

@property (nonatomic , strong) LLWindow *window;

@property (nonatomic , copy) NSString *versionNumber;

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
            [[LLAppHelper sharedHelper] setEnable:YES];
        }
        if (available & LLConfigAvailableScreenshot) {
            // Open screenshot
            [[LLScreenshotHelper sharedHelper] setEnable:YES];
        }
        // show window
        [self.window showWindow];
    }
}

- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        // Close screenshot
        [[LLScreenshotHelper sharedHelper] setEnable:NO];
        // Close app monitoring
        [[LLAppHelper sharedHelper] setEnable:NO];
        // Close network monitoring
        [[LLNetworkHelper sharedHelper] setEnable:NO];
        // Close log helper
        [[LLLogHelper sharedHelper] setEnable:NO];
        // Close crash helper
        [[LLCrashHelper sharedHelper] setEnable:NO];
        // hide window
        [self.window hideWindow];
    }
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
    [self.window.windowViewController showDebugViewControllerWithIndex:index];
}

- (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(int)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message, ...  {
    if (![LLConfig sharedConfig].showDebugToolLog) {
        NSArray *toolEvent = @[kLLLogHelperDebugToolEvent,kLLLogHelperFailedLoadingResourceEvent];
        if ([toolEvent containsObject:onEvent]) {
            return;
        }
    }
    [[LLLogHelper sharedHelper] logInFile:file function:function lineNo:lineNo level:level onEvent:onEvent message:message];
}

#pragma mark - Primary
/**
 Initial something.
 */
- (void)initial {
    // Set Default
    _isBetaVersion = NO;
    _versionNumber = @"1.1.5";
    _version = _isBetaVersion ? [_versionNumber stringByAppendingString:@"(BETA)"] : _versionNumber;
    
    // Check version.
    [self checkVersion];
    // Set window.
    CGFloat windowWidth = [LLConfig sharedConfig].suspensionBallWidth;
    self.window = [[LLWindow alloc] initWithFrame:CGRectMake(0, 0, windowWidth, windowWidth)];
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
}

- (void)updateSomethingWithVersion:(NSString *)version completion:(void (^)(BOOL result))completion {
    // Refactory database. Need rename tableName and table structure.
    if ([version compare:@"1.1.3"] == NSOrderedAscending) {
        [[LLStorageManager sharedManager] updateDatabaseWithVersion:@"1.1.3" complete:^(BOOL result) {
            if (completion) {
                completion(result);
            }
        }];
    }
}

@end
