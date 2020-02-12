//
//  LLRulerViewController.m
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

#import "LLRulerViewController.h"

#import "LLRulerPickerInfoView.h"
#import "LLRulerPickerView.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConst.h"

#import "UIView+LL_Utils.h"

@interface LLRulerViewController ()<LLRulerPickerViewDelegate, LLInfoViewDelegate>

@property (nonatomic, strong) LLRulerPickerView *pickerView;

@property (nonatomic, strong) LLRulerPickerInfoView *infoView;

@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, strong) UIView *horizontalLine;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation LLRulerViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startPoint = CGPointZero;
    [self.view.layer addSublayer:self.lineLayer];
    self.view.backgroundColor = [UIColor clearColor];
    self.updateBackgroundColor = NO;
    
    [self.view addSubview:self.horizontalLine];
    [self.view addSubview:self.verticalLine];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.rightLabel];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.infoView];
}

#pragma mark - LLRulerPickerViewDelegate
- (void)LLRulerPickerView:(LLRulerPickerView *)view didUpdatePoint:(CGPoint)pointInWindow state:(UIGestureRecognizerState)state {
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            self.topLabel.hidden = NO;
            self.leftLabel.hidden = NO;
            self.rightLabel.hidden = NO;
            self.bottomLabel.hidden = NO;
            self.lineLayer.path = nil;
            self.startPoint = pointInWindow;
            [self.infoView updateStartPoint:pointInWindow];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            self.topLabel.hidden = YES;
            self.leftLabel.hidden = YES;
            self.rightLabel.hidden = YES;
            self.bottomLabel.hidden = YES;
        }
        default: {
            CGFloat x = pointInWindow.x;
            CGFloat y = pointInWindow.y;
            
            self.topLabel.text = [NSString stringWithFormat:@"%0.2f",y];
            [self.topLabel sizeToFit];
            self.topLabel.LL_centerY = y / 2.0;
            
            self.bottomLabel.text = [NSString stringWithFormat:@"%0.2f",LL_SCREEN_HEIGHT - y];
            [self.bottomLabel sizeToFit];
            self.bottomLabel.LL_centerY = y + (LL_SCREEN_HEIGHT - y) / 2.0;
            
            self.leftLabel.text = [NSString stringWithFormat:@"%0.2f",x];
            [self.leftLabel sizeToFit];
            self.leftLabel.LL_centerX = x / 2.0;
            
            self.rightLabel.text = [NSString stringWithFormat:@"%0.2f",LL_SCREEN_WIDTH - x];
            [self.rightLabel sizeToFit];
            self.rightLabel.LL_centerX = x + (LL_SCREEN_WIDTH - x) / 2.0;
            
            self.horizontalLine.LL_centerY = y;
            if (y < LL_SCREEN_HEIGHT / 2.0) {
                self.leftLabel.LL_y = y;
                self.rightLabel.LL_y = y;
            } else {
                self.leftLabel.LL_bottom = y;
                self.rightLabel.LL_bottom = y;
            }
            
            self.verticalLine.LL_centerX = x;
            if (x < LL_SCREEN_WIDTH / 2.0) {
                self.topLabel.LL_x = x;
                self.bottomLabel.LL_x = x;
            } else {
                self.topLabel.LL_right = x;
                self.bottomLabel.LL_right = x;
            }
            
            self.lineLayer.path = [self pathWithPoint:self.startPoint anotherPoint:pointInWindow].CGPath;
            [self.infoView updatePoint:pointInWindow];
        }
            break;
    }
}

#pragma mark - LLBaseInfoViewDelegate
- (void)LLInfoViewDidSelectCloseButton:(LLInfoView *)view {
    [self componentDidLoad:nil];
}

#pragma mark - Primary
- (UIView *)getPickerLine {
    UIView *view = [LLFactory getView];
    view.backgroundColor = [LLThemeManager shared].primaryColor;
    return view;
}

- (UILabel *)getPickerLabel {
    UILabel *label = [LLFactory getLabel:nil frame:CGRectZero text:nil font:16 textColor:[LLThemeManager shared].primaryColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [LLThemeManager shared].backgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.LL_horizontalPadding = 5;
    label.LL_verticalPadding = 5;
    [label LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    return label;
}

- (UIBezierPath *)pathWithPoint:(CGPoint)point anotherPoint:(CGPoint)anotherPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:anotherPoint];
    return path;
}

#pragma mark - Getters and setters
- (LLRulerPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat width = 70;
        _pickerView = [[LLRulerPickerView alloc] initWithFrame:CGRectMake((LL_SCREEN_WIDTH - width) / 2.0, (LL_SCREEN_HEIGHT - width) / 2.0, width, width)];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (LLRulerPickerInfoView *)infoView {
    if (!_infoView) {
        CGFloat height = 60;
        _infoView = [[LLRulerPickerInfoView alloc] initWithFrame:CGRectMake(kLLGeneralMargin, LL_SCREEN_HEIGHT - kLLGeneralMargin * 2 - height, LL_SCREEN_WIDTH - kLLGeneralMargin * 2, height)];
        _infoView.delegate = self;
    }
    return _infoView;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [self getPickerLine];
        _verticalLine.LL_height = LL_SCREEN_HEIGHT;
        _verticalLine.LL_width = kLLRulerLineWidth;
    }
    return _verticalLine;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [self getPickerLine];
        _horizontalLine.LL_width = LL_SCREEN_WIDTH;
        _horizontalLine.LL_height = kLLRulerLineWidth;
    }
    return _horizontalLine;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [self getPickerLabel];
    }
    return _topLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [self getPickerLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [self getPickerLabel];
    }
    return _rightLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [self getPickerLabel];
    }
    return _bottomLabel;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.fillColor = nil;
        _lineLayer.strokeColor = [UIColor redColor].CGColor;
        _lineLayer.lineWidth = 5;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.frame = self.view.bounds;
        _lineLayer.lineDashPattern = @[@(5),@(10)];
    }
    return _lineLayer;
}

@end
