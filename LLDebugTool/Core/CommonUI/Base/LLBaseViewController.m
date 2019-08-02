//
//  LLBaseViewController.m
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

#import "LLBaseViewController.h"
#import "LLImageNameConfig.h"
#import "LLTool.h"
#import "LLMacros.h"
#import "LLConfig.h"
#import "LLFactory.h"

@interface LLBaseViewController ()

@end

@implementation LLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseInitial];
}

#pragma mark - Public
- (void)toastMessage:(NSString *)message {
    [LLTool toastMessage:message];
}

- (void)showAlertControllerWithMessage:(NSString *)message handler:(void (^)(NSInteger action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Note" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if (handler) {
            handler(0);
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        if (handler) {
            handler(1);
        }
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leftItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

#pragma mark - Primary
- (void)baseInitial {
    [self resetDefaultSettings];
    self.view.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    [self initNavigationItems];
}

- (void)initNavigationItems {
    if (self.navigationController.viewControllers.count <= 1) {
        UIButton *btn = [LLFactory getButton:nil frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(leftItemClick)];
        btn.showsTouchWhenHighlighted = NO;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
        UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
        [btn setImage:[[UIImage LL_imageNamed:kCloseImageName] imageWithRenderingMode:mode] forState:UIControlStateNormal];
    }
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : LLCONFIG_TEXT_COLOR}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
}

- (void)resetDefaultSettings {
    // Used to solve problems caused by modifying some systems default values with Runtime in the project.
    // Hopefully you changed these defaults at runtime in viewDidLoad, not viewWillAppear or viewDidAppear
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = YES;
#pragma clang diagnostic pop
    self.navigationController.navigationBar.translucent = YES;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
