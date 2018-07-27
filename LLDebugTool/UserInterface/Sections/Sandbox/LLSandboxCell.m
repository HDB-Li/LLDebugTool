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
#import "LLTool.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"

@interface LLSandboxCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (strong , nonatomic) LLSandboxModel *model;

@end

@implementation LLSandboxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (void)confirmWithModel:(LLSandboxModel *)model {
    _model = model;
    self.icon.image = [UIImage LL_imageNamed:model.iconName];
    self.titleLabel.text = model.name;
    self.contentLabel.text = [NSString stringWithFormat:@"%@",[[LLTool sharedTool] stringFromDate:model.modifiDate]];
    self.sizeLabel.text = [NSString stringWithFormat:@"Size:%@",model.totalFileSizeString];
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
    if (LLCONFIG_CUSTOM_COLOR) {
        if ([model.iconName isEqualToString:kFolderImageName] || [model.iconName isEqualToString:kEmptyFolderImageName]) {
            self.icon.image = [[UIImage LL_imageNamed:model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    if (state == UITableViewCellStateShowingEditControlMask) {
        self.sizeLabel.hidden = NO;
    } else {
        self.sizeLabel.hidden = YES;
    }
}

#pragma mark - Primary
- (void)initial {
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.sizeLabel.hidden = YES;
    UILongPressGestureRecognizer *longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [self.contentView addGestureRecognizer:longPG];
    
    if (LLCONFIG_CUSTOM_COLOR) {
        self.icon.tintColor = LLCONFIG_TEXT_COLOR;
    }
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(LL_tableViewCellDidLongPress:)]) {
            [_delegate LL_tableViewCellDidLongPress:self];
        }
    }
}

@end
