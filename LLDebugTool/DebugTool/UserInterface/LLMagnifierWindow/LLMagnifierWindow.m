//
//  LLMagnifierWindow.m
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

#import "LLMagnifierWindow.h"
#import "UIView+LL_Utils.h"
#import "LLConfig.h"
#import "LLMacros.h"
#import "LLScreenshotHelper.h"
#import "UIImage+LL_Utils.h"
#import "UIColor+LL_Utils.h"

@interface LLMagnifierWindow ()

@property (nonatomic, strong, nullable) UIImage *screenshot;

@end

@implementation LLMagnifierWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat zoomLevel = [LLConfig sharedConfig].magnifierZoomLevel;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger size = [LLConfig sharedConfig].magnifierSize;
    NSInteger skip = 1;
    
    CGPoint currentPoint = CGPointMake(self.targetPoint.x * scale, self.targetPoint.y * scale);
    currentPoint.x = round(currentPoint.x - size * skip / 2.0 * scale);
    currentPoint.y = round(currentPoint.y - size * skip / 2.0 * scale);
    int i,j;
    
    // 放大镜中画出网格，并使用当前点和周围点的颜色进行填充
    for (j = 0; j < size; j++) {
        for (i = 0; i < size; i++) {
            CGRect gridRect = CGRectMake(zoomLevel * i, zoomLevel * j, zoomLevel, zoomLevel);
            UIColor *gridColor = [UIColor clearColor];
            NSString *hexColorAtPoint = [self.screenshot LL_hexColorAt:currentPoint];
            if (hexColorAtPoint) {
                gridColor = [UIColor colorWithHex:hexColorAtPoint];
            }
            CGContextSetFillColorWithColor(context, gridColor.CGColor);
            CGContextFillRect(context, gridRect);
            // 横向寻找下一个相邻点
            currentPoint.x += round(skip * scale);
        }
        // 一行绘制完毕，横向回归起始点，纵向寻找下一个点
        currentPoint.x -= round(size * skip * scale);
        currentPoint.y += round(skip * scale);
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self updateScreenshot];
        self.targetPoint = self.center;
        [self setNeedsDisplay];
    }
}

#pragma mark - Primary
- (void)initial {
    self.windowLevel = UIWindowLevelStatusBar + 299;
    if (!self.rootViewController) {
        self.rootViewController = [[UIViewController alloc] init];
    }
    self.layer.cornerRadius = self.LL_width / 2.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.layer.borderWidth = [LLConfig sharedConfig].magnifierZoomLevel / 2;
    
    self.targetPoint = CGPointZero;
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateScreenshot];
    } else {
        
        CGPoint point = [sender locationInView:[[UIApplication sharedApplication].delegate window]];
        
        self.targetPoint = point;
                
        [self setNeedsDisplay];
        
        [self changeFrameWithPoint:point];
    }
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = point;

    center.x = MIN(center.x, LL_SCREEN_WIDTH);
    center.x = MAX(center.x, 0);
    
    center.y = MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = MAX(center.y, 0);

    self.center = center;
}

- (void)updateScreenshot {
    self.screenshot = [[LLScreenshotHelper sharedHelper] imageFromScreen:1];
}

@end
