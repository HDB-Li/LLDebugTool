//
//  LLEntryView.m
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

#import "LLEntryView.h"

#import "LLFactory.h"

@interface LLEntryView ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation LLEntryView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.styleModel = [[LLEntryStyleModel alloc] init];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

#pragma mark - Getters and setters
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [LLFactory getView];
    }
    return _contentView;
}

@end
