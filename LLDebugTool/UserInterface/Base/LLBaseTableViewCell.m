//
//  LLBaseTableViewCell.m
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

#import "LLBaseTableViewCell.h"
#import "LLConfig.h"

@implementation LLBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseInitial];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self baseInitial];
    }
    return self;
}

#pragma mark - Primary
- (void)baseInitial {
    self.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [LLCONFIG_TEXT_COLOR colorWithAlphaComponent:0.2];
    self.textLabel.textColor = LLCONFIG_TEXT_COLOR;
    self.detailTextLabel.textColor = LLCONFIG_TEXT_COLOR;
    [self configSubviews:self];
}

- (void)configSubviews:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel *)view).textColor = LLCONFIG_TEXT_COLOR;
    }
    if (view.subviews) {
        for (UIView *subView in view.subviews) {
            [self configSubviews:subView];
        }
    }
}

@end
