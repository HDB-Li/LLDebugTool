//
//  LLScreenShotToolbar.m
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

#import "LLScreenShotToolbar.h"
#import "LLScreenShotActionView.h"
#import "LLScreenShotSelectorView.h"

@interface LLScreenShotToolbar ()

@property (nonatomic , strong) LLScreenShotActionView *actionView;

@property (nonatomic , strong) NSArray *tools;

@end

@implementation LLScreenShotToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
- (void)initial {
    CGFloat gap = 5;
    CGFloat itemHeight = (self.frame.size.height - gap) /2.0;
    self.actionView = [[LLScreenShotActionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemHeight)];
    [self addSubview:self.actionView];
}

- (NSArray *)tools {
    if (!_tools) {
        _tools = @[@"方",@"圆",@"箭头",@"画笔",@"文字",@"标签",@"分割",@"撤回",@"关闭",@"保存"];
    }
    return _tools;
}

@end
