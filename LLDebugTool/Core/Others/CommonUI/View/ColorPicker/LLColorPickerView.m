//
//  LLColorPickerView.m
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

#import "LLColorPickerView.h"
#import "LLHSBPreviewView.h"
#import "UIView+LL_Utils.h"

@interface LLColorPickerView ()

@property (nonatomic, strong) LLHSBPreviewView *preview;

@end

@implementation LLColorPickerView

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    [self.contentView addSubview:self.preview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentViewBottom = self.contentView.LL_bottom;
    self.preview.frame = CGRectMake((self.contentView.LL_width - 300) / 2.0, 10, 300, 200);
    self.contentView.LL_height = 200 + 10 * 2;
    self.contentView.LL_bottom = contentViewBottom;
}

#pragma mark - Getters and setters
- (LLHSBPreviewView *)preview {
    if (!_preview) {
        _preview = [[LLHSBPreviewView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    }
    return _preview;
}

@end
