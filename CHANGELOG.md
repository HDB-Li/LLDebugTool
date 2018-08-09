## [1.1.2](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.1.2) (08/09/2018)

### Add window style

Some time suspension ball is too big, so you can put `LLDebugTool` on power bar or network bar now. It can work like a suspension ball, just can't move.

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenShot-windowStyle.png" width="20%"></img>
</div>

#### Add

* Add window style enum. now you can show as suspension ball , power bar or network bar.
* Add some `LLDebugTool` event log, you can close it in `LLConfig`.
* Add `LLNetworkFilterView`, now you can filter network with url, header, body or response.

#### Update

* Update `LLURLProtocol` to fix some untrusted HTTP requests that fail.
* Update `LLBaseViewController` to deal some bugs when project use runtime to change default settings.
* Update `LLStorageManager` to ensure that database operations are not performed in the main thread.
* Rename `LLFilterView` to `LLLogFilterView`.

#### Remove

* Remove `LLFilterLevelView`, use `LLFilterEventView` to replace.

#### Extra

* Adapter iPhone SE

## [1.1.1](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.1.1) (07/27/2018)

Fix crash when use `use_frameworks!` in `CocoaPods`. (Failed resource loading)

#### Add

* Add `LLLogHelperEventDefine.h` to define and record LLDebugTool system event.

#### Update

* Use method `[UIImage LL_imageNamed:]` to replace method  `[UIImage imageNamed]`, to solve image resource loading failed.
* Use `[LLConfig sharedConfig].XIBBundle` to register XIB file, to solve crash when use `use_frameworks!` in `CocoaPods`.

## [1.1.0](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.1.0) (06/07/2018)

### Add screenshot function.

Increases the need to the permissions of the album, but it is not necessary, if the project has the authority, save will be synchronized to photo album, if the project doesn't have the permission, is saved into the sandbox alone, LLDebugTool will not actively apply for album permissions.

<div align="left">
<img src="https://raw.githubusercontent.com/HDB-Li/HDBImageRepository/master/LLDebugTool/ScreenGif-Screenshot.gif" width="20%"></img>
</div>

#### Add

* Add `LLScreenshotHelper` in `Helper` folder, used to control screenshot.
* Add `LLScreenshotView` folder in `UserInterface/Others` folder, used to show and draw screenshot.
* Add `LLDebugToolMacros.h`, used to manage public macros.

#### Update

* Update `LLBaseNavigationController` and `LLBaseViewController` to repair toolbar's frame is wrong when hiding tabbar.
* Update `LLAppHelper` to fix iPhone X getting network status error.
* Remove `LLog` macros in `LLDebugTool.h` and moved to `LLDebugToolMacros.h`

#### Additional Changes

* Update demo for saving screenshots to photo albums when screenshots are taken.

## [1.0.3](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.0.3) (05/31/2018)

Fix some leaks.

#### Update

* Call `CFRelease` in `LLAppHelper`.
* Resolve circular references caused by the `NSURLSessionDelegate` in `LLURLProtocol`.
* Call `Free` in `LLBaseModel`.
* Fix analyze warning in `LLBaseViewController` / `LLFilterOtherView`.
* Uncoupled code in `LLTool` / `LLNetworkContentVC`.

#### Additional Changes

* Add `NetTool`(Use URLSession in a singleton.) and update `ViewController` (Fix a circular reference.)

## [1.0.2](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.0.2) (05/21/2018)

* Fix the side gesture recognizer bug when pop.

## [1.0.1](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.0.1) (05/12/2018)

* Support iOS8+.

## [1.0.0](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.0.0) (05/09/2018)

* Initial release version.
* Contains the following functions:
  
  * Monitoring network requests.
  * Save and view log information.
  * Crash information collection.
  * Monitoring app properties.
  * Operation of sandbox file.
  
