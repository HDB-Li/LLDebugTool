//
//  LLScreenshotHelper.m
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

#import "LLScreenshotHelper.h"

#import "LLConvenientScreenshotComponent.h"
#import "LLDebugConfig.h"
#import "LLFormatterTool.h"
#import "LLInternalMacros.h"
#import "LLScreenshotPreviewViewController.h"
#import "LLScreenshotTool.h"
#import "LLTool.h"

@interface LLScreenshotHelper ()

@property (copy, nonatomic) NSString *screenshotFolderPath;

@end

@implementation LLScreenshotHelper

#pragma mark - Over write
- (void)start {
    [super start];
    [self registerScreenshot];
}

- (void)stop {
    [super stop];
    [self unregisterScreenshot];
}

#pragma mark - LLScreenshotHelperDelegate
- (BOOL)simulateTakeScreenshot {
    UIImage *image = [self imageFromScreen];
    if (image) {
        NSDictionary *data = @{ LLComponentDelegateRootViewControllerPropertiesKey: @{@"image": image} };
        [LLConvenientScreenshotComponent componentDidLoad:data];
        return YES;
    }
    return NO;
}

- (UIImage *)imageFromScreen {
    return [self imageFromScreen:0];
}

- (UIImage *)imageFromScreen:(CGFloat)scale {
    return [LLScreenshotTool screenshotWithScale:scale];
}

- (void)saveScreenshot:(UIImage *)image name:(NSString *)name complete:(void (^)(BOOL finished))complete {
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveScreenshot:image name:name complete:complete];
        });
        return;
    }
    [LLTool createDirectoryAtPath:self.screenshotFolderPath];
    NSString *imageName = name;
    if (imageName.length == 0) {
        imageName = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle3];
    }
    imageName = [imageName stringByAppendingPathExtension:@"png"];
    NSString *path = [self.screenshotFolderPath stringByAppendingPathComponent:imageName];
    BOOL ret = [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];

    if (complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(ret);
        });
    }
}

- (BOOL)canRequestPhotoLibraryAuthorization {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return (BOOL)infoDictionary[@"NSPhotoLibraryUsageDescription"];
}

#pragma mark - UIApplicationUserDidTakeScreenshotNotification
- (void)didReceiveApplicationUserDidTakeScreenshotNotification:(NSNotification *)notification {
    if (self.isEnabled) {
        [self simulateTakeScreenshot];
    }
}

#pragma mark - Primary
- (instancetype)init {
    if (self = [super init]) {
        self.screenshotFolderPath = [[LLDebugConfig shared].folderPath stringByAppendingPathComponent:@"Screenshot"];
    }
    return self;
}

- (void)registerScreenshot {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationUserDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)unregisterScreenshot {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
