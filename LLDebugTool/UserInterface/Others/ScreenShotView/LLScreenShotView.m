//
//  LLScreenShotView.m
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

#import "LLScreenShotView.h"
#import <Photos/PHPhotoLibrary.h>
#import "LLScreenShotToolbar.h"
#import "LLStorageManager.h"
#import "LLDebugTool.h"
#import "LLWindow.h"
#import "LLMacros.h"
#import "LLScreenShotBaseOperation.h"

@interface LLScreenShotView () <LLScreenShotToolbarDelegate>

@property (nonatomic , strong , nonnull) UIImage *image;

@property (nonatomic , assign) LLScreenShotAction currentAction;

@property (nonatomic , strong , nullable) LLScreenShotSelectorModel *currentSelectorModel;

@property (nonatomic , strong , nullable) LLScreenShotBaseOperation *currentOperation;

@property (nonatomic , strong) NSMutableArray <LLScreenShotBaseOperation *>*operations;

@end

@implementation LLScreenShotView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _image = image;
        [self initial];
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = CGRectMake(0, LL_SCREEN_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    [window addSubview:self];
    [[LLDebugTool sharedTool].window hideWindow];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, LL_SCREEN_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[LLDebugTool sharedTool].window showWindow];
    }];
}

- (void)cancelAction {
    [self hide];
}

- (void)confirmAction {
    [[LLStorageManager sharedManager] saveScreenShots:self.image name:nil];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    }
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case LLScreenShotActionRect:{
            LLScreenShotRectOperation *operation = [[LLScreenShotRectOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.layer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionRound:{
            LLScreenShotRoundOperation *operation = [[LLScreenShotRoundOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.layer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionArrow:{
            LLScreenShotArrowOperation *operation = [LLScreenShotArrowOperation]
        }
            break;
        case LLScreenShotActionPen:{
            LLScreenShotPenOperation *operation = [[LLScreenShotPenOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.layer addSublayer:operation.layer];
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionBack:
        case LLScreenShotActionCancel:
        case LLScreenShotActionConfirm:
            return;
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case LLScreenShotActionRect:{
            LLScreenShotRectOperation *operation = (LLScreenShotRectOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionRound:{
            LLScreenShotRoundOperation *operation = (LLScreenShotRoundOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionPen:{
            LLScreenShotPenOperation *operation = (LLScreenShotPenOperation *)self.currentOperation;
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // Call end if cancelled.
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case LLScreenShotActionRect:{
            LLScreenShotRectOperation *operation = (LLScreenShotRectOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionRound:{
            LLScreenShotRoundOperation *operation = (LLScreenShotRoundOperation *)self.currentOperation;
            operation.endValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionPen:{
            LLScreenShotPenOperation *operation = (LLScreenShotPenOperation *)self.currentOperation;
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.currentOperation drawImageView:rect];
}

#pragma mark - Primary
- (void)initial {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.operations = [[NSMutableArray alloc] init];
    
    CGFloat rate = 0.1;
    CGFloat toolBarHeight = 80;
    CGFloat imgViewWidth = (1 - rate * 2) * LL_SCREEN_WIDTH;
    CGFloat imgViewHeight = (1 - rate * 2) * LL_SCREEN_HEIGHT;
    CGFloat imgViewTop = (rate * 2 * LL_SCREEN_HEIGHT - toolBarHeight) / 2.0;
    // Init ImageView
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.image];
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.frame = CGRectMake(rate * LL_SCREEN_WIDTH, imgViewTop, imgViewWidth, imgViewHeight);
    CALayer *layer = imgView.layer;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.5;
    [self addSubview:imgView];
    
    // Init Controls
    LLScreenShotToolbar *toolBar = [[LLScreenShotToolbar alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 10, imgView.frame.size.width, toolBarHeight)];
    toolBar.delegate = self;
    [self addSubview:toolBar];
}

- (void)updateButtonStyle:(UIButton *)sender {
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.layer.cornerRadius = 5;
    sender.layer.shadowColor = [UIColor blackColor].CGColor;
    sender.layer.shadowOffset = CGSizeZero;
    sender.layer.shadowOpacity = 0.5;
    sender.layer.masksToBounds = YES;
}

#pragma mark - LLScreenShotToolbarDelegate
- (void)LLScreenShotToolbar:(LLScreenShotToolbar *)toolBar didSelectedAction:(LLScreenShotAction)action selectorModel:(LLScreenShotSelectorModel *)selectorModel {
    if (action <= LLScreenShotActionText) {
        self.currentAction = action;
        self.currentSelectorModel = selectorModel;
    } else if (action == LLScreenShotActionBack) {
        
    } else if (action == LLScreenShotActionCancel) {
        [self cancelAction];
    } else if (action == LLScreenShotActionConfirm) {
        [self confirmAction];
    }
}

@end
