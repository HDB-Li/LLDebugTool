//
//  LLHierarchyInfoWindow.m
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

#import "LLHierarchyInfoWindow.h"
#import "LLWindowManager.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLConfig.h"
#import "LLTool.h"
#import "LLMacros.h"
#import "UIColor+LL_Utils.h"

@interface LLHierarchyInfoWindow ()

@property (nonatomic, weak) UIView *selectedView;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LLHierarchyInfoWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)updateView:(UIView *)view {
    
    if (self.selectedView == view) {
        return;
    }
    
    self.selectedView = view;
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    NSString *name = [NSString stringWithFormat:@"Name: %@",NSStringFromClass(view.class)];
    [attributes addObject:name];
    
    NSString *frame = [NSString stringWithFormat:@"Frame: %@",[LLTool stringFromFrame:view.frame]];
    [attributes addObject:frame];
    
    NSMutableString *color = [NSMutableString string];
    
    if (view.backgroundColor) {
        [color appendFormat:@"Background: %@",[view.backgroundColor LL_description]];
    }
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        [color appendFormat:@", Color: %@, Font: %0.2f", [label.textColor LL_description], label.font.pointSize];
    }
    if ([color length]) {
        [attributes addObject:color];
    }
    
    if (view.tag != 0) {
        NSString *tag = [NSString stringWithFormat:@"Tag: %ld", (long)view.tag];
        [attributes addObject:tag];
    }
    
    self.contentLabel.text = [attributes componentsJoinedByString:@"\n"];
    [self.contentLabel sizeToFit];
    
    CGFloat height = self.contentLabel.LL_height + 10 * 2;
    if (height != self.LL_height) {
        self.LL_height = height;
        if (!self.isMoved) {
            if (self.LL_bottom != LL_SCREEN_HEIGHT - 10 * 2) {
                self.LL_bottom = LL_SCREEN_HEIGHT - 10 * 2;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat gap = 10;
    CGRect contentRect = CGRectMake(gap, gap, self.closeButton.LL_x - gap - gap, self.LL_height - gap * 2);
    if (!CGRectEqualToRect(self.contentLabel.frame, contentRect)) {
        self.contentLabel.frame = contentRect;
    }
}

- (void)componentDidFinish {
    [[LLWindowManager shared] hideWindow:self animated:YES];
    [[LLWindowManager shared] hideWindow:[LLWindowManager shared].hierarchyPickerWindow animated:YES];
    [[LLWindowManager shared] showWindow:[LLWindowManager shared].suspensionWindow animated:YES];
    [[LLWindowManager shared] reloadHierarchyPickerWindow];
}

#pragma mark - Primary
- (void)initial {
    self.contentLabel = [LLFactory getLabel:self frame:CGRectZero text:nil font:14 textColor:[LLConfig sharedConfig].textColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

@end
