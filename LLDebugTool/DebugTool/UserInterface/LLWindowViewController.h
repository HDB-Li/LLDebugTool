//
//  LLWindowViewController.h
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

#import <UIKit/UIKit.h>
#import "LLConfig.h"


/**
 Root ViewController of LLWindow, controlling and displaying the UI.
 */
@interface LLWindowViewController : UIViewController

/**
 Release current tabBarController.
 */
- (void)reloadTabbar;

/**
 Displays suspended window on the screen.
 */
- (void)showExplorerView;

/**
 Hide suspended window on the screen.
 */
- (void)hideExplorerView;

/**
 Automatic open debug view controller with index.
 */
- (void)presentTabbarWithIndex:(NSInteger)index params:(NSDictionary <NSString *,id>*)params;

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

- (BOOL)wantsWindowToBecomeKey;

- (void)handleDownArrowKeyPressed;

- (void)handleUpArrowKeyPressed;

- (void)handleRightArrowKeyPressed;

- (void)handleLeftArrowKeyPressed;

@end
