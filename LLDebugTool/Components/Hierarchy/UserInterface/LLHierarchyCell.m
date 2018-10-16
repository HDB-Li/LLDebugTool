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
#import "LLConfig.h"
#import "UIImage+LL_Utils.h"

@interface LLHierarchyCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directionImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (nonatomic , strong) LLHierarchyModel *model;

@property (nonatomic , assign) BOOL isFold;

@end

@implementation LLHierarchyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
    // Initialization code
}

- (void)confirmWithModel:(LLHierarchyModel *)model {
    _model = model;
    
    for (UIView *subView in self.lineView.subviews) {
        [subView removeFromSuperview];
    }
        
    CGFloat lineWidth = 1.5;
    CGFloat lineGap = 3;
    for (int i = 0; i < model.section; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LLCONFIG_TEXT_COLOR;
        [self.lineView addSubview:line];
        line.frame = CGRectMake(lineWidth * i + lineGap * (i + 1), 0, lineWidth, self.contentView.frame.size.height);
        
        NSLayoutConstraint *layout1 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *layout2 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *layout3 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:lineWidth];
        NSLayoutConstraint *layout4 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeLeading multiplier:1 constant:lineWidth * 2 * i];
//        [line addConstraints:@[layout1,layout2,layout4]];
    }
    
    _lineViewWidthConstraint.constant = lineWidth * model.section + lineGap * (model.section + 1);
    
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.frame;
    
    if (model.subModels.count) {
        if (self.directionImageViewWidthConstraint.constant != 15) {
            self.directionImageViewWidthConstraint.constant = 15;
        }
        self.directionImageView.hidden = NO;
        if (model.isFold) {
            self.directionImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            self.directionImageView.transform = CGAffineTransformIdentity;
        }
    } else {
        if (self.directionImageViewWidthConstraint.constant != 0) {
            self.directionImageViewWidthConstraint.constant = 0;
        }
        self.directionImageView.hidden = YES;
    }
    _isFold = model.isFold;
}

- (void)updateDirection {
    if (self.model.isFold != self.isFold) {
        self.isFold = self.model.isFold;
        if (self.model.isFold) {
            [UIView animateWithDuration:0.25 animations:^{
                self.directionImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.directionImageView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

#pragma mark - Primary
- (void)initial {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    
    self.lineView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    
    UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
    self.directionImageView.image = [[UIImage LL_imageNamed:@"LL-bottom"] imageWithRenderingMode:mode];
    [self.selectButton setImage:[[UIImage LL_imageNamed:@"LL-pick"] imageWithRenderingMode:mode] forState:UIControlStateNormal];
    [self.infoButton setImage:[[UIImage LL_imageNamed:@"LL-info"] imageWithRenderingMode:mode] forState:UIControlStateNormal];
}

- (UIColor *)colorFromView:(UIView *)view {
    CGFloat hue = (((NSUInteger)view >> 4) % 256) / 255.0;
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

@end
