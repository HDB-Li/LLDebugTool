//
//  LLWindow.h
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

NS_ASSUME_NONNULL_BEGIN

@protocol LLWindowDelegate;

/**
 The LLWindow class is used to display suspended window and functional interface entries.
 */
@interface LLWindow : UIWindow

///**
// Proxy properties.
// */
//@property (weak, nonatomic, nullable) id <LLWindowDelegate> delegate;
//
///**
// Specifies the initialization method.
//
// @param frame Specified frame.
// @return Instance object.
// */
//- (instancetype _Nonnull)initWithFrame:(CGRect)frame;
//
//@end
//
///**
// This represents the behaviour of the window.
// */
//@protocol LLWindowDelegate <NSObject>
//
///**
// Whether LLWindow corresponds to a touch event.
//
// @param pointInWindow The point in window.
// @return The result.
// */
//- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;
//
///**
// Whether LLWindow be changed to KeyWindow.
//
// @return The result.
// */
//- (BOOL)canBecomeKeyWindow;

@end

NS_ASSUME_NONNULL_END
