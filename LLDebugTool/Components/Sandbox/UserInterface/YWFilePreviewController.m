//
//  YWFilePreviewController.m
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

#import "YWFilePreviewController.h"

@interface YWFilePreviewController ()
<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, copy) void(^willDismissBlock)(void);
@property (nonatomic, copy) void(^didDismissBlock)(void);
@property (nonatomic, copy) BOOL(^shouldOpenUrlBlock)(NSURL *url, id <QLPreviewItem>item);
@property (nonatomic, strong) NSArray *filePathArr;

@end

@implementation YWFilePreviewController

#pragma mark - life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - private methods
- (void)jumpWith:(YWJumpMode)jump on:(UIViewController *)vc{
    switch (jump) {
        case YWJumpPush:
        case YWJumpPushAnimat:
            [vc.navigationController pushViewController:self animated:(jump == YWJumpPushAnimat)];
            break;
        case YWJumpPresent:
        case YWJumpPresentAnimat:
            [vc presentViewController:self animated:(jump == YWJumpPresentAnimat) completion:nil];
            break;
    }
    [self reloadData];
}

#pragma mark - public methods
- (void)previewFileWithPaths:(NSArray <NSString *>*)filePathArr on:(UIViewController *)vc jump:(YWJumpMode)jump index:(NSInteger)index {
    self.filePathArr = filePathArr;
    [self jumpWith:jump on:vc];
    if (index >= filePathArr.count) {
        index = 0;
    }
    self.currentPreviewItemIndex = index;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.filePathArr.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL *url = [NSURL fileURLWithPath:self.filePathArr[index]];
    return  url;
}

#pragma mark - QLPreviewControllerDelegate
/*!
 * @abstract Invoked before the preview controller is closed.
 */
- (void)previewControllerWillDismiss:(QLPreviewController *)controller{
    !self.willDismissBlock?:self.willDismissBlock();
}

/*!
 * @abstract Invoked after the preview controller is closed.
 */
- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    !self.didDismissBlock?:self.didDismissBlock();
}

/*!
 * @abstract Invoked by the preview controller before trying to open an URL tapped in the preview.
 * @result Returns NO to prevent the preview controller from calling -[UIApplication openURL:] on url.
 * @discussion If not implemented, defaults is YES.
 */
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return !self.shouldOpenUrlBlock?YES:self.shouldOpenUrlBlock(url, item);
}

#pragma mark - event response

#pragma mark - getters and setters
- (void)setWillDismissBlock:(void (^)(void))willDismissBlock{
    if(!willDismissBlock) return;
    _willDismissBlock = [willDismissBlock copy];
}

- (void)setDidDismissBlock:(void (^)(void))didDismissBlock{
    if(!didDismissBlock) return;
    _didDismissBlock = [didDismissBlock copy];
}

- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock{
    if(!shouldOpenUrlBlock) return;
    _shouldOpenUrlBlock = [shouldOpenUrlBlock copy];
}


@end
