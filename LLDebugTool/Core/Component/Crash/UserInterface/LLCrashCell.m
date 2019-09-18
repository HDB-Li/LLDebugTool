//
//  LLCrashCell.m
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

#import "LLCrashCell.h"
#import "LLConfig.h"
#import "LLFactory.h"
#import "LLConst.h"
#import "Masonry.h"

@interface LLCrashCell ()

@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) LLCrashModel *model;

@end

@implementation LLCrashCell

- (void)confirmWithModel:(LLCrashModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    _reasonLabel.text = model.reason;
    _dateLabel.text = [NSString stringWithFormat:@"[ %@ ]",model.date];
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.contentView addSubview:self.reasonLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLLGeneralMargin);
        make.left.mas_equalTo(kLLGeneralMargin);
        make.right.mas_equalTo(-kLLGeneralMargin);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.reasonLabel);
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.reasonLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kLLGeneralMargin / 2.0);
        make.bottom.mas_equalTo(-kLLGeneralMargin).priorityHigh();
    }];
}

#pragma mark - Getters and setters
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [LLFactory getLabel];
        _reasonLabel.font = [UIFont boldSystemFontOfSize:17];
        _reasonLabel.numberOfLines = 0;
        _reasonLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _reasonLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [LLFactory getLabel];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [LLFactory getLabel];
        _dateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _dateLabel;
}

@end
