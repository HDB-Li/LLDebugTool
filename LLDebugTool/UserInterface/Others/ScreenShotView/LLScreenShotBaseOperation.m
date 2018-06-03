//
//  LLScreenShotBaseOperation.m
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

#import "LLScreenShotBaseOperation.h"
#import "LLImageNameConfig.h"
#import "LLTool.h"

@interface LLScreenShotBaseOperation () <CALayerDelegate>

@property (nonatomic , strong) LLScreenShotSelectorModel *selector;

@property (nonatomic , strong) UIBezierPath *path;

@property (nonatomic , strong) UIColor *redColor;

@property (nonatomic , strong) UIColor *blueColor;

@property (nonatomic , strong) UIColor *greenColor;

@property (nonatomic , strong) UIColor *yellowColor;

@property (nonatomic , strong) UIColor *grayColor;

@property (nonatomic , strong) UIColor *whiteColor;

@end

@implementation LLScreenShotBaseOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selector = [[LLScreenShotSelectorModel alloc] initWithSize:LLScreenShotSelectorActionSmall color:LLScreenShotSelectorActionRed];
        _action = LLScreenShotActionRect;
        _path = [UIBezierPath bezierPath];
        _layer = [CAShapeLayer layer];
        _layer.delegate = self;
    }
    return self;
}

- (instancetype)initWithSelector:(LLScreenShotSelectorModel *)selector action:(LLScreenShotAction)action {
    if (self = [super init]) {
        _selector = selector;
        _action = action;
        _path = [UIBezierPath bezierPath];
        _layer = [CAShapeLayer layer];
        _layer.delegate = self;
    }
    return self;
}

- (void)drawImageView:(CGRect)rect {
    
}

- (LLScreenShotSelectorAction)size {
    return _selector.size;
}

- (LLScreenShotSelectorAction)color {
    return _selector.color;
}

- (UIColor *)redColor {
    if (!_redColor) {
        _redColor = [UIColor colorWithRed:0xd8/255.0 green:0x1e/255.0 blue:0x06/255.0 alpha:1];
    }
    return _redColor;
}

- (UIColor *)blueColor {
    if (!_blueColor) {
        _blueColor = [UIColor colorWithRed:0x12/255.0 green:0x96/255.0 blue:0xdb/255.0 alpha:1];
    }
    return _blueColor;
}

- (UIColor *)greenColor {
    if (!_greenColor) {
        _greenColor = [UIColor colorWithRed:0x1a/255.0 green:0xfa/255.0 blue:0x29/255.0 alpha:1];
    }
    return _greenColor;
}

- (UIColor *)yellowColor {
    if (!_yellowColor) {
        _yellowColor = [UIColor colorWithRed:0xf4/255.0 green:0xea/255.0 blue:0x2a/255.0 alpha:1];
    }
    return _yellowColor;
}

- (UIColor *)grayColor {
    if (!_grayColor) {
        _grayColor = [UIColor colorWithRed:0x2c/255.0 green:0x2c/255.0 blue:0x2c/255.0 alpha:1];
    }
    return _grayColor;
}

- (UIColor *)whiteColor {
    if (!_whiteColor) {
        _whiteColor = [UIColor whiteColor];
    }
    return _whiteColor;
}

#pragma mark - Primary
- (CGRect)rectWithPoint:(CGPoint)point {
    CGFloat size = [self sizeBySelector] / 2.0;
    return CGRectMake(point.x - size, point.y - size, size, size);
}

- (CGFloat)sizeBySelector {
    switch (self.size) {
        case LLScreenShotSelectorActionSmall:
            return 3;
        case LLScreenShotSelectorActionMedium:
            return 6;
        case LLScreenShotSelectorActionBig:
            return 9;
        default:
            break;
    }
    return 3;
}

- (UIColor *)colorBySelector {
    switch (self.color) {
        case LLScreenShotSelectorActionRed:
            return self.redColor;
        case LLScreenShotSelectorActionBlue:
            return self.blueColor;
        case LLScreenShotSelectorActionGreen:
            return self.greenColor;
        case LLScreenShotSelectorActionYellow:
            return self.yellowColor;
        case LLScreenShotSelectorActionGray:
            return self.grayColor;
        case LLScreenShotSelectorActionWhite:
            return self.whiteColor;
        default:
            break;
    }
    return self.whiteColor;
}

@end

@implementation LLScreenShotRectOperation

- (void)drawImageView:(CGRect)rect {
    CGRect rectPath = CGRectZero;
    if (self.startValue && self.endValue) {
        rectPath = [LLTool rectWithPoint:self.startValue.CGPointValue otherPoint:self.endValue.CGPointValue];
    }
    [self configPathWithRect:rectPath];
}

- (void)configPathWithRect:(CGRect)rect {
    self.path = [UIBezierPath bezierPathWithRect:rect];
    self.layer.lineWidth = [self sizeBySelector];
    self.layer.strokeColor = [self colorBySelector].CGColor;
    self.layer.fillColor = nil;
    self.layer.path = self.path.CGPath;
}

@end

@implementation LLScreenShotRoundOperation

- (void)drawImageView:(CGRect)rect {
    CGRect rectPath = CGRectZero;
    if (self.startValue && self.endValue) {
        rectPath = [LLTool rectWithPoint:self.startValue.CGPointValue otherPoint:self.endValue.CGPointValue];
    }
    [self configPathWithRect:rectPath];
}

- (void)configPathWithRect:(CGRect)rect {
    self.path = [UIBezierPath bezierPathWithOvalInRect:rect];
    self.layer.lineWidth = [self sizeBySelector];
    self.layer.strokeColor = [self colorBySelector].CGColor;
    self.layer.fillColor = nil;
    self.layer.path = self.path.CGPath;
}

@end

@implementation LLScreenShotArrowOperation

- (void)drawImageView:(CGRect)rect {
    CGRect rectPath = CGRectZero;
    if (self.startValue && self.endValue) {
        rectPath = [LLTool rectWithPoint:self.startValue.CGPointValue otherPoint:self.endValue.CGPointValue];
    }
    [self configPathWithRect:rectPath];
}

- (void)configPathWithRect:(CGRect)rect {
    
    UIImage *image = [UIImage imageNamed:kSelectorArrowImageName];
    [image drawInRect:rect];
//    self.path = [UIBezierPath bezierPathWithOvalInRect:rect];
//    self.layer.lineWidth = [self sizeBySelector];
//    self.layer.strokeColor = [self colorBySelector].CGColor;
//    self.layer.fillColor = nil;
//    self.layer.path = self.path.CGPath;
}

@end

@implementation LLScreenShotPenOperation

- (instancetype)initWithSelector:(LLScreenShotSelectorModel *)selector action:(LLScreenShotAction)action {
    if (self = [super initWithSelector:selector action:action]) {
        self.values = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addValue:(NSValue *)value {
    [self.values addObject:value];
    if (self.values.count == 1) {
        [self.path moveToPoint:value.CGPointValue];
    } else {
        [self.path addLineToPoint:value.CGPointValue];
    }
}

- (void)drawImageView:(CGRect)rect {
    self.layer.lineWidth = [self sizeBySelector];
    self.layer.strokeColor = [self colorBySelector].CGColor;
    self.layer.fillColor = nil;
    self.layer.path = self.path.CGPath;
}

@end
