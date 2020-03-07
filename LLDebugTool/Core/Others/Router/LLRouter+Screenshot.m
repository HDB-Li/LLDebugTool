//
//  LLRouter+Screenshot.m
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

#import "LLRouter+Screenshot.h"

#import "LLInternalMacros.h"
#import "LLTool.h"

#import "UIView+LL_Utils.h"

@implementation LLRouter (Screenshot)

+ (nullable UIImage *)screenshotWithScale:(CGFloat)scale
{
    CGSize imageSize = CGSizeMake(LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
#pragma clang diagnostic pop
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication] windows]];
    
    [self appendStatusBar:windows];
    
    for (UIView *window in windows)
    {
        Class cls = NSClassFromString(@"LLBaseWindow");
        if (!window.isHidden && cls != nil && ![window isKindOfClass:cls]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, window.center.x, window.center.y);
            CGContextConcatCTM(context, window.transform);
            CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
            
            CGFloat rotate = [self rotateForOrientation:orientation];
            if (rotate) {
                CGContextRotateCTM(context, rotate);
            }
            
            CGSize translate = [self translateForOrientation:orientation imageSize:imageSize];
            if (!CGSizeEqualToSize(CGSizeZero, translate)) {
                CGContextTranslateCTM(context, translate.width, translate.height);
            }

            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            {
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
            }
            else
            {
                [window.layer renderInContext:context];
            }
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Primary
+ (void)appendStatusBar:(NSMutableArray *)windows {
    UIView *statusBar = [LLTool getUIStatusBarModern];
    if ([statusBar isKindOfClass:[UIView class]]) {
        [windows addObject:statusBar];
    }
}

+ (CGFloat)rotateForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return M_PI_2;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return -M_PI_2;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return M_PI;
    }
    return 0;
}

+ (CGSize)translateForOrientation:(UIInterfaceOrientation)orientation imageSize:(CGSize)imageSize {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGSizeMake(0, -imageSize.width);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGSizeMake(-imageSize.height, 0);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGSizeMake(-imageSize.width, -imageSize.height);
    }
    return CGSizeZero;
}

@end
