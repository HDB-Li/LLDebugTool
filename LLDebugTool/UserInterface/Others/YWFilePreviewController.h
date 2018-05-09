//
//  YWFilePreviewController.h
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

#import <QuickLook/QuickLook.h>

typedef enum : NSUInteger {
    YWJumpPush,//push 无动画
    YWJumpPushAnimat,//push 有动画
    YWJumpPresent,//Present 无动画
    YWJumpPresentAnimat,//Present 有动画
} YWJumpMode;

@interface YWFilePreviewController : QLPreviewController

/** 预览多个文件 单个文件时数组传一个 */
- (void)previewFileWithPaths:(NSArray <NSString *>*)filePathArr on:(UIViewController *)vc jump:(YWJumpMode)jump index:(NSInteger)index;

/** 将要退出 */
- (void)setWillDismissBlock:(void (^)(void))willDismissBlock;

/** 已经退出 */
- (void)setDidDismissBlock:(void (^)(void))didDismissBlock;

/** 将要访问文件中的Url回调  BOOL 是否允许访问*/
- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock;

@end
