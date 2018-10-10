<p align="center" >
  <img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/header.png" alt="LLDebugTool" title="LLDebugTool">
</p>

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.2.1-blue.svg)](https://img.shields.io/badge/pod-v1.2.1-blue.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)
[![Twitter](https://img.shields.io/badge/twitter-@HdbLi-1DA1F2.svg)](https://twitter.com/HdbLi)

## 简介

[Click here for an English introduction](https://github.com/HDB-Li/LLDebugTool)

LLDebugTool是一款针对开发者和测试者的调试工具，它可以帮助你在非Xcode的情况下，进行数据分析和操作。

[LLDebugToolSwift](https://github.com/HDB-Li/LLDebugToolSwift)是针对[LLDebugTool](https://github.com/HDB-Li/LLDebugTool)的Swift扩展，它提供了LLDebugTool的Swift接口，LLDebugToolSwift会和LLDebugTool同步更新。

如果你的项目是一个Objective-C项目，你可以使用`LLDebugTool`，如果你的额项目是一个Swift项目或者包含Swift文件，你可以使用`LLDebugToolSwift`。

为您的下一个项目选择LLDebugTool，或者迁移到您现有的项目中——您会为此感到惊喜！

#### Gif

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/screenGif.gif" width="20%"></img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenGif-Screenshot.gif" width="20%"></img>
</div>

#### ScreenShots

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-1.png" width="18%"></img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-3.png" width="18%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-4.png" width="18%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-5.png" width="18%"> </img>
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-6.png" width="18%"> </img>
</div>

## 最近更新 (1.2.1)

###  修复显示Bug。

`LLDebugTool` 现在已经支持组件化了。现在你可以集成某一个或者多个模块到你自己的**Debug 工具**里。你可以直接使用每个模块内包含的视图控制器，或者只调用`Function`文件夹下的功能，然后自己搭建UI。

如何使用组件化，具体请看Wiki[使用组件化](https://github.com/HDB-Li/LLDebugTool/wiki/%E4%BD%BF%E7%94%A8%E7%BB%84%E4%BB%B6%E5%8C%96)或者[添加 LLDebugTool 到你的项目中](https://github.com/HDB-Li/LLDebugTool/blob/master/README-cn.md#%E6%B7%BB%E5%8A%A0-lldebugtool-%E5%88%B0%E4%BD%A0%E7%9A%84%E9%A1%B9%E7%9B%AE%E4%B8%AD)。

更多的修改内容可以查看[Version 1.2.1 Project](https://github.com/HDB-Li/LLDebugTool/projects/7)。

#### 更新

* 更新 `LLFilterEventView.m` 并且增加一个averageCount的默认值，用来解决FilterView无法正常显示的问题。

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

##### Objective - C

> 1. 添加 `pod 'LLDebugTool' , '~> 1.0.0'` 到你的Podfile里。如果只想在Debug模式下使用，则添加`pod 'LLDebugTool' , '~> 1.0.0' ,:configurations => ['Debug']` 到你的Podfile里，详细的配置方式可以查看[Wiki/如何仅在Debug环境中使用](https://github.com/HDB-Li/LLDebugTool/wiki/如何仅在Debug环境中使用)。如果你想要指定某个版本，可以类似这样使用 `pod 'LLDebugTool' , '1.2.1' ,:configurations => ['Debug']`。
> 2. 如果你想使用某一个模块，可是添加`pod 'LLDebugTool/{Component Name}' , '~> 1.0.0'`到你的Podfile里。目前支持的组件有
> ```
> pod 'LLDebugTool/AppInfo'
> pod 'LLDebugTool/Crash'
> pod 'LLDebugTool/Log'
> pod 'LLDebugTool/Network'
> pod 'LLDebugTool/Sandbox'
> pod 'LLDebugTool/Screenshot'
> ```
> 3. 终端输入`pod install`来进行集成。搜索不到`LLDebugTool`或者搜不到最新版本时，可先运行`pod repo update`，再执行`pod install`。
> 4. 在你需要使用LLDebugTool的文件里添加`#import "LLDebug.h"`，或者直接在pch文件中添加`#import "LLDebug.h"`。

##### Swift

> 1. 添加 `pod 'LLDebugToolSwift' , '~> 1.0.0'` 到你的Podfile里。如果只想在Debug模式下使用，则添加`pod 'LLDebugToolSwift' , '~> 1.0.0' ,:configurations => ['Debug']` 到你的Podfile里，详细的配置方式可以查看[Wiki/如何仅在Debug环境中使用](https://github.com/HDB-Li/LLDebugTool/wiki/如何仅在Debug环境中使用)。如果你想要指定某个版本，可以类似这样使用 `pod 'LLDebugToolSwift' , '1.2.1' ,:configurations => ['Debug']`。
> 2. 如果你想使用某一个模块，可是添加`pod 'LLDebugToolSwift/{Component Name}' , '~> 1.0.0'`到你的Podfile里。目前支持的组件有
> ```
> pod 'LLDebugToolSwift/AppInfo'
> pod 'LLDebugToolSwift/Crash'
> pod 'LLDebugToolSwift/Log'
> pod 'LLDebugToolSwift/Network'
> pod 'LLDebugToolSwift/Sandbox'
> pod 'LLDebugToolSwift/Screenshot'
> ```
> 3. 必须在Podfile中添加 **`use_frameworks!`** 。
> 4. 终端输入`pod install`来进行集成。搜索不到`LLDebugToolSwift`或者搜不到最新版本时，可先运行`pod repo update`，再执行`pod install`。
> 5. 在你需要使用LLDebugTool的文件里添加`import LLDebugToolSwift`。

### Carthage

[Carthage](https://github.com/Carthage/Carthage) 是一个分散的依赖管理器，它构建您的依赖并为您提供framework框架。

##### Objective - C

> 1. 要使用Carthage将LLDebugTool集成到Xcode项目中，请在`Cartfile`中指定它:
>
>     `github "LLDebugTool"`
>
> 2. 运行 `carthage` 来构建框架，并将构建的`LLDebugTool.framework`拖到Xcode项目中。

##### Swift

> 1. 要使用Carthage将LLDebugToolSwift集成到Xcode项目中，请在`Cartfile`中指定它:
>
>     `github "LLDebugToolSwift"`
>
> 2. 运行 `carthage` 来构建框架，并将构建的`LLDebugToolSwift.framework`拖到Xcode项目中。

### 源文件

您可以直接将名为LLDebugTool文件夹的源文件添加到项目中。

##### Objective - C

> 1. 下载[最新的代码版本](https://github.com/HDB-Li/LLDebugTool/archive/master.zip)或将存储库作为git子模块添加到您的git跟踪项目中。
> 2. 在Xcode中打开项目，然后拖拽名为“LLDebugTool”的源文件夹到你的项目中。当提示Choose options for adding these files时，务必勾选Copy items if needed这项。如果你只是想集成某一个模块，请查看Wiki[使用组件化](https://github.com/HDB-Li/LLDebugTool/wiki/%E4%BD%BF%E7%94%A8%E7%BB%84%E4%BB%B6%E5%8C%96)。
> 3. 集成[FMDB](https://github.com/ccgus/fmdb)到项目中，FMDB是一个围绕SQLite的Objective-C包装器开源库。
> 4. 在你需要使用LLDebugTool的文件里添加`#import "LLDebug.h"`，或者直接在pch文件中添加`#import "LLDebug.h"`。

##### Swift

> 1. 下载[最新的Objective-C代码版本](https://github.com/HDB-Li/LLDebugTool/archive/master.zip)或将存储库作为git子模块添加到您的git跟踪项目中。
> 2. 下载[最新的Swift扩展代码版本](https://github.com/HDB-Li/LLDebugToolSwift/archive/master.zip)或将存储库作为git子模块添加到您的git跟踪项目中。
> 3. 在Xcode中打开项目，然后拖拽名为“LLDebugTool”和“LLDebugToolSwift”的源文件夹到你的项目中。当提示Choose options for adding these files时，务必勾选Copy items if needed这项。如果你只是想集成某一个模块，请查看Wiki[使用组件化](https://github.com/HDB-Li/LLDebugTool/wiki/%E4%BD%BF%E7%94%A8%E7%BB%84%E4%BB%B6%E5%8C%96)。
> 4. 集成[FMDB](https://github.com/ccgus/fmdb)到项目中，FMDB是一个围绕SQLite的Objective-C包装器开源库。
> 5. 在你需要使用LLDebugTool的文件里添加`import LLDebugToolSwift`。

## 如何使用

### 启动

你需要在"application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions"中启动LLDebugTool，否则你可能会丢掉某些信息。

如果你想自定义一些参数，你需要在调用"startWorking"前配置这些参数。更详细的配置信息请看[LLConfig.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Config/LLConfig.h)。

* `快速启动`

In Objective-C

```Objective-C
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

In Swift

```Swift
import LLDebugToolSwift

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ####################### Start LLDebugTool #######################//
        // Use this line to start working.
        LLDebugTool.shared().startWorking()
        
        // Write your project code here.
        
        return true
    }
```

* `使用自定义的配置启动`

In Objective-C

```Objective-C
#import "AppDelegate.h"
#import "LLDebug.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //####################### Color Style #######################//
    // Uncomment one of the following lines to change the color configuration.
    // [LLConfig sharedConfig].colorStyle = LLConfigColorStyleSystem;
    // [[LLConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    
    //####################### User Identity #######################//
    // Use this line to tag user. More config please see "LLConfig.h".
    [LLConfig sharedConfig].userIdentity = @"Miss L";
    
    //####################### Window Style #######################//
    // Uncomment one of the following lines to change the window style.
    // [LLConfig sharedConfig].windowStyle = LLConfigWindowNetBar;

    //####################### Features #######################//
    // Uncomment this line to change the available features.
    // [LLConfig sharedConfig].availables = LLConfigAvailableNoneAppInfo;
    
    // ####################### Start LLDebugTool #######################//
    // Use this line to start working.
    [[LLDebugTool sharedTool] startWorking];
    
    return YES;
}
```

In Swift

```Swift
import LLDebugToolSwift

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //####################### Color Style #######################//
        // Uncomment one of the following lines to change the color configuration.
        // LLConfig.shared().colorStyle = .system
        // LLConfig.shared().configBackgroundColor(.orange, textColor: .white, statusBarStyle: .default)
        
        //####################### User Identity #######################//
        // Use this line to tag user. More config please see "LLConfig.h".
        LLConfig.shared().userIdentity = "Miss L";
        
        //####################### Window Style #######################//
        // Uncomment one of the following lines to change the window style.
        // LLConfig.shared().windowStyle = .netBar
        
        //####################### Features #######################//
        // Uncomment this line to change the available features.
        // LLConfig.shared().availables = .noneAppInfo
        
        // ####################### Start LLDebugTool #######################//
        // Use this line to start working.
        LLDebugTool.shared().startWorking()
        
        return true
    }
```

### 日志

打印和保存一个日志。 更多的log宏信息查看[LLLogHelper.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Helper/LogHelper/LLLogHelper.h)。

* `保存日志`

In Objective-C

```Objective-C
#import "LLDebug.h"

- (void)testNormalLog {
    // Insert an LLog where you want to print.
    LLog(@"Message you want to save or print.");
}
```

In Swift

```Swift
import LLDebugToolSwift

    func testNormalLog() {
        // Insert an LLog where you want to print.
        LLog.log(message: "Message you want to save or print.")
    }

```

* `Save Log with event and level`

In Objective-C

```Objective-C
#import "LLDebug.h"

- (void)testEventErrorLog {
    // Insert an LLog_Error_Event where you want to print an event and level log.
    LLog_Error_Event(@"The event that you want to mark. such as bugA, taskB or processC.",@"Message you want to save or print.");
}
```

In Swift

```Swift
import LLDebugToolSwift

    func testEventErrorLog() {
        // Insert an LLog_Error_Event where you want to print an event and level log.
        LLog.errorLog(message: "Message you want to save or print.", event: "The event that you want to mark. such as bugA, taskB or processC.")
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

* 你可以通过查看[Wiki](https://github.com/HDB-Li/LLDebugTool/wiki)，获得更多帮助。
* 你可以下载并运行[LLDebugToolDemo](https://github.com/HDB-Li/LLDebugTool/archive/master.zip)或[LLDebugToolSwiftDemo](https://github.com/HDB-Li/LLDebugToolSwift/archive/master.zip)来发现LLDebugTool的更多使用方式。Demo是在XCode9.3，ios 11.3，cocoapods 1.5.0下运行的，如果有任何版本兼容问题，请告诉我。

## 要求

LLDebugTool在支持ios8+，并且需要使用ARC模式。使用到的框架已经包含在大多数Xcode模板中:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `Photos`

* `QuickLook`

## 结构

* `LLDebug.h` 公用头文件。

    >全局引用此文件即可。

* `DebugTool` 工具文件。

    >用于启动和停止LLDebugTool，你需要看一下"LLDebugTool.h"这个文件。

* `Config` 配置文件。

    >用于自定义颜色、大小、标识和其他信息。如果您想要配置任何东西，您需要关注这个文件。

* `Components` 组件文件。

    >如果你对功能的实现原理不感兴趣，那么可以忽略这个文件夹。
    >每个组件文件夹下分为 `Function` 和 `UserInterface`，`Function` 是具体功能实现，`UserInterface`是具体UI搭建。
  
  - `AppInfo` 用于监视应用程序的各种属性，依赖于`General`。
  - `Crash` 用于当App发生崩溃时，收集崩溃信息，依赖于`LLStorageManager`。
  - `Log` 快速打印和保存日志，依赖于`LLStorageManager`。
  - `Network` 用于监视网络请求，依赖于`LLStorageManager`。
  - `Sandbox` Sandbox Helper，用于查看和操作沙盒文件。依赖于`General`。
  - `Screenshot` 用于处理和展示截屏事件，依赖于`General`。
  - `LLStorageManager` Storage Helper。用于数据存储和读取，依赖于`General`。
  - `General` 其他组件的基础组件，依赖于`Config`。
 
## 联系

- **如果你需要帮助**，打开一个issue。
- **如果你想问一个普遍的问题**，打开一个issue。
- **如果你发现了一个bug**，_并能提供可靠的复制步骤_，打开一个issue。
- **如果你有一个功能请求**，打开一个issue。
- **如果你发现有什么不对或不喜欢的地方**，就打开一个issue。
- **如果你有一些好主意或者一些需求**，请发邮件(llworkinggroup1992@gmail.com)给我。
- **如果你想贡献**，提交一个pull request。

## 联系

- 可以发邮件到[llworkinggroup1992@gmail.com](llworkinggroup1992@gmail.com)
- 可以在twitter中[@HdbLi](https://twitter.com/HdbLi)发私信给我。
- 可以在[简书](https://www.jianshu.com/u/a3c82fae85be)中发私信给我。

## 更新日志

可以在 [CHANGELOG](CHANGELOG.md) 中找到每个LLDebugTool版本的简要总结。

## 许可

这段代码是根据 [MIT license](LICENSE) 的条款和条件发布的。
