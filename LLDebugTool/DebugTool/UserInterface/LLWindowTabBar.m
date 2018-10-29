//
//  LLWindowTabBar.m
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

#import "LLWindowTabBar.h"
#import "LLMacros.h"
#import "UIImage+LL_Utils.h"
#import "LLConfig.h"

@interface LLWindowTabBar ()

@property (nonatomic , assign) NSInteger maxCount;

@property (nonatomic , strong) UIButton *leftButton;

@property (nonatomic , strong) UIButton *rightButton;

@property (nonatomic , assign) NSInteger currentOffset;

@property (nonatomic , assign) CGFloat gap;

@property (nonatomic , assign) CGFloat leftSpacing;

@property (nonatomic , assign) CGFloat directionButtonWidth;

@property (nonatomic , assign) CGFloat tabBarButtonWidth;

@end

@implementation LLWindowTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Determine if you need to calculate frame.
    if (self.items.count > self.maxCount) {
        [self calculateSubviews];
        [self updateLeftAndRightButtonStatus];
    }
}

#pragma mark - Public
- (void)calculateSubviewsIfNeeded {
    if (self.items.count > self.maxCount) {
        if (self.currentOffset != [self offsetCount]) {
            [self calculateSubviews];
        }
        [self updateLeftAndRightButtonStatus];
    }
}

#pragma mark - Primary
- (void)initial {
    // Define parameter values.
    self.maxCount = 5;
    self.currentOffset = -1;
    self.gap = 4;
    self.directionButtonWidth = 15;
    self.leftSpacing = self.gap / 2.0 + self.directionButtonWidth;
    self.tintColor = LLCONFIG_TEXT_COLOR;
    self.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}

- (void)calculateSubviews {
    // Calculate UITabBarButton width.
    self.tabBarButtonWidth = (LL_SCREEN_WIDTH - self.directionButtonWidth * 2) / self.maxCount - self.gap;
    
    // Get all UITabBarButtons.
    NSMutableArray <UIView *>*tabBarButtons = [[NSMutableArray alloc] init];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:view];
        }
    }
    
    // Calculate Left/Right button frame.
    self.leftButton.frame = CGRectMake(self.gap / 2, tabBarButtons[0].frame.origin.y, self.directionButtonWidth, tabBarButtons[0].frame.size.height);
    self.rightButton.frame = CGRectMake(LL_SCREEN_WIDTH - self.gap / 2 - self.directionButtonWidth, tabBarButtons[0].frame.origin.y, self.directionButtonWidth, tabBarButtons[0].frame.size.height);
    
    // Reply to last frames.
    [self updateTabBarButtons:tabBarButtons animated:NO];
    
    // Record current offset.
    self.currentOffset = [self offsetCount];
    
    // Calculate new frames.
    [self updateTabBarButtons:tabBarButtons animated:YES];
    
    // Bring Left/Right button to front.
    [self bringSubviewToFront:self.leftButton];
    [self bringSubviewToFront:self.rightButton];
}

- (void)updateTabBarButtons:(NSArray *)tabBarButtons animated:(BOOL)animated {
    for (int i = 0; i < tabBarButtons.count; i++) {
        UIView *tabBarButton = tabBarButtons[i];
        NSInteger offset = i - self.currentOffset;
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                [self updateTabBarButton:tabBarButton offset:offset];
            }];
        } else {
            [self updateTabBarButton:tabBarButton offset:offset];
        }
    }
}

- (void)updateTabBarButton:(UIView *)tabBarButton offset:(NSInteger)offset {
    if (offset >= 0 && offset < self.maxCount) {
        // If displayed, calculate frame.
        tabBarButton.frame = CGRectMake(self.leftSpacing + (self.tabBarButtonWidth + self.gap) * offset, tabBarButton.frame.origin.y, self.tabBarButtonWidth, tabBarButton.frame.size.height);
    } else if (offset < 0) {
        // If don't displayed, Out of the screen.
        tabBarButton.frame = CGRectMake(-self.tabBarButtonWidth, tabBarButton.frame.origin.y, self.tabBarButtonWidth, tabBarButton.frame.size.height);
    } else {
        // If don't displayed, Out of the screen.
        tabBarButton.frame = CGRectMake(LL_SCREEN_WIDTH, tabBarButton.frame.origin.y, self.tabBarButtonWidth, tabBarButton.frame.size.height);
    }
}

- (void)updateLeftAndRightButtonStatus {
    // Get Left/Right button status.
    BOOL needShowLeftButton = [self needShowLeftButton];
    BOOL needShowRightButton = [self needShowRightButton];
    
    // Update the display status of the Left/Right button
    self.leftButton.enabled = needShowLeftButton;
    self.rightButton.enabled = needShowRightButton;
}

- (NSInteger)offsetCount {
    NSInteger count = floor(self.maxCount / 2.0);
    NSInteger selectedIndex = [self selectedIndex];
    if (selectedIndex <= count) {
        return 0;
    }
    if (selectedIndex < self.items.count - count) {
        return selectedIndex - count;
    }
    return self.items.count - self.maxCount;
}

- (NSInteger)selectedIndex {
    return [self.items indexOfObject:self.selectedItem];
}

- (BOOL)needShowLeftButton {
    NSInteger selectedIndex = [self selectedIndex];
    return selectedIndex > 0;
}

- (BOOL)needShowRightButton {
    NSInteger selectedIndex = [self selectedIndex];
    return selectedIndex < self.items.count - 1;
}

#pragma mark - Actions
- (void)leftButtonTouchUpInside:(UIButton *)sender {
    [self.actionDelegate LLWindowTabBar:self didSelectPreviousItem:self.leftButton];
}

- (void)rightButtonTouchUpInside:(UIButton *)sender {
    [self.actionDelegate LLWindowTabBar:self didSelectNextItem:self.rightButton];
}

#pragma mark - Lazy
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[[UIImage LL_imageNamed:@"LL-left" size:CGSizeMake(self.directionButtonWidth, self.directionButtonWidth)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[[UIImage LL_imageNamed:@"LL-right" size:CGSizeMake(self.directionButtonWidth, self.directionButtonWidth)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
