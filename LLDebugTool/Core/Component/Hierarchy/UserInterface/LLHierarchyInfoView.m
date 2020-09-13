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

#import "LLConst.h"
#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLFactory.h"
#import "LLFormatterTool.h"
#import "LLHierarchyHelper.h"
#import "LLHierarchyInfoSwitchModel.h"
#import "LLHierarchyInfoSwitchView.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLToastUtils.h"
#import "LLTool.h"

#import "NSObject+LL_Hierarchy.h"
#import "UIColor+LL_Utils.h"
#import "UIView+LL_Hierarchy.h"
#import "UIView+LL_Utils.h"

@interface LLHierarchyInfoView ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *frameLabel;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *backgroundColorLabel;

@property (nonatomic, strong) UILabel *textColorLabel;

@property (nonatomic, strong) UILabel *alphaLabel;

@property (nonatomic, strong) UILabel *fontLabel;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) LLHierarchyInfoSwitchView *lockView;

@property (nonatomic, strong) UIView *actionContentView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIButton *parentViewsButton;

@property (nonatomic, strong) UIButton *subviewsButton;

@property (nonatomic, strong) UIButton *levelButton;

@property (nonatomic, assign) CGFloat actionContentViewHeight;

@end

@implementation LLHierarchyInfoView

@dynamic delegate;

#pragma mark - Public
- (void)reloadData {
    [self updateUI];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    self.actionContentViewHeight = 80;

    [self addSubview:self.contentLabel];
    [self addSubview:self.frameLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.backgroundColorLabel];
    [self addSubview:self.textColorLabel];
    [self addSubview:self.alphaLabel];
    [self addSubview:self.fontLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.lockView];
    [self addSubview:self.actionContentView];
    [self.actionContentView addSubview:self.levelButton];
    [self.actionContentView addSubview:self.moreButton];
    [self.actionContentView addSubview:self.parentViewsButton];
    [self.actionContentView addSubview:self.subviewsButton];

    [self updateHeightIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.actionContentView.frame = CGRectMake(0, self.LL_height - self.actionContentViewHeight - kLLGeneralMargin, self.LL_width, self.actionContentViewHeight);

    self.levelButton.frame = CGRectMake(kLLGeneralMargin, 0, self.actionContentView.LL_width / 2.0 - kLLGeneralMargin * 1.5, (self.actionContentView.LL_height - kLLGeneralMargin) / 2.0);

    self.moreButton.frame = CGRectMake(self.actionContentView.LL_width / 2.0 + kLLGeneralMargin * 0.5, self.levelButton.LL_top, self.levelButton.LL_width, self.levelButton.LL_height);

    self.parentViewsButton.frame = CGRectMake(kLLGeneralMargin, self.levelButton.LL_bottom + kLLGeneralMargin, self.levelButton.LL_width, self.levelButton.LL_height);

    self.subviewsButton.frame = CGRectMake(self.moreButton.LL_left, self.parentViewsButton.LL_top, self.levelButton.LL_width, self.levelButton.LL_height);

    self.contentLabel.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, self.closeButton.LL_x - kLLGeneralMargin - kLLGeneralMargin, self.contentLabel.LL_height);

    self.frameLabel.frame = CGRectMake(self.contentLabel.LL_x, self.contentLabel.LL_bottom, self.contentLabel.LL_width, self.frameLabel.LL_height);

    self.textLabel.frame = CGRectMake(self.contentLabel.LL_x, self.frameLabel.LL_bottom, self.contentLabel.LL_width, self.textLabel.LL_height);

    self.backgroundColorLabel.frame = CGRectMake(self.contentLabel.LL_x, self.textLabel.LL_bottom, self.contentLabel.LL_width, self.backgroundColorLabel.LL_height);

    self.textColorLabel.frame = CGRectMake(self.contentLabel.LL_x, self.backgroundColorLabel.LL_bottom, self.contentLabel.LL_width, self.textColorLabel.LL_height);

    self.alphaLabel.frame = CGRectMake(self.contentLabel.LL_x, self.textColorLabel.LL_bottom, self.contentLabel.LL_width, self.alphaLabel.LL_height);

    self.fontLabel.frame = CGRectMake(self.contentLabel.LL_x, self.alphaLabel.LL_bottom, self.contentLabel.LL_width, self.fontLabel.LL_height);

    self.tagLabel.frame = CGRectMake(self.contentLabel.LL_x, self.fontLabel.LL_bottom, self.contentLabel.LL_width, self.tagLabel.LL_height);

    self.lockView.frame = CGRectMake(self.contentLabel.LL_x, self.tagLabel.LL_bottom, self.LL_width - kLLGeneralMargin - kLLGeneralMargin, self.lockView.LL_height);
}

#pragma mark - Event responses
- (void)buttonClicked:(UIButton *)sender {
    [self.delegate LLHierarchyInfoView:self didSelectAt:sender.tag];
}

- (void)frameLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
}

- (void)textLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showTextAlertAndAutomicSetWithKeyPath:@"text"];
}

- (void)backgroundColorLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
}

- (void)textColorLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showColorAlertAndAutomicSetWithKeyPath:@"textColor"];
}

- (void)alphaLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showDoubleAlertAndAutomicSetWithKeyPath:@"alpha"];
}

- (void)fontLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showFontAlertAndAutomicSetWithKeyPath:@"font"];
}

- (void)tagLabelTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [[self.dataSource displayViewInLLHierarchyInfoView:self] LL_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
}

#pragma mark - Primary
- (void)updateUI {
    if ([self.dataSource respondsToSelector:@selector(LLHierarchyInfoView:canClickAtAction:)]) {
        self.levelButton.enabled = [self.dataSource LLHierarchyInfoView:self canClickAtAction:LLHierarchyInfoViewActionShowLevel];
        self.moreButton.enabled = [self.dataSource LLHierarchyInfoView:self canClickAtAction:LLHierarchyInfoViewActionShowMoreInfo];
        self.parentViewsButton.enabled = [self.dataSource LLHierarchyInfoView:self canClickAtAction:LLHierarchyInfoViewActionShowParent];
        self.subviewsButton.enabled = [self.dataSource LLHierarchyInfoView:self canClickAtAction:LLHierarchyInfoViewActionShowSubview];
    } else {
        self.levelButton.enabled = NO;
        self.moreButton.enabled = NO;
        self.parentViewsButton.enabled = NO;
        self.subviewsButton.enabled = NO;
    }

    [self updateSelectedViewAttributeInfos];

    [self.contentLabel sizeToFit];
    [self.frameLabel sizeToFit];
    [self.textLabel sizeToFit];
    [self.backgroundColorLabel sizeToFit];
    [self.textColorLabel sizeToFit];
    [self.alphaLabel sizeToFit];
    [self.fontLabel sizeToFit];
    [self.tagLabel sizeToFit];

    [self updateHeightIfNeeded];
}

- (void)updateSelectedViewAttributeInfos {
    UIView *view = [self.dataSource displayViewInLLHierarchyInfoView:self];
    if (!view) {
        self.contentLabel.attributedText = nil;
        self.frameLabel.attributedText = nil;
        self.backgroundColorLabel.attributedText = nil;
        self.textLabel.attributedText = nil;
        self.textColorLabel.attributedText = nil;
        self.alphaLabel.attributedText = nil;
        self.fontLabel.attributedText = nil;
        self.tagLabel.attributedText = nil;
        self.lockView.hidden = YES;
        self.lockView.model.enable = NO;
        return;
    }

    self.contentLabel.attributedText = [self attributedStringWithText:@"Name\t: " detail:NSStringFromClass(view.class)];

    self.frameLabel.attributedText = [self attributedStringWithText:@"Frame\t: " detail:[LLTool stringFromFrame:view.frame]];

    if (view.backgroundColor) {
        self.backgroundColorLabel.attributedText = [self attributedStringWithText:@"Background : " detail:view.backgroundColor.LL_description];
    } else {
        self.backgroundColorLabel.attributedText = nil;
    }

    if ([LLDT_CC_Hierarchy hasTextPropertyInClass:view.class]) {
        self.textLabel.attributedText = [self attributedStringWithText:@"Text\t: " detail:[view valueForKey:@"text"]];
    } else {
        self.textLabel.attributedText = nil;
    }

    if ([LLDT_CC_Hierarchy hasTextColorPropertyInClass:view.class]) {
        UIColor *textColor = [view valueForKey:@"textColor"];
        self.textColorLabel.attributedText = [self attributedStringWithText:@"Text Color : " detail:textColor.LL_description];
    } else {
        self.textColorLabel.attributedText = nil;
    }

    CGFloat alpha = [[view valueForKey:@"alpha"] floatValue];
    if (alpha < 1) {
        self.alphaLabel.attributedText = [self attributedStringWithText:@"Alpha\t: " detail:[LLFormatterTool formatNumber:@(alpha)]];
    } else {
        self.alphaLabel.attributedText = nil;
    }

    if ([LLDT_CC_Hierarchy hasFontPropertyInClass:view.class]) {
        UIFont *font = [view valueForKey:@"font"];
        self.fontLabel.attributedText = [self attributedStringWithText:@"Font\t: " detail:[LLFormatterTool formatNumber:@(font.pointSize)]];
    } else {
        self.fontLabel.attributedText = nil;
    }

    if (view.tag) {
        self.tagLabel.attributedText = [self attributedStringWithText:@"Tag\t: " detail:[NSString stringWithFormat:@"%ld", (long)view.tag]];
    } else {
        self.tagLabel.attributedText = nil;
    }

    self.lockView.hidden = NO;
    self.lockView.model.enable = YES;
    self.lockView.model.on = view.LL_lock;
}

- (void)updateHeightIfNeeded {
    CGFloat contentHeight = self.contentLabel.LL_height + self.frameLabel.LL_height + self.textLabel.LL_height + self.backgroundColorLabel.LL_height + self.textColorLabel.LL_height + self.alphaLabel.LL_height + self.fontLabel.LL_height + self.tagLabel.LL_height + self.lockView.LL_height;
    CGFloat height = kLLGeneralMargin + LL_MAX(contentHeight, self.closeButton.LL_height) + kLLGeneralMargin + self.actionContentViewHeight + kLLGeneralMargin;
    if (height != self.LL_height) {
        self.LL_height = height;
        if (!self.isMoved) {
            if (self.LL_bottom != LL_SCREEN_HEIGHT - kLLGeneralMargin * 2) {
                self.LL_bottom = LL_SCREEN_HEIGHT - kLLGeneralMargin * 2;
            }
        }
    }
}

- (void)lockButtonValueChanged:(BOOL)isLock {
    UIView *view = [self.dataSource displayViewInLLHierarchyInfoView:self];
    if (!view) {
        return;
    }
    view.LL_lock = isLock;
    if (isLock) {
        [LLDT_CC_Hierarchy.lockViews addObject:view];
    } else {
        [LLDT_CC_Hierarchy.lockViews removeObject:view];
    }
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text detail:(NSString *)detail {
    NSDictionary *boldAttri = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    NSDictionary *attri = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:boldAttri];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:detail attributes:attri]];

    return [str copy];
}

- (UIButton *)actionButtonWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag {
    UIButton *button = [LLFactory getButton:nil frame:CGRectZero target:self action:@selector(buttonClicked:)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tintColor = [LLThemeManager shared].primaryColor;
    [button setTitleColor:[LLThemeManager shared].primaryColor forState:UIControlStateNormal];
    button.backgroundColor = [LLThemeManager shared].backgroundColor;
    [button LL_setBorderColor:[LLThemeManager shared].primaryColor borderWidth:1];
    [button LL_setCornerRadius:5];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kLLGeneralMargin);
    [button setImage:[[UIImage LL_imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    button.tag = tag;
    button.enabled = NO;
    return button;
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

- (UILabel *)frameLabel {
    if (!_frameLabel) {
        _frameLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _frameLabel.numberOfLines = 0;
        _frameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_frameLabel LL_addClickListener:self action:@selector(frameLabelTapGestureRecognizer:)];
    }
    return _frameLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_textLabel LL_addClickListener:self action:@selector(textLabelTapGestureRecognizer:)];
    }
    return _textLabel;
}

- (UILabel *)backgroundColorLabel {
    if (!_backgroundColorLabel) {
        _backgroundColorLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _backgroundColorLabel.numberOfLines = 0;
        _backgroundColorLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_backgroundColorLabel LL_addClickListener:self action:@selector(backgroundColorLabelTapGestureRecognizer:)];
    }
    return _backgroundColorLabel;
}

- (UILabel *)textColorLabel {
    if (!_textColorLabel) {
        _textColorLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _textColorLabel.numberOfLines = 0;
        _textColorLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_textColorLabel LL_addClickListener:self action:@selector(textColorLabelTapGestureRecognizer:)];
    }
    return _textColorLabel;
}

- (UILabel *)alphaLabel {
    if (!_alphaLabel) {
        _alphaLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _alphaLabel.numberOfLines = 0;
        _alphaLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_alphaLabel LL_addClickListener:self action:@selector(alphaLabelTapGestureRecognizer:)];
    }
    return _alphaLabel;
}

- (UILabel *)fontLabel {
    if (!_fontLabel) {
        _fontLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _fontLabel.numberOfLines = 0;
        _fontLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_fontLabel LL_addClickListener:self action:@selector(fontLabelTapGestureRecognizer:)];
    }
    return _fontLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [LLFactory getLabel:nil frame:CGRectZero text:nil font:14 textColor:[LLThemeManager shared].primaryColor];
        _tagLabel.numberOfLines = 0;
        _tagLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_tagLabel LL_addClickListener:self action:@selector(tagLabelTapGestureRecognizer:)];
    }
    return _tagLabel;
}

- (LLHierarchyInfoSwitchView *)lockView {
    if (!_lockView) {
        _lockView = [[LLHierarchyInfoSwitchView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        LLHierarchyInfoSwitchModel *model = [LLHierarchyInfoSwitchModel modelWithTitle:[self attributedStringWithText:@"Lock\t: " detail:@"Frame/Center/Alpha/Hidden"]
                                                                                    on:NO
                                                                                 block:^(BOOL isOn) {
                                                                                     [weakSelf lockButtonValueChanged:isOn];
                                                                                 }];
        _lockView.model = model;
        _lockView.hidden = YES;
    }
    return _lockView;
}

- (UIView *)actionContentView {
    if (!_actionContentView) {
        _actionContentView = [LLFactory getView];
    }
    return _actionContentView;
}

- (UIButton *)parentViewsButton {
    if (!_parentViewsButton) {
        _parentViewsButton = [self actionButtonWithTitle:LLLocalizedString(@"hierarchy.parent") imageName:kParentImageName tag:LLHierarchyInfoViewActionShowParent];
    }
    return _parentViewsButton;
}

- (UIButton *)subviewsButton {
    if (!_subviewsButton) {
        _subviewsButton = [self actionButtonWithTitle:LLLocalizedString(@"hierarchy.subview") imageName:kSubviewImageName tag:LLHierarchyInfoViewActionShowSubview];
    }
    return _subviewsButton;
}

- (UIButton *)levelButton {
    if (!_levelButton) {
        _levelButton = [self actionButtonWithTitle:LLLocalizedString(@"hierarchy.level") imageName:kLevelImageName tag:LLHierarchyInfoViewActionShowLevel];
    }
    return _levelButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [self actionButtonWithTitle:LLLocalizedString(@"hierarchy.more") imageName:kInfoImageName tag:LLHierarchyInfoViewActionShowMoreInfo];
    }
    return _moreButton;
}

@end
