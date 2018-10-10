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

## Introduction

[点击查看中文简介](https://github.com/HDB-Li/LLDebugTool/blob/master/README-cn.md)

LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations.

[LLDebugToolSwift](https://github.com/HDB-Li/LLDebugToolSwift) is the extension of [LLDebugTool](https://github.com/HDB-Li/LLDebugTool), it provide swift interface for LLDebugTool, LLDebugToolSwift will release with LLDebugTool at same time. 

If your project is a Objective-C project, you can use `LLDebugTool`, if your project is a Swift project or contains swift files, you can use `LLDebugToolSwift`.

Choose LLDebugTool for your next project, or migrate over your existing projects—you'll be happy you did!

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

## What's new in 1.2.1

### Fix a display bug.

`LLDebugTool` supports component-based now. Now you can integrate only one or more modules into your own **Debug debugger**. You can directly use the view controller contained in each module, or just call the functions in `Function` folder and build UI yourself.

How to use components, see Wiki[Use Components](https://github.com/HDB-Li/LLDebugTool/wiki/Use-Components) or [Adding LLDebugTool to your project](https://github.com/HDB-Li/LLDebugTool#adding-lldebugtool-to-your-project).

More changes can be viewed in [Version 1.2.1 Project](https://github.com/HDB-Li/LLDebugTool/projects/7).

#### Update

* Update `LLFilterEventView.m` and add a default averageCount to fix FilterView showing incomplete questions.
        
## What can you do with LLDebugTool?

- Always check the network request or view log information for certain events without having to run under XCode. This is useful in solving the testers' problems..

- Easier filtering and filtering of useful information.

- Easier analysis of occasional problems.

- Easier analysis of the cause of the crash.

- Easier sharing, previewing, or removing sandbox files, which can be very useful in the development stage.

- Easier observe app's memory, CPU, FPS and other information.

## Adding LLDebugTool to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add `LLDebugTool` to your project.

##### Objective - C

> 1. Add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugTool' , '~> 1.0.0'`, If only you want to use it only in Debug mode, Add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugTool' , '~> 1.0.0' ,:configurations => ['Debug']`, Details also see [Wiki/Use in Debug environment](https://github.com/HDB-Li/LLDebugTool/wiki/Use-in-Debug-environment). If you want to specify the version, use as `pod 'LLDebugTool' , '1.2.1' ,:configurations => ['Debug']`.
> 2. If you want to use a module, add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugTool/{Component Name}'`, Currently supported components are
> ```
> pod 'LLDebugTool/AppInfo'
> pod 'LLDebugTool/Crash'
> pod 'LLDebugTool/Log'
> pod 'LLDebugTool/Network'
> pod 'LLDebugTool/Sandbox'
> pod 'LLDebugTool/Screenshot'
> ```
> 3. Install the pod(s) by running `pod install`. If you can't search `LLDebugTool` or you can't find the newest release version, running `pod repo update` before `pod install`.
> 4. Include LLDebugTool wherever you need it with `#import "LLDebug.h"` or you can write `#import "LLDebug.h"` in your .pch  in your .pch file.

##### Swift

> 1. Add a pod entry for LLDebugToolSwift to your Podfile `pod 'LLDebugToolSwift' , '~> 1.0.0'`, If only you want to use it only in Debug mode, Add a pod entry for LLDebugToolSwift to your Podfile `pod 'LLDebugToolSwift' , '~> 1.0.0' ,:configurations => ['Debug']`, Details also see [Wiki/Use in Debug environment](https://github.com/HDB-Li/LLDebugTool/wiki/Use-in-Debug-environment). If you want to specify the version, use as `pod 'LLDebugToolSwift' , '1.2.1' ,:configurations => ['Debug']`.
> 2. If you want to use a module, add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugToolSwift/{Component Name}'`, Currently supported components are
> ```
> pod 'LLDebugToolSwift/AppInfo'
> pod 'LLDebugToolSwift/Crash'
> pod 'LLDebugToolSwift/Log'
> pod 'LLDebugToolSwift/Network'
> pod 'LLDebugToolSwift/Sandbox'
> pod 'LLDebugToolSwift/Screenshot'
> ```
> 3. Must be added in the Podfile **`use_frameworks!`**.
> 4. Install the pod(s) by running `pod install`. If you can't search `LLDebugToolSwift` or you can't find the newest release version, running `pod repo update` before `pod install`.
> 5. Include LLDebugTool wherever you need it with `import "LLDebugToolSwift`.

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

##### Objective - C

> 1. To integrate LLDebugTool into your Xcode project using Carthage, specify it in your `Cartfile`:
>
>     `github "LLDebugTool"`
> 
> 2. Run `carthage` to build the framework and drag the built `LLDebugTool.framework` into your Xcode project.

##### Swift

> 1. To integrate LLDebugToolSwift into your Xcode project using Carthage, specify it in your `Cartfile`:
>
>     `github "LLDebugToolSwift"`
> 
> 2. Run `carthage` to build the framework and drag the built `LLDebugToolSwift.framework` into your Xcode project.

### Source files

Alternatively you can directly add the source folder named LLDebugTool.  to your project.

##### Objective - C

> 1. Download the [latest code version](https://github.com/HDB-Li/LLDebugTool/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
> 2. Open your project in Xcode, then drag and drop the source folder named `LLDebugTool`. When you are prompted to "Choose options for adding these files", be sure to check the "Copy items if needed". If you want to use only one module ,see Wiki[Use Components](https://github.com/HDB-Li/LLDebugTool/wiki/Use-Components).
> 3. Integrated [FMDB](https://github.com/ccgus/fmdb) to your project,FMDB is an Objective-C wrapper around SQLite.
> 4. Include LLDebugTool wherever you need it with `#import "LLDebug.h"` or you can write `#import "LLDebug.h"` in your .pch  in your .pch file.

##### Swift

> 1. Download the [LLDebugTool latest code version](https://github.com/HDB-Li/LLDebugTool/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
> 2. Download the [LLDebugToolSwift latest code version](https://github.com/HDB-Li/LLDebugToolSwift/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
> 3. Open your project in Xcode, then drag and drop the source folder named `LLDebugTool` and `LLDebugToolSwift`. When you are prompted to "Choose options for adding these files", be sure to check the "Copy items if needed". If you want to use only one module ,see Wiki[Use Components](https://github.com/HDB-Li/LLDebugTool/wiki/Use-Components).
> 4. Integrated [FMDB](https://github.com/ccgus/fmdb) to your project,FMDB is an Objective-C wrapper around SQLite.
> 5. Include LLDebugTool wherever you need it with `import LLDebugToolSwift"`.

## Usage

### Get Started

You need to start LLDebugTool at "application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions", Otherwise you will lose some information. 

If you want to configure some parameters, must configure before "startWorking". More config details see [LLConfig.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Config/LLConfig.h).

* `Quick Start`

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

* `Start With Custom Config`

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

### Log

Print and save a log. More log macros details see [LLLogHelper.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Helper/LogHelper/LLLogHelper.h).

* `Save Log`

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

### Network Request

You don't need to do anything, just call the "startWorking" will monitoring most of network requests, including the use of NSURLSession, NSURLConnection and AFNetworking. If you find that you can't be monitored in some cases, please open an issue and tell me.

### Crash

You don't need to do anything, just call the "startWorking" to intercept the crash, store crash information, cause and stack informations, and also store the network requests and log informations at the this time.

### AppInfo

LLDebugTool monitors the app's CPU, memory, and FPS. At the same time, you can also quickly check the various information of the app.

### Sandbox

LLDebugTool provides a quick way to view and manipulate sandbox, you can easily delete the files/folders inside the sandbox, or you can share files/folders by airdrop elsewhere. As long as apple supports this file format, you can preview the files directly in LLDebugTool.

### More Usage

* You can get more help by looking at the [Wiki](https://github.com/HDB-Li/LLDebugTool/wiki).
* You can download and run the [LLDebugToolDemo](https://github.com/HDB-Li/LLDebugTool/archive/master.zip) or [LLDebugToolSwiftDemo](https://github.com/HDB-Li/LLDebugToolSwift/archive/master.zip) to find more use with LLDebugTool. The demo is build under XCode9.3, ios 11.3 and cocoapods 1.5.0. If there is any version compatibility problem, please let me know.

## Requirements

LLDebugTool works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `Photos`

* `QuickLook`

## Architecture

* `LLDebug.h` Public header file.

    >You can refer it to the pch file.

* `DebugTool` Tool files.

    >To start and stop LLDebugTool, you need to look at the "LLDebugTool.h".

* `Config`  Configuration file.

    >For the custom color , size , identification and other information. If you want to configure anything, you need to focus on this file.

* `Components`  Components files.

    >If you're not interested in how the functionality works, you can ignore this folder.
    >Each component folder is divided into `Function`and `UserInterface`, `Function` is the specific function implementation, `UserInterface`is the specific UI build.
  
  - `AppInfo` Use to monitoring app's properties, depend on `General`.
  - `Crash` Used to collect crash information when an App crashes, depend on `LLStorageManager`.
  - `Log` Used to quick print and save log, depend on `LLStorageManager`.
  - `Network` Use to monitoring network request, depend on `LLStorageManager`.
  - `Sandbox` Used to view and operate sandbox files, depend on `General`.
  - `Screenshot` Used to process and display screenshots, depend on `General`.
  - `LLStorageManager`  Used to data storage and reading, depend on `General`.
  - `General` The basic component of other components, depend on `Config`.
  
## Communication

- If you **need help**, open an issue.
- If you'd like to **ask a general question**, open an issue.
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **find anything wrong or anything dislike**, open an issue.
- If you **have some good ideas or some requests**, send mail(llworkinggroup1992@gmail.com) to me.
- If you **want to contribute**, submit a pull request.

## Contact

- Send email to [llworkinggroup1992@gmail.com](llworkinggroup1992@gmail.com)
- Send message in twitter [@HdbLi](https://twitter.com/HdbLi)
- Send message in [JianShu](https://www.jianshu.com/u/a3c82fae85be)

## Change-log

A brief summary of each LLDebugTool release can be found in the [CHANGELOG](CHANGELOG.md). 

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
