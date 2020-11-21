//
//  AppDelegate.m
//  LLDebugToolDemo
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 li. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

// If you integrate with cocoapods, used #import <LLDebug.h>.
#import <LLDebugTool/LLDebugTool.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];

    // Start working with config.
    [[LLDebugTool sharedTool] startWorkingWithConfigBlock:^(LLDebugConfig *_Nonnull config) {

        //####################### Color Style #######################//
        // Uncomment one of the following lines to change the color configuration.
        // config.colorStyle = LLDebugConfigColorStyleSystem;
        // [config configBackgroundColor:[UIColor orangeColor] primaryColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];

        //####################### User Identity #######################//
        // Use this line to tag user. More config please see "LLDebugConfig.h".
        config.userIdentity = @"Miss L";

        //####################### Window Style #######################//
        // Uncomment one of the following lines to change the window style.
        // config.entryWindowStyle = LLDebugConfigEntryWindowStyleTitle;

        //####################### Html #######################//
        config.defaultHtmlUrl = @"https://github.com/HDB-Li/LLDebugTool";

        //####################### Location #######################//
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [config addMockRouteDirectory:documentsPath];
    }];

    /*
     // You can start LLDebugTool use notification and didn't import anything.
    NSDictionary *data = @{
        @"colorStyle" : @(2), // LLDebugConfigColorStyleSystem
        @"userIdentity" : @"Miss L",
        @"entryWindowStyle" : @(1), //LLDebugConfigEntryWindowStyleTitle
        @"defaultHtmlUrl" : @"https://github.com/HDB-Li/LLDebugTool"
    };

    [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolStartWorkingNotification object:nil userInfo:@{LLDebugToolStartWorkingConfigNotificationKey : data}];
    */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"UncaughtExceptionHandler: \n%@\n%@\n%@", arr, reason, name);
}

@end
