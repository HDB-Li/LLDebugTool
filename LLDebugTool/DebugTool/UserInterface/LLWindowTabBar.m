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

@interface LLWindowTabBar () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger maxCount;

@property (nonatomic , strong) UIButton *leftButton;

@property (nonatomic , strong) UIButton *rightButton;

@property (nonatomic , strong) UIScrollView *scrollView;

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
    [self addSubview:self.scrollView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}

- (void)calculateSubviews {
    
    // Update scrollView frame.
    self.scrollView.frame = CGRectMake(self.directionButtonWidth + self.gap, 0, LL_SCREEN_WIDTH - (self.directionButtonWidth + self.gap) * 2, self.bounds.size.height);
    
    // Calculate UITabBarButton width.
    self.tabBarButtonWidth = self.scrollView.frame.size.width / self.maxCount - self.gap;

    // Update scrollView contentSize.
    self.scrollView.contentSize = CGSizeMake((self.tabBarButtonWidth + self.gap) * self.items.count, 0);
    
    // Get all UITabBarButtons.
    NSMutableArray <UIView *>*tabBarButtons = [[NSMutableArray alloc] init];
    if (self.scrollView.subviews.count == 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtons addObject:view];
            }
        }
        for (UIView *view in tabBarButtons) {
            [view removeFromSuperview];
            [self.scrollView addSubview:view];
        }
    } else {
        for (UIView *view in self.scrollView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtons addObject:view];
            }
        }
    }
    
    // Calculate Left/Right button frame.
    self.leftButton.frame = CGRectMake(self.gap / 2, tabBarButtons[0].frame.origin.y, self.directionButtonWidth, tabBarButtons[0].frame.size.height);
    self.rightButton.frame = CGRectMake(LL_SCREEN_WIDTH - self.gap / 2 - self.directionButtonWidth, tabBarButtons[0].frame.origin.y, self.directionButtonWidth, tabBarButtons[0].frame.size.height);
    
    
    for (int i = 0; i < tabBarButtons.count; i++) {
        UIView *tabBarButton = tabBarButtons[i];
        tabBarButton.frame = CGRectMake(self.gap / 2 + (self.tabBarButtonWidth + self.gap) * i, tabBarButton.frame.origin.y, self.tabBarButtonWidth, tabBarButton.frame.size.height);
    }
    
    // Record current offset.
    self.currentOffset = [self offsetCount];
    
    // Update scrollView content offset animated.
    [self.scrollView setContentOffset:CGPointMake((self.tabBarButtonWidth + self.gap) * self.currentOffset, 0) animated:YES];
    
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

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = self.tabBarButtonWidth + self.gap;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint newPoint = [self nearestTargetOffsetForOffset:*targetContentOffset];
    *targetContentOffset = newPoint;
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
