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
    
    CGContextClearRect(context, self.frame);
    
    NSInteger zoomLevel = [LLConfig sharedConfig].magnifierZoomLevel;
    // Image's scale, default screenshot's scale is [UIScreen mainScreen].scale, but we only use 1.0 is ok.
    CGFloat scale = 1.0;
    NSInteger size = [LLConfig sharedConfig].magnifierSize;
    NSInteger skip = 1;

    CGPoint currentPoint = CGPointMake(self.targetPoint.x * scale, self.targetPoint.y * scale);

    currentPoint.x = round(currentPoint.x - size * skip / 2.0 * scale);
    currentPoint.y = round(currentPoint.y - size * skip / 2.0 * scale);
    int i, j;
    
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
            currentPoint.x += round(skip * scale);
        }

        currentPoint.x -= round(size * skip * scale);
        currentPoint.y += round(skip * scale);
    }
    
    UIGraphicsEndImageContext();
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
    self.layer.borderWidth = 2;
    
    UIImage *image = [self maskImage];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imgView];
    imgView.frame = self.bounds;
    
    self.targetPoint = CGPointZero;
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateScreenshot];
        self.targetPoint = self.center;
    }
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
    
    CGPoint newTargetPoint = CGPointMake(self.targetPoint.x + offsetPoint.x, self.targetPoint.y + offsetPoint.y);
    if (!CGPointEqualToPoint(newTargetPoint, self.targetPoint)) {
        self.targetPoint = newTargetPoint;
        [self setNeedsDisplay];
    }
}

- (void)changeFrameWithPoint:(CGPoint)point {
    
    CGPoint center = self.center;
    center.x += point.x;
    center.y += point.y;

    center.x = MIN(center.x, LL_SCREEN_WIDTH);
    center.x = MAX(center.x, 0);
    
    center.y = MIN(center.y, LL_SCREEN_HEIGHT);
    center.y = MAX(center.y, 0);

    self.center = center;
}

- (void)updateScreenshot {
    self.screenshot = [[LLScreenshotHelper sharedHelper] imageFromScreen:1];
}

- (UIImage *)maskImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger zoomLevel = [LLConfig sharedConfig].magnifierZoomLevel;
    
    NSInteger centerX = self.LL_width / 2.0;
    NSInteger centerY = self.LL_height / 2.0;
    
    CGContextSetStrokeColorWithColor(context, LLCONFIG_TEXT_COLOR.CGColor);
    CGContextStrokeRectWithWidth(context, CGRectMake(centerX - zoomLevel / 2.0, centerY - zoomLevel / 2.0, zoomLevel, zoomLevel), 2);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
