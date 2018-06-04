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
#import "LLScreenShotBaseOperation.h"
#import "LLScreenShotToolbar.h"
#import "LLStorageManager.h"
#import "LLDebugTool.h"
#import "LLWindow.h"
#import "LLMacros.h"
#import "LLTool.h"

@interface LLScreenShotView () <LLScreenShotToolbarDelegate>

@property (nonatomic , strong) UIView *imageBackgroundView;

@property (nonatomic , assign) LLScreenShotAction currentAction;

@property (nonatomic , strong , nullable) LLScreenShotSelectorModel *currentSelectorModel;

@property (nonatomic , strong , nullable) LLScreenShotBaseOperation *currentOperation;

@property (nonatomic , strong) NSMutableArray <LLScreenShotBaseOperation *>*operations;

@property (nonatomic , strong) LLScreenShotToolbar *toolBar;

@end

@implementation LLScreenShotView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initialWithImage:image];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, LL_SCREEN_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[LLDebugTool sharedTool].window showWindow];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (void)cancelAction {
    [self hide];
}

- (void)confirmAction {
    self.toolBar.hidden = YES;
    UIImage *image = [self convertViewToImage:self];
    if (image) {
        [[LLStorageManager sharedManager] saveScreenShots:image name:nil];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [[LLTool sharedTool] toastMessage:@"Save image in sandbox and album."];
        } else {
            [[LLTool sharedTool] toastMessage:@"Save image in sandbox."];
        }
        [self hide];
    } else {
        self.toolBar.hidden = NO;
        [[LLTool sharedTool] toastMessage:@"Save image failed."];
    }
}

#pragma mark - NSNotification
- (void)keyboardWillShowNotification:(NSNotification *)notifi {
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notifi {
    
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.currentOperation isKindOfClass:[LLScreenShotTextOperation class]]) {
        LLScreenShotTextOperation *operation = (LLScreenShotTextOperation *)self.currentOperation;
        [operation.textView resignFirstResponder];
        if (self.currentAction == LLScreenShotActionText) {
            self.currentOperation = nil;
            return;
        }
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    switch (self.currentAction) {
        case LLScreenShotActionRect:{
            LLScreenShotRectOperation *operation = [[LLScreenShotRectOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.imageBackgroundView.layer addSublayer:operation.layer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionRound:{
            LLScreenShotRoundOperation *operation = [[LLScreenShotRoundOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.imageBackgroundView.layer addSublayer:operation.layer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionLine:{
            LLScreenShotLineOperation *operation = [[LLScreenShotLineOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.imageBackgroundView.layer addSublayer:operation.layer];
            operation.startValue = pointValue;
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionPen:{
            LLScreenShotPenOperation *operation = [[LLScreenShotPenOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.imageBackgroundView.layer addSublayer:operation.layer];
            [operation addValue:pointValue];
            [self setNeedsDisplay];
        }
            break;
        case LLScreenShotActionText:{
            LLScreenShotTextOperation *operation = [[LLScreenShotTextOperation alloc] initWithSelector:self.currentSelectorModel action:self.currentAction];
            self.currentOperation = operation;
            [self.operations addObject:operation];
            [self.imageBackgroundView addSubview:operation.textView];
            operation.textView.frame = CGRectMake(point.x, point.y, LL_SCREEN_WIDTH - point.x - 10, 30);
            [operation.textView becomeFirstResponder];
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
        case LLScreenShotActionLine:{
            LLScreenShotLineOperation *operation = (LLScreenShotLineOperation *)self.currentOperation;
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
        case LLScreenShotActionLine:{
            LLScreenShotLineOperation *operation = (LLScreenShotLineOperation *)self.currentOperation;
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
- (void)initialWithImage:(UIImage *)image {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.operations = [[NSMutableArray alloc] init];
    
    self.imageBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.imageBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageBackgroundView];
    
    CGFloat rate = 0.1;
    CGFloat toolBarHeight = 80;
    CGFloat imgViewWidth = (1 - rate * 2) * LL_SCREEN_WIDTH;
    CGFloat imgViewHeight = (1 - rate * 2) * LL_SCREEN_HEIGHT;
    CGFloat imgViewTop = (rate * 2 * LL_SCREEN_HEIGHT - toolBarHeight) / 2.0;
    // Init ImageView
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.frame = CGRectMake(rate * LL_SCREEN_WIDTH, imgViewTop, imgViewWidth, imgViewHeight);
    CALayer *layer = imgView.layer;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.5;
    [self.imageBackgroundView addSubview:imgView];
    
    // Init Controls
    self.toolBar = [[LLScreenShotToolbar alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 10, imgView.frame.size.width, toolBarHeight)];
    self.toolBar.delegate = self;
    [self addSubview:self.toolBar];
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

- (UIImage *)convertViewToImage:(UIView*)view{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - LLScreenShotToolbarDelegate
- (void)LLScreenShotToolbar:(LLScreenShotToolbar *)toolBar didSelectedAction:(LLScreenShotAction)action selectorModel:(LLScreenShotSelectorModel *)selectorModel {
    if (action <= LLScreenShotActionText) {
        self.currentAction = action;
        self.currentSelectorModel = selectorModel;
    } else if (action == LLScreenShotActionBack) {
        LLScreenShotBaseOperation *operation = self.operations.lastObject;
        switch (operation.action) {
            case LLScreenShotActionRect:
            case LLScreenShotActionRound:
            case LLScreenShotActionLine:
            case LLScreenShotActionPen:{
                LLScreenShotTwoValueOperation *oper = (LLScreenShotTwoValueOperation *)operation;
                [oper.layer removeFromSuperlayer];
                [self.operations removeObject:oper];
            }
                break;
            case LLScreenShotActionText:{
                LLScreenShotTextOperation *oper = (LLScreenShotTextOperation *)operation;
                [oper.textView removeFromSuperview];
                [self.operations removeObject:oper];
            }
                break;
            default:
                break;
        }
    } else if (action == LLScreenShotActionCancel) {
        [self cancelAction];
    } else if (action == LLScreenShotActionConfirm) {
        [self confirmAction];
    }
}

@end
