//
//  LLInternalMacros.h
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

#ifndef LLInternalMacros_h
#define LLInternalMacros_h

// Screen width.
#define LL_SCREEN_WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
// Screen height.
#define LL_SCREEN_HEIGHT (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
// Status bar height.
#define LL_STATUS_BAR_HEIGHT (LL_IS_SPECIAL_SCREEN ? 44 : 20)
// Navigation bar height.
#define LL_NAVIGATION_HEIGHT (LL_STATUS_BAR_HEIGHT + 44)
// Bottom danger height.
#define LL_BOTTOM_DANGER_HEIGHT (LL_IS_SPECIAL_SCREEN ? 34 : 0)
// Whether is special screen.
#define LL_IS_SPECIAL_SCREEN \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// Layout length by horizontal direction in 414px.
#define LL_LAYOUT_HORIZONTAL(length) (length * LL_SCREEN_WIDTH / 414.0)

#define LLLocalizedString(key) \
[[LLConfig shared].imageBundle localizedStringForKey:(key) value:@"" table:nil]

#endif /* LLInternalMacros_h */
