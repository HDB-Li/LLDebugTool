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

@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UIView *nextLineView;

@property (weak, nonatomic) IBOutlet UIView *preLineView;

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
        
    CGFloat lineWidth = 0;
    CGFloat lineGap = 12;
    for (int i = 0; i < model.section; i++) {
        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = LLCONFIG_TEXT_COLOR;
        [self.lineView addSubview:line];
        line.frame = CGRectMake(lineWidth * i + lineGap * (i + 1), 0, lineWidth, self.contentView.frame.size.height);
        
        NSLayoutConstraint *layout1 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *layout2 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *layout3 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:lineWidth];
        NSLayoutConstraint *layout4 = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeLeading multiplier:1 constant:lineWidth * 2 * i];
//        [line addConstraints:@[layout1,layout2,layout4]];
    }
    
    CGFloat lineViewWidth = lineWidth * model.section + lineGap * (model.section + 0);
    _lineViewWidthConstraint.constant = lineViewWidth;
    
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.frame;
    self.circleView.backgroundColor = [self colorFromView:model.view];
    
    if (model.subModels.count) {
        self.directionImageView.hidden = NO;
        if (model.isFold) {
            self.directionImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            self.directionImageView.transform = CGAffineTransformIdentity;
        }
    } else {
        self.directionImageView.hidden = YES;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CAShapeLayer *layer = self.lineView.layer.sublayers.firstObject;
    if (model.section == 0) {
        layer.path = [UIBezierPath bezierPath].CGPath;
        self.preLineView.hidden = YES;
    } else {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(lineViewWidth - 1, 0)];
        [path addLineToPoint:CGPointMake(lineViewWidth - 1, self.circleView.center.y + 1)];
        layer.path = path.CGPath;
        self.preLineView.hidden = NO;
    }
    
    self.nextLineView.hidden = NO;
    
    _isFold = model.isFold;
    
}

- (void)updateForNext {
    self.nextLineView.hidden = YES;
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
    
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.minimumScaleFactor = 0.5;
    
    self.circleView.backgroundColor = LLCONFIG_TEXT_COLOR;
    self.circleView.layer.cornerRadius = 12 / 2.0;
    self.circleView.layer.masksToBounds = YES;
    
    self.preLineView.backgroundColor = LLCONFIG_TEXT_COLOR;
    self.nextLineView.backgroundColor = LLCONFIG_TEXT_COLOR;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 2;
    layer.strokeColor = LLCONFIG_TEXT_COLOR.CGColor;
    [self.lineView.layer addSublayer:layer];
    
    UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
    self.directionImageView.image = [[UIImage LL_imageNamed:@"LL-bottom"] imageWithRenderingMode:mode];
    [self.infoButton setImage:[[UIImage LL_imageNamed:@"LL-info"] imageWithRenderingMode:mode] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (UIColor *)colorFromView:(UIView *)view {
    CGFloat hue = (((NSUInteger)view >> 4) % 256) / 255.0;
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

@end
