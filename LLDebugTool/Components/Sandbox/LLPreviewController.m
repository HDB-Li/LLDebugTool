//
//  LLPreviewController.m
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

#import "LLPreviewController.h"

@interface LLPreviewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

//@property (nonatomic, strong) NSArray *filePathArr;

@end

@implementation LLPreviewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Public
- (void)previewFilesWithPaths:(NSArray <NSString *>*)filePaths on:(UIViewController *)viewController mode:(LLPreviewControllerPresentMode)mode index:(NSInteger)index {
//    self.filePathArr = filePaths;
    [self presentWithMode:mode on:viewController];
    if (index >= filePaths.count) {
        index = 0;
    }
    self.currentPreviewItemIndex = index;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.filePaths.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL *url = [NSURL fileURLWithPath:self.filePaths[index]];
    return url;
}

#pragma mark - Primary
- (void)presentWithMode:(LLPreviewControllerPresentMode)mode on:(UIViewController *)viewController {
    switch (mode) {
        case LLPreviewControllerPresentModeAnimatedPush: {
            [viewController.navigationController pushViewController:self animated:YES];
            break;
        }
        case LLPreviewControllerPresentModePush: {
            [viewController.navigationController pushViewController:self animated:NO];
            break;
        }
        case LLPreviewControllerPresentModeAnimatedPresent: {
            [viewController presentViewController:self animated:YES completion:nil];
            break;
        }
        case LLPreviewControllerPresentModePresent: {
            [viewController presentViewController:self animated:NO completion:nil];
            break;
        }
    }
    [self reloadData];
}

@end
