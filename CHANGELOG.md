## [1.0.3](https://github.com/HDB-Li/LLDebugTool/releases/tag/1.0.3) (05/31/2018)

Fix some leaks.

- Update

    - LLDebugTool.h (Add annotation.)
    - LLAppHelper (Forget call CFRelease.)
    - LLURLProtocol (Manually release NSURLSession, Because the delegate of NSURLSession causes circular references.)
    - NSURLSessionConfiguration+LLSwizzling (Add ephemeralSessionConfiguration.)
    - LLSandboxModel (Call copy method.)
    - LLBaseModel (Forget call free.)
    - LLBaseViewController / LLFilterOtherView (Fix analyze warning.)
    - LLTool / LLNetworkContentVC (Uncoupled code.)

- Just For Demo

    - NetTool (Use URLSession in a singleton.)
    - ViewController (Fix a circular reference.)
    
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
  
