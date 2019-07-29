//
//  LLMagnifierColorWindow.m
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

#import "LLMagnifierColorWindow.h"
#import "LLMacros.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLImageNameConfig.h"
#import "LLConfig.h"
#import "UIColor+LL_Utils.h"
#import "LLWindowManager.h"

@interface LLMagnifierColorWindow ()

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UILabel *colorLabel;

@end

@implementation LLMagnifierColorWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)updateColor:(UIColor *)color point:(CGPoint)point {
    self.colorView.backgroundColor = color;
    NSArray *rgb = [color getRGBA];
    NSInteger r = [rgb[0] integerValue];
    NSInteger g = [rgb[1] integerValue];
    NSInteger b = [rgb[2] integerValue];
    
    self.colorLabel.text = [NSString stringWithFormat:@"R: %@, G: %@, B: %@. (#%02lx%02lx%02lx)\nX: %0.1f, Y: %0.1f", rgb[0], rgb[1], rgb[2],(long)r,(long)g,(long)b, point.x, point.y];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect closeButtonRect = CGRectMake(self.LL_width - 10 - 30, 10, 30, 30);
    if (!CGRectEqualToRect(self.closeButton.frame, closeButtonRect)) {
        self.closeButton.frame = closeButtonRect;
    }
    
    CGRect colorRect = CGRectMake(20, (self.LL_height - 20) / 2.0, 20, 20);
    if (!CGRectEqualToRect(self.colorView.frame, colorRect)) {
        self.colorView.frame = colorRect;
    }
    
    CGRect colorLabelRect = CGRectMake(self.colorView.LL_right + 20, 0, self.LL_width - self.colorView.LL_right - 20, self.LL_height);
    if (!CGRectEqualToRect(self.colorLabel.frame, colorLabelRect)) {
        self.colorLabel.frame = colorLabelRect;
    }
}

#pragma mark - Primary
- (void)initial {
    if (!self.rootViewController) {
        self.rootViewController = [[UIViewController alloc] init];
    }
    self.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    
    self.closeButton = [LLFactory getButton:self frame:CGRectZero target:self action:@selector(closeButtonClicked:)];
    [self.closeButton setImage:[UIImage LL_imageNamed:kCloseImageName color:LLCONFIG_TEXT_COLOR] forState:UIControlStateNormal];
    
    self.colorView = [LLFactory getView:self frame:CGRectZero];
    
    self.colorLabel = [LLFactory getLabel:self frame:CGRectZero text:nil font:14 textColor:LLCONFIG_TEXT_COLOR];
    self.colorLabel.numberOfLines = 0;
    
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    [self addGestureRecognizer:pan];
}

- (void)panGR:(UIPanGestureRecognizer *)sender {
    
    CGPoint offsetPoint = [sender translationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    [self changeFrameWithPoint:offsetPoint];
    
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
    
    if (self.LL_left < 0) {
        self.LL_left = 0;
    }
    if (self.LL_right > LL_SCREEN_WIDTH) {
        self.LL_right = LL_SCREEN_WIDTH;
    }
}

- (void)closeButtonClicked:(UIButton *)sender {
    
}

@end
