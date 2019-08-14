//
//  LLFunctionItemModel.h
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

#import "LLBaseModel.h"
#import "LLComponent.h"

/**
 Function action enums.

 - LLFunctionActionNetwork: Network function.
 - LLFunctionActionLog: Log function.
 - LLFunctionActionCrash: Crash function.
 - LLFunctionActionAppInfo: App info function.
 - LLFunctionActionSandbox: Sandbox function.
 - LLFunctionActionScreenshot: Screenshot function.
 - LLFunctionActionHierarchy: Hierarchy function.
 */
typedef NS_ENUM(NSUInteger, LLFunctionAction) {
    LLFunctionActionNetwork,
    LLFunctionActionLog,
    LLFunctionActionCrash,
    LLFunctionActionAppInfo,
    LLFunctionActionSandbox,
    LLFunctionActionScreenshot,
    LLFunctionActionHierarchy,
    LLFunctionActionMagnifier
};

NS_ASSUME_NONNULL_BEGIN

/**
 The model of LLFunctionCell.
 */
@interface LLFunctionItemModel : LLBaseModel

/**
 The name of the display image.
 */
@property (nonatomic, copy) NSString *imageName;

/**
 The title to display.
 */
@property (nonatomic, copy) NSString *title;

/**
 Specified action.
 */
@property (nonatomic, assign) LLFunctionAction action;

/**
 Action component.
 */
@property (nonatomic, strong, readonly) LLComponent *component;

/**
 Specifies the initialization method.

 @param imageName The name of the display image.
 @param title The title to display.
 @param action Specified action.
 @return Instance object.
 */
- (instancetype _Nonnull )initWithImageName:(NSString *)imageName title:(NSString *)title action:(LLFunctionAction)action;

@end

NS_ASSUME_NONNULL_END
