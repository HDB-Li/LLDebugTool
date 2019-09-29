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
#import "LLMacros.h"
#import "LLConfig.h"
#import "LLFactory.h"
#import "LLThemeManager.h"

@interface LLBaseViewController ()

@end

@implementation LLBaseViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self resetDefaultSettings];
    [self setNavigationSettings];
    [self addObservers];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
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

- (void)showActionSheetWithTitle:(NSString *)title actions:(NSArray *)actions currentAction:(NSString *)currentAction completion:(void (^)(NSInteger index))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < actions.count; i++) {
        NSString *actionTitle = actions[i];
        __block NSInteger index = i;
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(index);
            }
        }];
        if (currentAction && [actionTitle isEqualToString:currentAction]) {
            action.enabled = NO;
            [action setValue:[UIImage LL_imageNamed:kSelectImageName] forKey:@"image"];
        }
        [alert addAction:action];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leftItemClick:(UIButton *)sender {
    
}

- (void)rightItemClick:(UIButton *)sender {
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (void)initNavigationItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName isLeft:(BOOL)flag {
    if (flag) {
        UIButton *btn = [self navigationButtonWithTitle:title imageName:imageName target:self action:@selector(leftItemClick:)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.leftNavigationButton = btn;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    } else {
        UIButton *btn = [self navigationButtonWithTitle:title imageName:imageName target:self action:@selector(rightItemClick:)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightNavigationButton = btn;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

- (void)becomeVisable {
    
}

- (void)primaryColorChanged {
    [self setNavigationSettings];
}

- (void)backgroundColorChanged {
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    self.navigationController.navigationBar.barTintColor = [LLThemeManager shared].backgroundColor;
}

#pragma mark - Over Write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIView *view in self.view.subviews) {
        [self layoutViewsAndSubviews:view];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Primary
- (void)resetDefaultSettings {
    // Used to solve problems caused by modifying some systems default values with Runtime in the project.
    // Hopefully you changed these defaults at runtime in viewDidLoad, not viewWillAppear or viewDidAppear
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = YES;
#pragma clang diagnostic pop
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setNavigationSettings {
    if (self.navigationController) {
        self.navigationItem.hidesBackButton = YES;
        
        [self initCloseLeftNavigationItem];
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            UIButton *btn = [self navigationButtonWithTitle:nil imageName:kBackImageName target:self action:@selector(backAction:)];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItems = @[backButtonItem, self.navigationItem.leftBarButtonItem];
        }
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].primaryColor}];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.tintColor = [LLThemeManager shared].primaryColor;
        self.navigationController.navigationBar.barTintColor = [LLThemeManager shared].backgroundColor;
    }
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeManagerUpdatePrimaryColorNotificaion:) name:kThemeManagerUpdatePrimaryColorNotificaionName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeManagerUpdateBackgroundColorNotificaion:) name:kThemeManagerUpdateBackgroundColorNotificaionName object:nil];
}

- (void)initCloseLeftNavigationItem {
    [self initNavigationItemWithTitle:nil imageName:kCloseImageName isLeft:YES];
}

- (UIButton *)navigationButtonWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(id _Nullable)target action:(SEL _Nullable)action {
    UIButton *btn = [LLFactory getButton:nil frame:CGRectMake(0, 0, 30, 40) target:target action:action];
    btn.showsTouchWhenHighlighted = NO;
    btn.tintColor = [LLThemeManager shared].primaryColor;
    if ([title length]) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
        [btn setImage:[[UIImage LL_imageNamed:imageName] imageWithRenderingMode:mode] forState:UIControlStateNormal];
    }
    return btn;
}

- (void)layoutViewsAndSubviews:(UIView *)view {
    [view setNeedsLayout];
    for (UIView *subview in view.subviews) {
        [self layoutViewsAndSubviews:subview];
    }
}

#pragma mark - Event response
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - kThemeManagerUpdatePrimaryColorNotificaionName
- (void)didReceiveThemeManagerUpdatePrimaryColorNotificaion:(NSNotification *)notification {
    [self primaryColorChanged];
}

#pragma mark - kThemeManagerUpdateBackgroundColorNotificaionName
- (void)didReceiveThemeManagerUpdateBackgroundColorNotificaion:(NSNotification *)notification {
    [self backgroundColorChanged];
}

#pragma mark - Over write
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (![viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
