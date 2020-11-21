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

#import "LLInternalMacrosTool.h"

// Screen width.
#define LL_SCREEN_WIDTH [LLInternalMacrosTool screenWidth]
// Screen height.
#define LL_SCREEN_HEIGHT [LLInternalMacrosTool screenHeight]
// Status bar height.
#define LL_STATUS_BAR_HEIGHT [LLInternalMacrosTool statusBarHeight]
// Navigation bar height.
#define LL_NAVIGATION_HEIGHT [LLInternalMacrosTool navigationHeight]
// Bottom danger height.
#define LL_BOTTOM_DANGER_HEIGHT [LLInternalMacrosTool bottomDangerHeight]
// Whether is special screen.
#define LL_IS_SPECIAL_SCREEN [LLInternalMacrosTool isSpecialScreen]
// Layout length by horizontal direction in 414px.
#define LL_LAYOUT_HORIZONTAL(length) [LLInternalMacrosTool layoutHorizontal:length]
// Get min
#define LL_MIN(numA, numB) [LLInternalMacrosTool minWithA:numA b:numB]
// Get max
#define LL_MAX(numA, numB) [LLInternalMacrosTool maxWithA:numA b:numB]
// Assert
#define LL_ASSERT(msg) [LLInternalMacrosTool assert:msg]
#define LL_ASSERT_CONDITION(cond, msg) if (!cond) {LL_ASSERT(msg);}

#define LLLocalizedString(key) \
    [[LLDebugConfig shared].imageBundle localizedStringForKey:(key) value:@"" table:nil]

#endif /* LLInternalMacros_h */
