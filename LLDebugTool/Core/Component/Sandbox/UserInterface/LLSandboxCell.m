//
//  LLSandboxCell.m
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

#import "LLSandboxCell.h"
#import "LLFormatterTool.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLMacros.h"
#import "LLConst.h"
#import "Masonry.h"

@interface LLSandboxCell ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (strong, nonatomic) LLSandboxModel *model;

@end

@implementation LLSandboxCell

- (void)confirmWithModel:(LLSandboxModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [LLFormatterTool stringFromDate:model.modifiDate style:FormatterToolDateStyle1]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@",model.totalFileSizeString];
    if (model.isDirectory && model.subModels.count) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    if (model.isHidden) {
        self.contentView.alpha = 0.6;
    } else {
        self.contentView.alpha = 1.0;
    }
    if ([model.iconName isEqualToString:kFolderImageName] || [model.iconName isEqualToString:kEmptyFolderImageName]) {
        self.icon.image = [[UIImage LL_imageNamed:model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        self.icon.image = [UIImage LL_imageNamed:model.iconName];
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [self.contentView addGestureRecognizer:longPG];
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.sizeLabel];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(kLLGeneralMargin);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(kLLGeneralMargin);
        make.top.mas_equalTo(kLLGeneralMargin);
        make.right.mas_equalTo(-kLLGeneralMargin / 2.0);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.sizeLabel.mas_bottom);
        make.bottom.mas_equalTo(-kLLGeneralMargin).priorityHigh();
    }];
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(LL_tableViewCellDidLongPress:)]) {
            [_delegate LL_tableViewCellDidLongPress:self];
        }
    }
}

#pragma mark - Getters and setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [LLFactory getLabel];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _nameLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [LLFactory getImageView];
        _icon.tintColor = [LLThemeManager shared].primaryColor;
    }
    return _icon;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [LLFactory getLabel];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sizeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [LLFactory getLabel];
        _dateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateLabel;
}

@end
