<p align="center" >
  <img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/header.png" alt="LLDebugTool" title="LLDebugTool">
</p>

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.0.3-blue.svg)](https://img.shields.io/badge/pod-v1.0.3-blue.svg)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C-yellow.svg)](https://img.shields.io/badge/Language-Objective--C-yellow.svg)

## 简介

[Click here for an English introduction](https://github.com/HDB-Li/LLDebugTool)

LLDebugTool是一款针对开发者和测试者的调试工具，它可以帮助你在非Xcode的情况下，进行数据分析和操作。

为您的下一个项目选择LLDebugTool，或者迁移到您现有的项目中——您会为此感到惊喜！

<div align="center">
<img src="https://github.com/HDB-Li/HDBImageRepository/blob/master/LLDebugTool/screenGif.gif" width="15%"></img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-1.png" width="15%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-3.png" width="15%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-4.png" width="15%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-5.png" width="15%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-6.png" width="15%"> </img>
</div>

## 最近更新 (1.0.3)

- 修复一些内存泄漏问题。

## 我能用LLDebugTool做什么?

- 检查网络请求或者查看某些事件的日志信息，而不必非在XCode运行下运行。这在解决测试人员的问题上很有用。

- 更轻松的筛选有用的信息。

- 更轻松的处理偶发的问题。

- 更轻松的分析崩溃原因。

- 更轻松的分享、预览或删除沙盒文件，这在开发阶段非常有用。

- 更轻松的观察App的CPU，内存，FPS等信息。

## 添加 LLDebugTool 到你的项目中

### CocoaPods

[CocoaPods](http://cocoapods.org) 是集成`LLDebugTool`的首选方式。

1. 添加 `pod 'LLDebugTool'` 到你的Podfile里。如果只想在Debug模式下使用，则添加`pod 'LLDebugTool' ,:configurations => ['Debug']` 到你的Podfile里。
2. 终端输入`pod install`来进行集成。搜索不到`LLDebugTool`时，可先运行`pod repo update`，再执行`pod install`。
3. 在你需要使用LLDebugTool的文件里添加`#import "LLDebug.h"`，或者直接在pch文件中添加`#import "LLDebug.h"`。

### 源文件

您可以直接将名为LLDebugTool文件夹的源文件添加到项目中。

1. 下载[最新的代码版本](https://github.com/HDB-Li/LLDebugTool/archive/master.zip)或将存储库作为git子模块添加到您的git跟踪项目中。
2. 在Xcode中打开项目，然后拖拽名为“LLDebugTool”的源文件夹到你的项目中。当提示Choose options for adding these files时，务必勾选Copy items if needed这项。
3. 集成[FMDB](https://github.com/ccgus/fmdb)到项目中，FMDB是一个围绕SQLite的Objective-C包装器开源库。
4. 在你需要使用LLDebugTool的文件里添加`#import "LLDebug.h"`，或者直接在pch文件中添加`#import "LLDebug.h"`。

## 如何使用

### 启动

你需要在"application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions"中启动LLDebugTool，否则你可能会丢掉某些信息。

如果你想自定义一些参数，你需要在调用"startWorking"前配置这些参数。更详细的配置信息请看[LLConfig.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Config/LLConfig.h)。

* `快速启动`

```
#import "AppDelegate.h"
#import "LLDebug.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // The default color configuration is green background and white text color. 

    // Start working.
    [[LLDebugTool sharedTool] startWorking];
    
    // Write your project code here.
    return YES;
}
```

* `使用自定义的配置启动`

```
#import "AppDelegate.h"
#import "LLDebug.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // The default color configuration is LLConfigColorStyleHack. 
    
    // If you want to use other color configurations, you can use the following line.
    [LLConfig sharedConfig].colorStyle = LLConfigColorStyleSimple;
    
    // If you want to use a custom color configuration, you can use the following line.
    [[LLConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    
    // If you don't want to use color configuration, you can use the following line.
    [LLConfig sharedConfig].useSystemColor = YES;
    
    // Start working.
    [[LLDebugTool sharedTool] startWorking];

    // Write your project code here.
    return YES;
}
```

### 日志

打印和保存一个日志。 更多的log宏信息查看[LLLogHelper.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Helper/LogHelper/LLLogHelper.h)。

* `保存日志`

```
#import "LLDebug.h"

- (void)testNormalLog {
    // Insert an LLog where you want to print.
    LLog(@"Message you want to save or print.");
}
```

* `Save Log with event and level`

```
#import "LLDebug.h"

- (void)test
- (void)testEventErrorLog {
    // Insert an LLog_Error_Event where you want to print an event and level log.
    LLog_Error_Event(@"The event that you want to mark. such as bugA, taskB or processC.",@"Message you want to save or print.");
}
```

### 网络请求

你不需要做任何操作，只需要调用了"startWorking"就可以监控大部分的网络请求，包括使用NSURLSession，NSURLConnection和AFNetworking。如果你发现某些情况下无法监控网络请求，请打开一个issue来告诉我。

### 崩溃

你不需要做任何操作，只需要调用"startWorking"就可以截获崩溃，保存崩溃信息、原因和堆栈信息，并且也会同时保存当次网络请求和日志信息。

### App信息

LLDebugTool会监控app的CPU，内存和FPS。你可以更便捷的查看app的各种信息。

### 沙盒

LLDebugTool提供了一个快捷的方式来查看和操作沙盒文件，你可以更轻松的删除沙盒中的文件/文件夹，或者通过airdrop来分享文件/文件夹。只要是apple支持的文件格式，你可以直接通过LLDebugTool来预览。

### 更多使用

你可以下载并运行["LLDebugToolDemo"](https://github.com/HDB-Li/LLDebugTool/archive/master.zip)来发现LLDebugTool的更多使用方式。Demo是在XCode9.3，ios 11.3，cocoapods 1.5.0下运行的，如果有任何版本兼容问题，请告诉我。

## 要求

LLDebugTool在支持ios8+，并且需要使用ARC模式。使用到的框架已经包含在大多数Xcode模板中:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `malloc`

* `mach-o`

* `mach`

* `QuickLook`

* `objc`

* `sys`

## 结构

* `LLDebug.h` 公用头文件.

* `LLConfig` 配置文件。

    >用于自定义颜色、大小、标识和其他信息。如果您想要配置任何东西，您需要关注这个文件。
  
* `LLDebugTool` 工具文件。

    >用于启动和停止LLDebugTool，你需要看一下"LLDebugTool.h"这个文件。

* `Helper` 辅助文件。

    >如果你对功能的实现原理不感兴趣，那么可以忽略这个文件夹。
  
  - `LLAppHelper` 用于监视应用程序的各种属性。
  - `LLCrashHelper` 用于当App发生崩溃时，收集崩溃信息。
  - `LLLogHelper` 快速打印和保存日志。
  - `LLNetworkHelper` 用于监视网络请求。
  - `LLSandboxHelper` Sandbox Helper。用于查看和操作沙盒文件。
  - `LLStorageManager` Storage Helper。用于数据存储和读取。
 
* `UserInterface` UI文件。

    >如果你想要修改、查看或者学习UI方面的东西，你可以查看一下这个文件夹。
 
  - `Base` 父类文件
  - `Categories` 类扩展
  - `Others` 不通用的控件
  - `Resources` 图片资源
  - `Sections` 视图控制器
  - `Tool` 工具
 
## 联系

- **如果你需要帮助**，打开一个issue。
- **如果你想问一个普遍的问题**，打开一个issue。
- **如果你发现了一个bug**，_并能提供可靠的复制步骤_，打开一个issue。
- **如果你有一个功能请求**，打开一个issue。
- **如果你发现有什么不对或不喜欢的地方**，就打开一个issue。
- **如果你有一些好主意或者一些需求**，请发邮件(llworkinggroup@qq.com)给我。
- **如果你想贡献**，提交一个pull request。

## 联系

- 可以在[简书](https://www.jianshu.com/u/a3c82fae85be)中发私信给我。
- 可以发邮件到[llworkinggroup@qq.com](llworkinggroup@qq.com)

## 更新日志

可以在 [CHANGELOG](CHANGELOG.md) 中找到每个LLDebugTool版本的简要总结。

## 许可

这段代码是根据 [MIT license](LICENSE) 的条款和条件发布的。

## Thanks

- [Dotzu](https://github.com/remirobert/Dotzu)
