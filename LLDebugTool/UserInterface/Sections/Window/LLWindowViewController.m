//
//  LLWindowViewController.m
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

#import "LLWindowViewController.h"
#import "LLMacros.h"
#import "LLWindow.h"
#import "LLCrashVC.h"
#import "LLNetworkVC.h"
#import "LLLogVC.h"
#import "LLAppInfoVC.h"
#import "LLSandboxVC.h"
#import "LLAppHelper.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"
#import "LLBaseNavigationController.h"

@interface LLWindowViewController ()

@property (nonatomic , strong) UIView *sBallView;

@property (nonatomic , strong) UILabel *topLabel;

@property (nonatomic , strong) UILabel *bottomLabel;

@property (nonatomic , strong) UILabel *fpsLabel;

@property (nonatomic , assign) CGFloat sBallHideWidth;

@property (nonatomic , strong) UITabBarController *tabVC;

@end

@implementation LLWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)registerLLAppHelperNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLAppHelperDidUpdateAppInfosNotification:) name:LLAppHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)unregisterLLAppHelperNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LLAppHelperDidUpdateAppInfosNotificationName object:nil];
}

- (void)reloadTabbar {
    _tabVC = nil;
}

- (void)showDebugViewControllerWithIndex:(NSInteger)index {
    if ([[NSThread currentThread] isMainThread]) {
        [self.window hideWindow];
        UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController* vc2 = vc.presentedViewController;
        [vc2?:vc presentViewController:self.tabVC animated:YES completion:nil];
        self.tabVC.selectedIndex = index;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window hideWindow];
            UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
            UIViewController* vc2 = vc.presentedViewController;
            [vc2?:vc presentViewController:self.tabVC animated:YES completion:nil];
            self.tabVC.selectedIndex = index;
        });
    }
}

#pragma mark - LLAppHelperNotification
- (void)didReceiveLLAppHelperDidUpdateAppInfosNotification:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat cpu = [userInfo[LLAppHelperCPUKey] floatValue];
    CGFloat usedMemory = [userInfo[LLAppHelperMemoryUsedKey] floatValue];
    CGFloat fps = [userInfo[LLAppHelperFPSKey] floatValue];
    self.topLabel.text = [NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:usedMemory countStyle:NSByteCountFormatterCountStyleMemory]];
    self.bottomLabel.text = [NSString stringWithFormat:@"CPU:%.2f%%",cpu];
    self.fpsLabel.text = [NSString stringWithFormat:@"%ld",(long)fps];
}

#pragma mark - Primary
/**
 * initial method
 */
- (void)initial {
    [self initialDefaultSettings];
    self.view.frame = CGRectMake(0, 0, _sBallWidth, _sBallWidth);    
    [self createSubView];
    [self createGestureRecognizer];
}

- (void)initialDefaultSettings {
    // Check sBallWidth
    if (_sBallWidth < 70) {
        _sBallWidth = 70;
    }
    self.sBallHideWidth = 10;
    self.window.frame = CGRectMake(-self.sBallHideWidth, LL_SCREEN_HEIGHT / 3.0, _sBallWidth, _sBallWidth);
}

- (void)createSubView {
    // create sBallView
    self.sBallView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.sBallView.backgroundColor = [UIColor whiteColor];
    self.sBallView.layer.cornerRadius = _sBallWidth / 2.0;
    self.sBallView.layer.borderWidth = 2;
    self.sBallView.layer.borderColor = [LLConfig sharedConfig].systemTintColor.CGColor;
    self.sBallView.layer.masksToBounds = YES;
    self.sBallView.alpha = [LLConfig sharedConfig].normalAlpha;
    [self.view addSubview:self.sBallView];
    
    // create memoryLabel
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sBallWidth / 8.0, _sBallWidth / 4.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0)];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.textColor = [LLConfig sharedConfig].systemTintColor;
    self.topLabel.font = [UIFont systemFontOfSize:12];
    self.topLabel.adjustsFontSizeToFitWidth = YES;
    self.topLabel.text = @"loading";
    [self.sBallView addSubview:self.topLabel];
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0)];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.textColor = [LLConfig sharedConfig].systemTintColor;
    self.bottomLabel.font = [UIFont systemFontOfSize:10];
    self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    self.bottomLabel.text = @"loading";
    [self.sBallView addSubview:self.bottomLabel];
    
    self.fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.fpsLabel.center = CGPointMake(_sBallWidth * 0.85 + _sBallView.frame.origin.x, _sBallWidth * 0.15 + _sBallView.frame.origin.y);
    self.fpsLabel.textAlignment = NSTextAlignmentCenter;
    self.fpsLabel.backgroundColor = [LLConfig sharedConfig].systemTintColor;
    self.fpsLabel.textColor = [UIColor whiteColor];
    self.fpsLabel.font = [UIFont systemFontOfSize:12];
    self.fpsLabel.adjustsFontSizeToFitWidth = YES;
    self.fpsLabel.text = @"60";
    self.fpsLabel.layer.cornerRadius = self.fpsLabel.frame.size.height / 2.0;
    self.fpsLabel.layer.masksToBounds = YES;
    [self.view addSubview:self.fpsLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0 - 0.5, _sBallWidth * 3 / 4.0, 1)];
    line.backgroundColor = [LLConfig sharedConfig].systemTintColor;
    [self.sBallView addSubview:line];
    
    if (LLCONFIG_CUSTOM_COLOR) {
        self.sBallView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
        self.sBallView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
        self.topLabel.textColor = LLCONFIG_TEXT_COLOR;
        self.bottomLabel.textColor = LLCONFIG_TEXT_COLOR;
        line.backgroundColor = LLCONFIG_TEXT_COLOR;
        self.fpsLabel.backgroundColor = LLCONFIG_TEXT_COLOR;
        self.fpsLabel.textColor = LLCONFIG_BACKGROUND_COLOR;
    }
}

- (void)createGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self.sBallView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [self.sBallView addGestureRecognizer:tap];
}

- (void)becomeActive {
    self.sBallView.alpha = [LLConfig sharedConfig].activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.sBallView.alpha = [LLConfig sharedConfig].normalAlpha;
        // Calculate End Point
        CGFloat x = self.window.center.x;
        CGFloat y = self.window.center.y;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
    
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.window.frame.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.window.frame.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.window.frame.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.window.frame.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.window.center = endPoint;
        
        CGFloat horizontalPer = x1 < x ? 0.15 : 0.85;
        CGFloat verticalPer = endPoint.y > self.sBallWidth ? 0.15 : 0.85;
        CGPoint fpsCenter = CGPointMake(self.sBallWidth * horizontalPer + self.sBallView.frame.origin.x, self.sBallWidth * verticalPer + self.sBallView.frame.origin.y);
        self.fpsLabel.center = fpsCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    if (point.x > LL_SCREEN_WIDTH) {
        point.x = LL_SCREEN_WIDTH;
    } else if (point.x < 0) {
        point.x = 0;
    }
    if (point.y > LL_SCREEN_HEIGHT) {
        point.y = LL_SCREEN_HEIGHT;
    } else if (point.y < 0) {
        point.y = 0;
    }
    self.window.center = CGPointMake(point.x, point.y);
}

#pragma mark - Action
- (void)panGR:(UIPanGestureRecognizer *)gr {
    if ([LLConfig sharedConfig].suspensionBallMoveable) {
        CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
        if (gr.state == UIGestureRecognizerStateBegan)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
            [self becomeActive];
        } else if (gr.state == UIGestureRecognizerStateChanged) {
            [self changeSBallViewFrameWithPoint:panPoint];
        } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
            [self resignActive];
        }
    }
}

- (void)tapGR:(UITapGestureRecognizer *)gr {
    [self showDebugViewControllerWithIndex:0];
}

#pragma mark - Lazy load
- (UITabBarController *)tabVC {
    if (_tabVC == nil) {
        UITabBarController *tab = [[UITabBarController alloc] init];
        
        LLNetworkVC *networkVC = [[LLNetworkVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *networkNav = [[LLBaseNavigationController alloc] initWithRootViewController:networkVC];
        networkNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Network" image:[UIImage imageNamed:kNetworkImageName] selectedImage:nil];
        
        LLLogVC *logVC = [[LLLogVC alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *logNav = [[LLBaseNavigationController alloc] initWithRootViewController:logVC];
        logNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Log" image:[UIImage imageNamed:kLogImageName] selectedImage:nil];
        
        LLCrashVC *crashVC = [[LLCrashVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *crashNav = [[LLBaseNavigationController alloc] initWithRootViewController:crashVC];
        crashNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Crash" image:[UIImage imageNamed:kCrashImageName] selectedImage:nil];
        
        LLAppInfoVC *appInfoVC = [[LLAppInfoVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *appInfoNav = [[LLBaseNavigationController alloc] initWithRootViewController:appInfoVC];
        appInfoNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"App" image:[UIImage imageNamed:kAppImageName] selectedImage:nil];
        
        LLSandboxVC *sandboxVC = [[LLSandboxVC alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *sandboxNav = [[LLBaseNavigationController alloc] initWithRootViewController:sandboxVC];
        sandboxNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sandbox" image:[UIImage imageNamed:kSandboxImageName] selectedImage:nil];
        
        tab.viewControllers = @[networkNav,logNav,crashNav,appInfoNav,sandboxNav];

        if (LLCONFIG_CUSTOM_COLOR) {
            crashNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
            crashNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
            networkNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
            networkNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
            logNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
            logNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
            appInfoNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
            appInfoNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
            sandboxNav.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
            sandboxNav.navigationBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
            tab.tabBar.tintColor = LLCONFIG_TEXT_COLOR;
            tab.tabBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
        }
        _tabVC = tab;
    }
    return _tabVC;
}

@end
