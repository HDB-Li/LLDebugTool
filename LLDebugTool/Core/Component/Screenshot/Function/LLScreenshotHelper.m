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

#import "LLScreenshotPreviewViewController.h"
#import "LLScreenshotComponent.h"
#import "LLInternalMacros.h"
#import "LLFormatterTool.h"
#import "LLConfig.h"
#import "LLTool.h"

#import "LLRouter+Screenshot.h"

static LLScreenshotHelper *_instance = nil;

@interface LLScreenshotHelper ()
    
@property (copy, nonatomic) NSString *screenshotFolderPath;
    
@end

@implementation LLScreenshotHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLScreenshotHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (void)setEnable:(BOOL)enable {
    if (_enable != enable) {
        _enable = enable;
        if (enable) {
            [self registerScreenshot];
        } else {
            [self unregisterScreenshot];
        }
    }
}

- (void)simulateTakeScreenshot {
    if (self.enable) {
        UIImage *image = [self imageFromScreen];
        if (image) {
            NSDictionary *data = @{kLLComponentWindowRootViewControllerKey : NSStringFromClass(LLScreenshotPreviewViewController.class),kLLComponentWindowRootViewControllerPropertiesKey : @{@"image" : image}};
            [[[LLScreenshotComponent alloc] init] componentDidLoad:data];
        }
    }    
}

- (UIImage *_Nullable)imageFromScreen {
    return [self imageFromScreen:0];
}

- (UIImage *_Nullable)imageFromScreen:(CGFloat)scale {
    return [LLRouter screenshotWithScale:scale];
}

#pragma mark - Screenshot
- (void)saveScreenshot:(UIImage *)image name:(NSString *)name complete:(void (^ __nullable)(BOOL finished))complete {
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveScreenshot:image name:name complete:complete];
        });
        return;
    }
    if (name.length == 0) {
        name = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle3];
    }
    name = [name stringByAppendingPathExtension:@"png"];
    NSString *path = [self.screenshotFolderPath stringByAppendingPathComponent:name];
    BOOL ret = [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
    if (complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(ret);
        });
    }
}

#pragma mark - UIApplicationUserDidTakeScreenshotNotification
- (void)receiveUserDidTakeScreenshotNotification:(NSNotification *)notification {
    [self simulateTakeScreenshot];
}

#pragma mark - Primary
- (void)initial {
    self.screenshotFolderPath = [[LLConfig shared].folderPath stringByAppendingPathComponent:@"Screenshot"];
    [LLTool createDirectoryAtPath:self.screenshotFolderPath];
}

- (void)registerScreenshot {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)unregisterScreenshot {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
