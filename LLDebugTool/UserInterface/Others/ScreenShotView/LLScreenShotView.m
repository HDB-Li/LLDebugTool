//
//  LLScreenshotView.m
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

#import "LLScreenshotView.h"
#import <Photos/PHPhotoLibrary.h>
#import "LLScreenshotBaseOperation.h"
#import "LLScreenshotImageView.h"
#import "LLScreenshotToolbar.h"
#import "LLStorageManager.h"
#import "LLDebugTool.h"
#import "LLWindow.h"
#import "LLMacros.h"
#import "LLTool.h"

@interface LLScreenshotView () <LLScreenshotToolbarDelegate>

@property (nonatomic , strong , nonnull) LLScreenshotImageView *imageView;

@property (nonatomic , strong , nonnull) LLScreenshotToolbar *toolBar;

@property (nonatomic , assign) CGRect originalImageFrame;

@property (nonatomic , copy , nonnull) NSString *name;

@end

@implementation LLScreenshotView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initialWithImage:image];
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = CGRectMake(0, LL_SCREEN_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    [window addSubview:self];
    [[LLDebugTool sharedTool].window hideWindow];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, LL_SCREEN_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[LLDebugTool sharedTool].window showWindow];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (void)cancelAction {
    [self hide];
}

- (void)confirmAction {
    self.hidden = YES;
    __weak __block typeof(self) weakSelf = self;
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Note" message:@"Enter the image name" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.name;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.hidden = NO;
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.hidden = NO;
        [weakSelf doConfirmAction:alert.textFields.firstObject.text];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];

    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)doConfirmAction:(NSString *)name {
    self.toolBar.hidden = YES;
    UIImage *image = [self convertViewToImage:self.imageView];
    if (image) {
        [[LLStorageManager sharedManager] saveScreenshot:image name:name complete:nil];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [LLTool toastMessage:@"Save image in sandbox and album."];
        } else {
            [LLTool toastMessage:@"Save image in sandbox."];
        }
        [self hide];
    } else {
        self.toolBar.hidden = NO;
        [LLTool toastMessage:@"Save image failed."];
    }
}

#pragma mark - NSNotification
- (void)keyboardWillShowNotification:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.imageView.currentOperation isKindOfClass:[LLScreenshotTextOperation class]]) {
        LLScreenshotTextOperation *operation = (LLScreenshotTextOperation *)self.imageView.currentOperation;
        CGFloat y = operation.textView.frame.origin.y + self.originalImageFrame.origin.y;
        CGFloat gap = y - endFrame.origin.y + 100;
        if (gap > 0) {
            [UIView animateWithDuration:duration animations:^{
                CGRect oriRect = self.imageView.frame;
                self.imageView.frame = CGRectMake(oriRect.origin.x, self.originalImageFrame.origin.y - gap, oriRect.size.width, oriRect.size.height);
            }];
        }
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (!CGRectEqualToRect(self.imageView.frame, self.originalImageFrame)) {
        [UIView animateWithDuration:duration animations:^{
            self.imageView.frame = self.originalImageFrame;
        }];
    }
}

#pragma mark - Primary
- (void)initialWithImage:(UIImage *)image {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.name = [LLTool staticStringFromDate:[NSDate date]];
    
    CGFloat rate = 0.1;
    CGFloat toolBarHeight = 80;
    CGFloat imgViewWidth = (1 - rate * 2) * LL_SCREEN_WIDTH;
    CGFloat imgViewHeight = (1 - rate * 2) * LL_SCREEN_HEIGHT;
    CGFloat imgViewTop = (rate * 2 * LL_SCREEN_HEIGHT - toolBarHeight) / 2.0;
    // Init ImageView
    self.imageView = [[LLScreenshotImageView alloc] initWithFrame:CGRectMake(rate * LL_SCREEN_WIDTH, imgViewTop, imgViewWidth, imgViewHeight)];
    self.originalImageFrame = self.imageView.frame;
    self.imageView.image = image;
    [self addSubview:self.imageView];
    
    // Init Controls
    self.toolBar = [[LLScreenshotToolbar alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + self.imageView.frame.size.height + 10, self.imageView.frame.size.width, toolBarHeight)];
    self.toolBar.delegate = self;
    [self addSubview:self.toolBar];
}

- (UIImage *)convertViewToImage:(UIView *)view{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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

@end
