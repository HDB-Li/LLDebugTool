<p align="center" >
  <img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/header.png" alt="LLDebugTool" title="LLDebugTool">
</p>

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.1.5-blue.svg)](https://img.shields.io/badge/pod-v1.1.5-blue.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C-yellow.svg)](https://img.shields.io/badge/Language-Objective--C-yellow.svg)
[![Twitter](https://img.shields.io/badge/twitter-@HdbLi-1DA1F2.svg)](https://twitter.com/HdbLi)

## Introduction

[点击查看中文简介](https://github.com/HDB-Li/LLDebugTool/blob/master/README-cn.md)

LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations.

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

## Recent updates (1.1.5)

###  Start/stop function module dynamically

Add a options `LLConfigAvailableFeature` in `LLConfig` used to control whether to enable ` LLDebugTool` one of function module, now you can dynamically start/stop a module. More changes can be viewed in [Version 1.1.5 Project](https://github.com/HDB-Li/LLDebugTool/projects/4).

#### Add

* Add a options `LLConfigAvailableFeature` in `LLConfig` used to control whether to enable ` LLDebugTool` one of function module, now you can dynamically start/stop a module.
* Add enumeration values `LLConfigLogFileFuncDesc` and `LLConfigLogFileDesc` in `LLConfigLogStyle`.

#### Update

* Update `LLAppHelper` and `LLConfig`, Cleaner code.
* Update `LLConfig`, now you can dynamic change `colorStyle` and `windowStyle` in running, See demo for more effects.
* Update `LLSubTitleTableViewCell` to fix UITextView bug under ios 8.

#### Extra

* Update demo file, It looks more comfortable now.
        
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

1. Add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugTool' , '~> 1.0.0'`, If only you want to use it only in Debug mode, Add a pod entry for LLDebugTool to your Podfile `pod 'LLDebugTool' , '~> 1.0.0' ,:configurations => ['Debug']`, Details also see [Wiki/Use in Debug environment](https://github.com/HDB-Li/LLDebugTool/wiki/Use-in-Debug-environment). If you want to specify the version, use as `pod 'LLDebugTool' , '1.1.5' ,:configurations => ['Debug']`.
2. Install the pod(s) by running `pod install`. If you can't search `LLDebugTool` or you can't find the newest release version, running `pod repo update` before `pod install`.
3. Include LLDebugTool wherever you need it with `#import "LLDebug.h"` or you can write `#import "LLDebug.h"` in your .pch  in your .pch file.

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

1. To integrate LLDebugTool into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "LLDebugTool"
```

2. Run `carthage` to build the framework and drag the built `LLDebugTool.framework` into your Xcode project.

### Source files

Alternatively you can directly add the source folder named LLDebugTool.  to your project.

1. Download the [latest code version](https://github.com/HDB-Li/LLDebugTool/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop the source folder named `LLDebugTool`. When you are prompted to "Choose options for adding these files", be sure to check the "Copy items if needed".
3. Integrated [FMDB](https://github.com/ccgus/fmdb) to your project,FMDB is an Objective-C wrapper around SQLite.
4. Include LLDebugTool wherever you need it with `#import "LLDebug.h"` or you can write `#import "LLDebug.h"` in your .pch  in your .pch file.

## Usage

### Get Started

You need to start LLDebugTool at "application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions", Otherwise you will lose some information. 

If you want to configure some parameters, must configure before "startWorking". More config details see [LLConfig.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Config/LLConfig.h).

* `Quick Start`

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

* `Start With Custom Config`

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

### Log

Print and save a log. More log macros details see [LLLogHelper.h](https://github.com/HDB-Li/LLDebugTool/blob/master/LLDebugTool/Helper/LogHelper/LLLogHelper.h).

* `Save Log`

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

- (void)testEventErrorLog {
    // Insert an LLog_Error_Event where you want to print an event and level log.
    LLog_Error_Event(@"The event that you want to mark. such as bugA, taskB or processC.",@"Message you want to save or print.");
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
* You can download and run the [LLDebugToolDemo](https://github.com/HDB-Li/LLDebugTool/archive/master.zip) to find more use with LLDebugTool. The demo is build under XCode9.3, ios 11.3 and cocoapods 1.5.0. If there is any version compatibility problem, please let me know.

## Requirements

LLDebugTool works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `Photos`

* `malloc`

* `mach-o`

* `mach`

* `QuickLook`

* `objc`

* `sys`

## Architecture

* `LLDebug.h` Public header file.

* `LLConfig`  Configuration file. 

    >For the custom color , size , identification and other information. If you want to configure anything, you need to focus on this file.

* `LLDebugTool` Tool files. 

    >To start and stop LLDebugTool, you need to look at the "LLDebugTool.h".

* `Helper`  Helper files. 

    >If you're not interested in how the functionality works, you can ignore this folder.
  
  - `LLAppHelper` Use to monitoring app's properties.
  - `LLCrashHelper` Used to collect crash information when an App crashes.
  - `LLLogHelper` Used to quick print and save log.
  - `LLNetworkHelper` Use to monitoring network request.
  - `LLSandboxHelper` Used to view and operate sandbox files.
  - `LLStorageManager`  Used to data storage and reading.
 
* `UserInterface` UI files. 

    >If you want to modify, view, or learn something about the UI, check out this folder.

  - `Base`  The base class file.
  - `Categories`  Class extensions.
  - `Others`  Non-generic controls.
  - `Resources` Image resources.
  - `Sections`  ViewControllers
  - `Tool`  Tool.
  
## Communication

- If you **need help**, open an issue.
- If you'd like to **ask a general question**, open an issue.
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **find anything wrong or anything dislike**, open an issue.
- If you **have some good ideas or some requests**, send mail(llworkinggroup@qq.com) to me.
- If you **want to contribute**, submit a pull request.

## Contact

- Send email to [llworkinggroup1992@gmail.com](llworkinggroup1992@gmail.com)
- Send message in twitter [@HdbLi](https://twitter.com/HdbLi)
- Send message in [JianShu](https://www.jianshu.com/u/a3c82fae85be)

## Change-log

A brief summary of each LLDebugTool release can be found in the [CHANGELOG](CHANGELOG.md). 

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Thanks

- [Dotzu](https://github.com/remirobert/Dotzu)
