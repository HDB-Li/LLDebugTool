//
//  LLHierarchyCell.m
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

#import "LLHierarchyCell.h"

@interface LLHierarchyCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (nonatomic , strong) LLHierarchyModel *model;

@end

@implementation LLHierarchyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
    // Initialization code
}

- (void)confirmWithModel:(LLHierarchyModel *)model {
    _model = model;
}

#pragma mark - Primary
- (void)initial {
    
}

- (UIColor *)colorFromView:(UIView *)view {
    CGFloat hue = (((NSUInteger)view >> 4) % 256) / 255.0;
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

@end
