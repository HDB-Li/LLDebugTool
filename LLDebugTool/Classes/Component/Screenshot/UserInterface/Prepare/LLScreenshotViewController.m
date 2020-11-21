//
//  LLScreenshotViewController.m
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

#import "LLScreenshotViewController.h"

#import "LLComponentHandle.h"
#import "LLConst.h"
#import "LLConvenientScreenshotComponent.h"
#import "LLDebugConfig.h"
#import "LLFactory.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"

#import "UIView+LL_Utils.h"

@interface LLScreenshotViewController ()

@property (nonatomic, strong) UIButton *captureButton;

@end

@implementation LLScreenshotViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.updateBackgroundColor = NO;

    CGFloat width = 60;
    self.captureButton = [LLFactory getButton:self.view frame:CGRectMake((self.view.LL_width - 60) / 2.0, self.view.LL_bottom - kLLGeneralMargin * 2 - width, width, width) target:self action:@selector(captureButtonClicked:)];
    self.captureButton.tintColor = [LLThemeManager shared].primaryColor;
    [self.captureButton LL_setCornerRadius:width / 2.0];
    [self.captureButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    self.captureButton.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.captureButton setImage:[[UIImage LL_imageNamed:kCaptureImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];

    [self.captureButton addGestureRecognizer:pan];
}

#pragma mark - Over write
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint capturePoint = [self.view convertPoint:point toView:self.captureButton];
    if ([self.captureButton pointInside:capturePoint withEvent:event]) {
        return YES;
    }
    return NO;
}

#pragma mark - Event responses
- (void)captureButtonClicked:(UIButton *)sender {
    [LLComponentHandle executeAction:LLDebugToolActionConvenientScreenshot data:nil];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    CGPoint offsetPoint = [sender translationInView:sender.view];

    [sender setTranslation:CGPointZero inView:sender.view];

    [self changeFrameWithPoint:offsetPoint];
}

#pragma mark Primary
- (void)changeFrameWithPoint:(CGPoint)point {
    CGPoint center = self.captureButton.center;
    center.x += point.x;
    center.y += point.y;

    center.x = LL_MIN(center.x, LL_SCREEN_WIDTH);
    center.x = LL_MAX(center.x, 0);

    center.y = LL_MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = LL_MAX(center.y, 0);

    self.captureButton.center = center;

    if (self.captureButton.LL_left < 0) {
        self.captureButton.LL_left = 0;
    }
    if (self.captureButton.LL_right > LL_SCREEN_WIDTH) {
        self.captureButton.LL_right = LL_SCREEN_WIDTH;
    }
}

@end
