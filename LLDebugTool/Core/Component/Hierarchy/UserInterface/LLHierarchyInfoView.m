//
//  LLHierarchyInfoView.m
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

#import "LLHierarchyInfoView.h"
#import "LLTool.h"
#import "UIColor+LL_Utils.h"
#import "UIView+LL_Utils.h"
#import "LLMacros.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLThemeManager.h"
#import "LLConst.h"
#import "LLToastUtils.h"
#import "LLImageNameConfig.h"
#import "UIView+LL_Utils.h"

@interface LLHierarchyInfoView ()

@property (nonatomic, strong, nullable) UIView *selectedView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *actionContentView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIButton *parentViewsButton;

@property (nonatomic, strong) UIButton *subviewsButton;

@property (nonatomic, assign) CGFloat actionContentViewHeight;

@end

@implementation LLHierarchyInfoView

@dynamic delegate;

- (void)updateSelectedView:(UIView *)selectedView {
    
    UIView *view = selectedView;
    
    if (!view) {
        return;
    }
    
    if (self.selectedView == view) {
        return;
    }
    
    self.moreButton.enabled = YES;
    self.parentViewsButton.enabled = view.superview != nil;
    self.subviewsButton.enabled = view.subviews.count;
    
    self.selectedView = view;
    
    NSDictionary *boldAttri = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    NSDictionary *attri = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:@"Name: " attributes:boldAttri];
    [name appendAttributedString:[[NSAttributedString alloc] initWithString:NSStringFromClass(view.class) attributes:attri]];
    
    [attribute appendAttributedString:name];
    
    NSMutableAttributedString *frame = [[NSMutableAttributedString alloc] initWithString:@"\nFrame: " attributes:boldAttri];
    [frame appendAttributedString:[[NSAttributedString alloc] initWithString:[LLTool stringFromFrame:view.frame] attributes:attri]];
    [attribute appendAttributedString:frame];
    
    if (view.backgroundColor) {
        NSMutableAttributedString *color = [[NSMutableAttributedString alloc] initWithString:@"\nBackground: " attributes:boldAttri];
        [color appendAttributedString:[[NSAttributedString alloc] initWithString:[view.backgroundColor LL_description] attributes:attri]];
        [attribute appendAttributedString:color];
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        NSMutableAttributedString *font = [[NSMutableAttributedString alloc] initWithString:@"\nText Color: " attributes:boldAttri];
        [font appendAttributedString:[[NSAttributedString alloc] initWithString:[label.textColor LL_description] attributes:attri]];
        [font appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nFont: " attributes:boldAttri]];
        [font appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f", label.font.pointSize] attributes:attri]];
        [attribute appendAttributedString:font];
    }
    
    if (view.tag != 0) {
        NSMutableAttributedString *tag = [[NSMutableAttributedString alloc] initWithString:@"\nTag: " attributes:boldAttri];
        [tag appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)view.tag] attributes:attri]];
        [attribute appendAttributedString:tag];
    }
    
    self.contentLabel.attributedText = attribute;
    
    [self.contentLabel sizeToFit];
    
    [self updateHeightIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.actionContentView.frame = CGRectMake(0, self.LL_height - self.actionContentViewHeight - kLLGeneralMargin, self.LL_width, self.actionContentViewHeight);
    
    self.parentViewsButton.frame = CGRectMake(kLLGeneralMargin, 0, self.actionContentView.LL_width / 2.0 - kLLGeneralMargin * 1.5, (self.actionContentView.LL_height - kLLGeneralMargin) / 2.0);
    
    self.subviewsButton.frame = CGRectMake(self.actionContentView.LL_width / 2.0 + kLLGeneralMargin * 0.5, self.parentViewsButton.LL_top, self.parentViewsButton.LL_width, self.parentViewsButton.LL_height);
    
    self.moreButton.frame = CGRectMake(kLLGeneralMargin, self.parentViewsButton.LL_bottom + kLLGeneralMargin, self.actionContentView.LL_width - kLLGeneralMargin * 2, self.parentViewsButton.LL_height);
    
    self.contentLabel.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin, self.actionContentView.LL_y - kLLGeneralMargin - kLLGeneralMargin);
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.actionContentViewHeight = 80;
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.actionContentView];
    [self.actionContentView addSubview:self.parentViewsButton];
    [self.actionContentView addSubview:self.subviewsButton];
    [self.actionContentView addSubview:self.moreButton];
    
    [self updateHeightIfNeeded];
}

#pragma mark - Event responses
- (void)buttonClicked:(UIButton *)sender {
    [self.delegate LLHierarchyInfoView:self didSelectAt:sender.tag];
}

#pragma mark - Primary
- (void)updateHeightIfNeeded {
    CGFloat height = kLLGeneralMargin + MAX(self.contentLabel.LL_height, self.closeButton.LL_height) + kLLGeneralMargin + self.actionContentViewHeight + kLLGeneralMargin;
    if (height != self.LL_height) {
        self.LL_height = height;
        if (!self.isMoved) {
            if (self.LL_bottom != LL_SCREEN_HEIGHT - kLLGeneralMargin * 2) {
                self.LL_bottom = LL_SCREEN_HEIGHT - kLLGeneralMargin * 2;
            }
        }
    }
}

#pragma mark - Getters and setters
- (void)setDelegate:(id<LLHierarchyInfoViewDelegate>)delegate {
    [super setDelegate:delegate];
}

- (id<LLHierarchyInfoViewDelegate>)delegate {
    return (id<LLHierarchyInfoViewDelegate>)[super delegate];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

- (UIView *)actionContentView {
    if (!_actionContentView) {
        _actionContentView = [LLFactory getView];
    }
    return _actionContentView;
}

- (UIButton *)parentViewsButton {
    if (!_parentViewsButton) {
        _parentViewsButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(buttonClicked:)];
        [_parentViewsButton setTitle:@"Parent Views" forState:UIControlStateNormal];
        [_parentViewsButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        _parentViewsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _parentViewsButton.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_parentViewsButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
        [_parentViewsButton LL_setCornerRadius:5];
        _parentViewsButton.tintColor = [LLThemeManager shared].primaryColor;
        _parentViewsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kLLGeneralMargin);
        [_parentViewsButton setImage:[[UIImage LL_imageNamed:kParentImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _parentViewsButton.tag = LLHierarchyInfoViewActionShowParent;
        _parentViewsButton.enabled = NO;
    }
    return _parentViewsButton;
}

- (UIButton *)subviewsButton {
    if (!_subviewsButton) {
        _subviewsButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(buttonClicked:)];
        [_subviewsButton setTitle:@"Subviews" forState:UIControlStateNormal];
        [_subviewsButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        _subviewsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _subviewsButton.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_subviewsButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
        [_subviewsButton LL_setCornerRadius:5];
        _subviewsButton.tintColor = [LLThemeManager shared].primaryColor;
        _subviewsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kLLGeneralMargin);
        [_subviewsButton setImage:[[UIImage LL_imageNamed:kSubviewImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _subviewsButton.tag = LLHierarchyInfoViewActionShowSubview;
        _subviewsButton.enabled = NO;
    }
    return _subviewsButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(buttonClicked:)];
        [_moreButton setTitle:@"More Info" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _moreButton.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_moreButton LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
        [_moreButton LL_setCornerRadius:5];
        _moreButton.tintColor = [LLThemeManager shared].primaryColor;
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kLLGeneralMargin);
        [_moreButton setImage:[[UIImage LL_imageNamed:kInfoImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _moreButton.tag = LLHierarchyInfoViewActionShowMoreInfo;
        _moreButton.enabled = NO;
    }
    return _moreButton;
}

@end
