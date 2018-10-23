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

@property (strong , nonatomic) CAShapeLayer *lineLayer;

@property (strong , nonatomic) CAShapeLayer *dashLineLayer;

@property (nonatomic , strong) LLHierarchyModel *model;



@property (nonatomic , assign) BOOL isFold;

@end

@implementation LLHierarchyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (void)confirmWithModel:(LLHierarchyModel *)model {
    _model = model;
    
    CGFloat lineGap = 12;
    
//    CGFloat lineViewWidth = lineWidth * model.section + lineGap * (model.section + 0);
    _lineViewWidthConstraint.constant = lineGap * (model.section + 1);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
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
    
    _isFold = model.isFold;
    
}

- (void)updateForNext {

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
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.lineWidth = 2;
    self.lineLayer.strokeColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.lineLayer.fillColor = nil;
    [self.lineView.layer insertSublayer:self.lineLayer atIndex:0];
    
    self.dashLineLayer = [CAShapeLayer layer];
    self.dashLineLayer.lineWidth = 2;
    self.dashLineLayer.strokeColor = LLCONFIG_TEXT_COLOR.CGColor;
    self.dashLineLayer.fillColor = nil;
    self.dashLineLayer.lineDashPattern = @[@(5),@(5)];
    [self.lineView.layer insertSublayer:self.dashLineLayer atIndex:0];
    
    UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
    self.directionImageView.image = [[UIImage LL_imageNamed:@"LL-bottom"] imageWithRenderingMode:mode];
    [self.infoButton setImage:[[UIImage LL_imageNamed:@"LL-info"] imageWithRenderingMode:mode] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineGap = 12;
    
    BOOL isFirstInCurrentSection = self.model.isFirstInCurrentSection;
    BOOL isLastInCurrentSection = self.model.isLastInCurrentSection;
    BOOL isSingleInCurrentSection = self.model.isSingleInCurrentSection;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    
    if (self.model.section == 0) {
        // Handle the first row separately
        if (!self.model.isFold) {
            [path moveToPoint:self.circleView.center];
            [path addLineToPoint:CGPointMake(self.circleView.center.x, self.contentView.frame.size.height)];
        }
    } else {
        // Handle normal rows.
        if (isFirstInCurrentSection) {
            // If is first in current section, draw left top line to connect last cell.
            [path moveToPoint:self.circleView.center];
            [path addLineToPoint:CGPointMake(self.circleView.center.x - lineGap, self.circleView.center.y)];
            [path addLineToPoint:CGPointMake(self.circleView.center.x - lineGap, 0)];
        }
        
        if (self.model.subModels.count != 0 && !self.model.isFold) {
            [path moveToPoint:self.circleView.center];
            [path addLineToPoint:CGPointMake(self.circleView.center.x, self.contentView.frame.size.height)];
        }
        
        if (!isSingleInCurrentSection) {
            LLHierarchyModel *lastModel = self.model.lastModelInCurrentSection;
            // Isn't a single.
            if (isLastInCurrentSection) {
                // If is last, draw line to last cell.
                if (!lastModel.isFold && lastModel.subModels.count != 0) {
                    [path2 moveToPoint:self.circleView.center];
                    [path2 addLineToPoint:CGPointMake(self.circleView.center.x, 0)];
                } else {
                    [path moveToPoint:self.circleView.center];
                    [path addLineToPoint:CGPointMake(self.circleView.center.x, 0)];
                }
            } else if (isFirstInCurrentSection) {
                [path moveToPoint:self.circleView.center];
                [path addLineToPoint:CGPointMake(self.circleView.center.x, self.contentView.frame.size.height)];
            } else {
                // If isn't the last and the first.
                [path moveToPoint:self.circleView.center];
                [path addLineToPoint:CGPointMake(self.circleView.center.x, self.contentView.frame.size.height)];
                if (!lastModel.isFold && lastModel.subModels.count != 0) {
                    [path2 moveToPoint:self.circleView.center];
                    [path2 addLineToPoint:CGPointMake(self.circleView.center.x, 0)];
                } else {
                    [path moveToPoint:self.circleView.center];
                    [path addLineToPoint:CGPointMake(self.circleView.center.x, 0)];
                }
            }
        }
        
        LLHierarchyModel *parentModel = self.model.parentModel;
        while (parentModel.section != 0 && parentModel != nil) {
            if (![parentModel isLastInCurrentSection]) {
                [path2 moveToPoint:CGPointMake(self.circleView.center.x - (self.model.section - parentModel.section) * lineGap, 0)];
                [path2 addLineToPoint:CGPointMake(self.circleView.center.x - (self.model.section - parentModel.section) * lineGap, self.contentView.frame.size.height)];
            }
            parentModel = parentModel.parentModel;
        }
    }

    self.lineLayer.path = path.CGPath;
    self.dashLineLayer.path = path2.CGPath;
}

- (UIColor *)colorFromView:(UIView *)view {
    CGFloat hue = (((NSUInteger)view >> 4) % 256) / 255.0;
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

@end
