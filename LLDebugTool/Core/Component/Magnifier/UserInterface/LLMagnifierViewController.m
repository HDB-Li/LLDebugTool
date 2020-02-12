//
//  LLMagnifierViewController.m
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

#import "LLMagnifierViewController.h"

#import "LLMagnifierInfoView.h"
#import "LLInternalMacros.h"
#import "LLMagnifierView.h"
#import "LLConfig.h"
#import "LLConst.h"

@interface LLMagnifierViewController ()<LLMagnifierViewDelegate, LLInfoViewDelegate>

@property (nonatomic, strong) LLMagnifierView *magnifierView;

@property (nonatomic, strong) LLMagnifierInfoView *infoView;

@end

@implementation LLMagnifierViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.updateBackgroundColor = NO;
    
    CGFloat height = 60;
    self.infoView = [[LLMagnifierInfoView alloc] initWithFrame:CGRectMake(kLLGeneralMargin, LL_SCREEN_HEIGHT - kLLGeneralMargin * 2 - height, LL_SCREEN_WIDTH - kLLGeneralMargin * 2, height)];
    self.infoView.delegate = self;
    [self.view addSubview:self.infoView];
    
    NSInteger width = [LLConfig shared].magnifierZoomLevel * [LLConfig shared].magnifierSize;
    self.magnifierView = [[LLMagnifierView alloc] initWithFrame:CGRectMake((LL_SCREEN_WIDTH - width) / 2, (LL_SCREEN_HEIGHT - width) / 2, width, width)];
    self.magnifierView.delegate = self;
    [self.view addSubview:self.magnifierView];
}

#pragma mark - LLMagnifierViewDelegate
- (void)LLMagnifierView:(LLMagnifierView *)view update:(NSString *)hexColor at:(CGPoint)point {
    [self.infoView update:hexColor point:point];
}

#pragma mark - LLBaseInfoViewDelegate
- (void)LLInfoViewDidSelectCloseButton:(LLInfoView *)view {
    [self componentDidLoad:nil];
}

@end
