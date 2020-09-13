//
//  LLScreenshotPreviewViewController.m
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

#import "LLScreenshotPreviewViewController.h"

#import <Photos/PHPhotoLibrary.h>

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLFormatterTool.h"
#import "LLInternalMacros.h"
#import "LLScreenshotBaseOperation.h"
#import "LLScreenshotHelper.h"
#import "LLScreenshotImageView.h"
#import "LLScreenshotToolbar.h"
#import "LLToastUtils.h"

#import "UIView+LL_Utils.h"
#import "UIViewController+LL_Utils.h"

@interface LLScreenshotPreviewViewController () <LLScreenshotToolbarDelegate>

@property (nonatomic, strong) LLScreenshotImageView *imageView;

@property (nonatomic, strong) LLScreenshotToolbar *toolBar;

@property (nonatomic, assign) CGRect originalImageFrame;

@property (nonatomic, copy) NSString *name;

@end

@implementation LLScreenshotPreviewViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.name = [LLFormatterTool stringFromDate:[NSDate date] style:FormatterToolDateStyle3];

    CGFloat rate = 0.1;
    CGFloat toolBarHeight = 80;
    CGFloat imgViewWidth = (1 - rate * 2) * LL_SCREEN_WIDTH;
    CGFloat imgViewHeight = (1 - rate * 2) * LL_SCREEN_HEIGHT;
    CGFloat imgViewTop = (rate * 2 * LL_SCREEN_HEIGHT - toolBarHeight) / 2.0;
    // Init ImageView
    self.imageView = [[LLScreenshotImageView alloc] initWithFrame:CGRectMake(rate * LL_SCREEN_WIDTH, imgViewTop, imgViewWidth, imgViewHeight)];
    self.originalImageFrame = self.imageView.frame;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];

    // Init Controls
    self.toolBar = [[LLScreenshotToolbar alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height + kLLGeneralMargin, self.imageView.frame.size.width, toolBarHeight)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Primary
- (void)cancelAction {
    [self componentDidFinish];
}

- (void)confirmAction {
    [self doConfirmAction:self.name];
}

- (void)doConfirmAction:(NSString *)name {
    self.toolBar.hidden = YES;
    UIImage *image = [self.imageView LL_convertViewToImage];
    if (image) {
        [LLDT_CC_Screenshot saveScreenshot:image name:name complete:nil];
        [self saveInAlbumAndSandboxWithImage:image requestAuthorization:YES];
    } else {
        self.toolBar.hidden = NO;
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"screenshot.save.fail")];
        [self componentDidFinish];
    }
}

- (void)saveInAlbumAndSandboxWithImage:(UIImage *)image requestAuthorization:(BOOL)requestAuthorization {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"screenshot.save.in.sandbox.album")];
        [self toastShareWithImage:image];
    } else if (requestAuthorization && [LLDT_CC_Screenshot canRequestPhotoLibraryAuthorization]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveInAlbumAndSandboxWithImage:image requestAuthorization:NO];
            });
        }];
    } else {
        [[LLToastUtils shared] toastMessage:LLLocalizedString(@"screenshot.save.in.sandbox")];
        [self toastShareWithImage:image];
    }
}

- (void)toastShareWithImage:(UIImage *)image {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [self componentDidFinish];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - LLScreenshotToolbarDelegate
- (void)LLScreenshotToolbar:(LLScreenshotToolbar *)toolBar didSelectedAction:(LLScreenshotAction)action selectorModel:(LLScreenshotSelectorModel *)selectorModel {
    if (action <= LLScreenshotActionText) {
        self.imageView.currentAction = action;
        self.imageView.currentSelectorModel = selectorModel;
    } else if (action == LLScreenshotActionBack) {
        [self.imageView removeLastOperation];
    } else if (action == LLScreenshotActionCancel) {
        [self cancelAction];
    } else if (action == LLScreenshotActionConfirm) {
        [self confirmAction];
    }
}

#pragma mark - UIKeyboardWillShowNotification
- (void)didReceiveKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.imageView.currentOperation isKindOfClass:[LLScreenshotTextOperation class]]) {
        LLScreenshotTextOperation *operation = (LLScreenshotTextOperation *)self.imageView.currentOperation;
        CGFloat y = operation.textView.frame.origin.y + self.originalImageFrame.origin.y;
        CGFloat gap = y - endFrame.origin.y + 100;
        if (gap > 0) {
            [UIView animateWithDuration:duration
                             animations:^{
                                 CGRect oriRect = self.imageView.frame;
                                 self.imageView.frame = CGRectMake(oriRect.origin.x, self.originalImageFrame.origin.y - gap, oriRect.size.width, oriRect.size.height);
                             }];
        }
    }
}

#pragma mark - UIKeyboardWillHideNotification
- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (!CGRectEqualToRect(self.imageView.frame, self.originalImageFrame)) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.imageView.frame = self.originalImageFrame;
                         }];
    }
}

@end
