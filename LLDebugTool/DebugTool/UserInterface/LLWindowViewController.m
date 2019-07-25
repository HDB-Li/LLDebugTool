//
//  LLWindowViewController.m
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

#import "LLWindowViewController.h"
#import "LLScreenshotHelper.h"
#import "LLAppInfoHelper.h"
#import "LLHierarchyHelper.h"
#import "LLMacros.h"
#import "LLDebugToolMacros.h"
#import "LLLogHelperEventDefine.h"
#import "LLTool.h"
#import "LLHierarchyExplorerToolBar.h"
#import "LLFunctionViewController.h"
#import "LLBaseNavigationController.h"
#import "LLFactory.h"

typedef NS_ENUM(NSUInteger, LLWindowViewControllerMode) {
    LLWindowViewControllerModeDefault,
    LLWindowViewControllerModeSelect,
    LLWindowViewControllerModeMove,
};

@interface LLWindowViewController () <LLFunctionViewControllerDelegate, UIGestureRecognizerDelegate, LLHierarchyExplorerToolBarDelegate>

@property (nonatomic, strong) UIWindow *previousKeyWindow;

@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *memoryLabel;

@property (nonatomic, strong) UILabel *CPULabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat sBallHideWidth;

@property (nonatomic, strong) LLFunctionViewController *functionViewController;

@property (nonatomic, assign) LLConfigWindowStyle windowStyle;

@property (nonatomic, assign) CGFloat sBallWidth;

@property (nonatomic, assign, getter=isRegisterNotification) BOOL registerNotification;

@property (nonatomic, assign, getter=currentMode) LLWindowViewControllerMode mode;

@property (nonatomic, strong) UITapGestureRecognizer *selectTapGR;

@property (nonatomic, strong) UIPanGestureRecognizer *movePanGR;

@property (nonatomic, strong) NSDictionary<NSValue *, UIView *> *outlineViewsForVisibleViews;

@property (nonatomic, strong) NSArray<UIView *> *viewsAtTapPoint;

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) UIView *selectedViewOverlay;

@property (nonatomic, strong) NSMutableSet<UIView *> *observedViews;

@property (nonatomic, assign) CGRect selectedViewFrameBeforeDragging;

@property (nonatomic, strong) LLHierarchyExplorerToolBar *hierarchyToolBar;

@end

@implementation LLWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resignKeyWindow];
    [self registerLLAppInfoHelperNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterLLAppInfoHelperNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (UIView *view in self.observedViews) {
        [self stopObservingView:view];
    }
}

#pragma mark - Public
- (void)showExplorerView {
    self.contentView.hidden = NO;
    [self registerLLAppInfoHelperNotification];
}

- (void)hideExplorerView {
    self.contentView.hidden = YES;
    [self unregisterLLAppInfoHelperNotification];
}

- (void)reloadTabbar {
    _functionViewController = nil;
}

- (void)presentTabbarWithIndex:(NSInteger)index params:(NSDictionary <NSString *,id>*)params{
    if ([LLConfig sharedConfig].availables == LLConfigAvailableScreenshot) {
        // Screenshot only. Don't open the window.
        LLog_Event(kLLLogHelperDebugToolEvent, @"Current availables is only screenshot, can't open the tabbar.");
        return;
    }
    
    if (![LLConfig sharedConfig].XIBBundle) {
        LLog_Warning_Event(kLLLogHelperFailedLoadingResourceEvent, [@"Failed to load the XIB bundle," stringByAppendingString:kLLLogHelperOpenIssueInGithub]);
        return;
    }
    
    if (![LLConfig sharedConfig].imageBundle) {
        LLog_Warning_Event(kLLLogHelperFailedLoadingResourceEvent, [@"Failed to load the image bundle," stringByAppendingString:kLLLogHelperOpenIssueInGithub]);
    }
    
    [self makeKeyAndPresentTabbarControllerWithIndex:index params:params];
}

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates {
    BOOL shouldReceiveTouch = NO;
    
    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];
    
    if (CGRectContainsPoint(self.contentView.frame, pointInLocalCoordinates)) {
        shouldReceiveTouch = YES;
    }
    
    // Always if we're in selection mode
    if (!shouldReceiveTouch && self.currentMode == LLWindowViewControllerModeSelect) {
        shouldReceiveTouch = YES;
    }
    
    // Always in move mode too
    if (!shouldReceiveTouch && self.currentMode == LLWindowViewControllerModeMove) {
        shouldReceiveTouch = YES;
    }
    
    if (!shouldReceiveTouch && self.presentedViewController) {
        shouldReceiveTouch = YES;
    }
    return shouldReceiveTouch;
}

- (BOOL)wantsWindowToBecomeKey
{
    return self.previousKeyWindow != nil;
}

- (void)handleDownArrowKeyPressed
{
    if (self.currentMode == LLWindowViewControllerModeMove) {
        CGRect frame = self.selectedView.frame;
        frame.origin.y += 1.0 / [[UIScreen mainScreen] scale];
        self.selectedView.frame = frame;
    } else if (self.currentMode == LLWindowViewControllerModeSelect && [self.viewsAtTapPoint count] > 0) {
        NSInteger selectedViewIndex = [self.viewsAtTapPoint indexOfObject:self.selectedView];
        if (selectedViewIndex > 0) {
            self.selectedView = [self.viewsAtTapPoint objectAtIndex:selectedViewIndex - 1];
        }
    }
}

- (void)handleUpArrowKeyPressed
{
    if (self.currentMode == LLWindowViewControllerModeMove) {
        CGRect frame = self.selectedView.frame;
        frame.origin.y -= 1.0 / [[UIScreen mainScreen] scale];
        self.selectedView.frame = frame;
    } else if (self.currentMode == LLWindowViewControllerModeSelect && [self.viewsAtTapPoint count] > 0) {
        NSInteger selectedViewIndex = [self.viewsAtTapPoint indexOfObject:self.selectedView];
        if (selectedViewIndex < [self.viewsAtTapPoint count] - 1) {
            self.selectedView = [self.viewsAtTapPoint objectAtIndex:selectedViewIndex + 1];
        }
    }
}

- (void)handleRightArrowKeyPressed
{
    if (self.currentMode == LLWindowViewControllerModeMove) {
        CGRect frame = self.selectedView.frame;
        frame.origin.x += 1.0 / [[UIScreen mainScreen] scale];
        self.selectedView.frame = frame;
    }
}

- (void)handleLeftArrowKeyPressed
{
    if (self.currentMode == LLWindowViewControllerModeMove) {
        CGRect frame = self.selectedView.frame;
        frame.origin.x -= 1.0 / [[UIScreen mainScreen] scale];
        self.selectedView.frame = frame;
    }
}

#pragma mark - LLAppInfoHelperNotification
- (void)didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat cpu = [userInfo[LLAppInfoHelperCPUKey] floatValue];
    CGFloat usedMemory = [userInfo[LLAppInfoHelperMemoryUsedKey] floatValue];
    __unused CGFloat fps = [userInfo[LLAppInfoHelperFPSKey] floatValue];
    self.memoryLabel.text = [NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:usedMemory countStyle:NSByteCountFormatterCountStyleMemory]];
    self.CPULabel.text = [NSString stringWithFormat:@"CPU:%.2f%%",cpu];
}

#pragma mark - LLConfigDidUpdateColorStyleNotification
- (void)didReceiveLLConfigDidUpdateColorStyleNotification {
    _contentView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    _contentView.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
    _memoryLabel.textColor = LLCONFIG_TEXT_COLOR;
    _CPULabel.textColor = LLCONFIG_TEXT_COLOR;
    _lineView.backgroundColor = LLCONFIG_TEXT_COLOR;
}

#pragma mark - LLConfigDidUpdateWindowStyleNotificationName
- (void)didReceiveLLConfigDidUpdateWindowStyleNotification {
    self.windowStyle = [LLConfig sharedConfig].windowStyle;
    [self updateSettings];
    [self updateSubViews];
    [self updateGestureRecognizers];
}

#pragma mark - LLFunctionViewControllerDelegate
- (void)LLFunctionViewController:(LLFunctionViewController *)viewController didSelectedHierarchyModel:(LLHierarchyModel *)model {
    UIView *selectedView = model.view;
    if (![self.viewsAtTapPoint containsObject:selectedView]) {
        self.viewsAtTapPoint = nil;
        [self removeAndClearOutlineViews];
    }
    
    // If we now have a selected view and we didn't have one previously, go to "select" mode.
    if (self.currentMode == LLWindowViewControllerModeDefault && selectedView) {
        self.mode = LLWindowViewControllerModeSelect;
    }
    
    // The selected view setter will also update the selected view overlay appropriately.
    self.selectedView = selectedView;
    
    [self showHierarchyToolBar];
}

#pragma mark - LLHierarchyExplorerToolBarDelegate
- (void)LLHierarchyExplorerToolBar:(LLHierarchyExplorerToolBar *)toolBar handlePanOffset:(CGPoint)offset {
    CGFloat targetY = toolBar.frame.origin.y + offset.y;
    targetY = MIN(targetY, LL_SCREEN_HEIGHT - [self safeArea].bottom - toolBar.frame.size.height);
    targetY = MAX(0, targetY);
    self.hierarchyToolBar.frame = CGRectMake(toolBar.frame.origin.x, targetY, toolBar.frame.size.width, toolBar.frame.size.height);
}

- (void)LLHierarchyExplorerToolBar:(LLHierarchyExplorerToolBar *)toolBar didSelectIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            [self makeKeyAndPresentTabbarControllerWithIndex:5 params:self.selectedView ? @{@"selectView" : self.selectedView} : nil];
            [self hideHierarchyToolBar];
            self.mode = LLWindowViewControllerModeDefault;
        }
            break;
        case 1:{
            self.mode = LLWindowViewControllerModeSelect;
        }
            break;
        case 2:{
            self.mode = LLWindowViewControllerModeMove;
        }
            break;
        case 3:{
            [self hideHierarchyToolBar];
            self.mode = LLWindowViewControllerModeDefault;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.selectTapGR) {
        CGPoint tapPointInView = [touch locationInView:self.view];
        if (CGRectContainsPoint(_hierarchyToolBar.frame, tapPointInView)) {
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - Primary
/**
 * initial method
 */
- (void)initial {
    self.windowStyle = [LLConfig sharedConfig].windowStyle;
//    self.mode = LLWindowViewControllerModeSelect;
    [self updateSettings];
    [self updateSubViews];
    [self initGestureRecognizers];
    [self updateGestureRecognizers];
    [self registerNotifications];
}

- (void)updateSettings {
    // Check sBallWidth
    _sBallWidth = [LLConfig sharedConfig].suspensionBallWidth;
    if (_sBallWidth < 70) {
        _sBallWidth = 70;
    }
    self.sBallHideWidth = 10;
    switch (self.windowStyle) {
        case LLConfigWindowPowerBar:{
            CGFloat width = 90;
            CGRect rect = [UIApplication sharedApplication].statusBarFrame;
            CGFloat gap = 0.5;
            self.contentView.frame = CGRectMake(LL_SCREEN_WIDTH - width - 2, rect.origin.y + gap, width, rect.size.height - gap * 2 < 20 - gap * 2 ? 20 - gap * 2 : rect.size.height - gap * 2);
        }
            break;
        case LLConfigWindowNetBar:{
            CGFloat width = 90;
            CGRect rect = [UIApplication sharedApplication].statusBarFrame;
            CGFloat gap = 0.5;
            self.contentView.frame = CGRectMake(gap, rect.origin.y + gap, width, rect.size.height - gap * 2 < 20 - gap * 2 ? 20 - gap * 2 : rect.size.height - gap * 2);
        }
            break;
        case LLConfigWindowSuspensionBall:
        default:{
            self.windowStyle = LLConfigWindowSuspensionBall;
            self.contentView.frame = CGRectMake(-self.sBallHideWidth, LL_SCREEN_HEIGHT / 3.0, _sBallWidth, _sBallWidth);
        }
            break;
    }
}

- (void)updateSubViews {
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    // Create contentView
    [self.view addSubview:self.contentView];
    
    // Set up views by windowStyle.
    switch (self.windowStyle) {
        case LLConfigWindowSuspensionBall:{
            // Set ContentView
            self.contentView.layer.cornerRadius = _sBallWidth / 2.0;
            self.contentView.layer.borderWidth = 2;
            
            // Create memoryLabel
            self.memoryLabel.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 4.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0);
            [self.contentView addSubview:self.memoryLabel];
            
            // Create CPULabel
            self.CPULabel.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0, _sBallWidth * 3 / 4.0, _sBallWidth / 4.0);
            [self.contentView addSubview:self.CPULabel];
            
            // Create Line
            self.lineView.frame = CGRectMake(_sBallWidth / 8.0, _sBallWidth / 2.0 - 0.5, _sBallWidth * 3 / 4.0, 1);
            [self.contentView addSubview:self.lineView];
        }
            break;
        case LLConfigWindowPowerBar:
        case LLConfigWindowNetBar:{
            // Set ContentView
            CGFloat gap = self.contentView.frame.size.height / 2.0;
            self.contentView.layer.cornerRadius = gap;
            
            // Create memoryLabel
            self.memoryLabel.frame = CGRectMake(gap, 0, self.contentView.frame.size.width - gap * 2, self.contentView.frame.size.height);
            [self.contentView addSubview:self.memoryLabel];
        }
            break;
        default:
            break;
    }
}

- (void)initGestureRecognizers {
    // View selection
    self.selectTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectionTap:)];
    self.selectTapGR.delegate = self;
    [self.view addGestureRecognizer:self.selectTapGR];
    
    // View moving
    self.movePanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovePan:)];
    self.movePanGR.enabled = self.currentMode == LLWindowViewControllerModeMove;
    [self.view addGestureRecognizer:self.movePanGR];
}

- (void)updateGestureRecognizers {
    // Update contentView recognizers
    for (UIGestureRecognizer *gr in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:gr];
    }
    // Pan, to moveable.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    
    // Double tap, to screenshot.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGR:)];
    doubleTap.numberOfTapsRequired = 2;
    
    // Tap, to show tool view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self.contentView addGestureRecognizer:tap];
    [self.contentView addGestureRecognizer:doubleTap];
    
    switch (self.windowStyle) {
        case LLConfigWindowSuspensionBall:{
            [self.contentView addGestureRecognizer:pan];
        }
            break;
        default:
            break;
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateColorStyleNotification) name:LLConfigDidUpdateColorStyleNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLConfigDidUpdateWindowStyleNotification) name:LLConfigDidUpdateWindowStyleNotificationName object:nil];
}

- (void)registerLLAppInfoHelperNotification {
    if (!self.isRegisterNotification) {
        self.registerNotification = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLLAppInfoHelperDidUpdateAppInfosNotification:) name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
    }
}

- (void)unregisterLLAppInfoHelperNotification {
    if (self.isRegisterNotification) {
        self.registerNotification = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LLAppInfoHelperDidUpdateAppInfosNotificationName object:nil];
    }
}

- (void)becomeActive {
    self.contentView.alpha = [LLConfig sharedConfig].activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.alpha = [LLConfig sharedConfig].normalAlpha;
        // Calculate End Point
        CGFloat x = self.contentView.center.x;
        CGFloat y = self.contentView.center.y;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
    
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.contentView.frame.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.contentView.frame.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.contentView.frame.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.contentView.frame.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.contentView.center = endPoint;
    
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    if (point.x > LL_SCREEN_WIDTH) {
        point.x = LL_SCREEN_WIDTH;
    } else if (point.x < 0) {
        point.x = 0;
    }
    if (point.y > LL_SCREEN_HEIGHT) {
        point.y = LL_SCREEN_HEIGHT;
    } else if (point.y < 0) {
        point.y = 0;
    }
    self.contentView.center = CGPointMake(point.x, point.y);
}

- (void)updateOutlineViewsForSelectionPoint:(CGPoint)selectionPointInWindow
{
    [self removeAndClearOutlineViews];
    
    // Include hidden views in the "viewsAtTapPoint" array so we can show them in the hierarchy list.
    self.viewsAtTapPoint = [self viewsAtPoint:selectionPointInWindow skipHiddenViews:NO];
    
    // For outlined views and the selected view, only use visible views.
    // Outlining hidden views adds clutter and makes the selection behavior confusing.
    NSArray<UIView *> *visibleViewsAtTapPoint = [self viewsAtPoint:selectionPointInWindow skipHiddenViews:YES];
    NSMutableDictionary<NSValue *, UIView *> *newOutlineViewsForVisibleViews = [NSMutableDictionary dictionary];
    for (UIView *view in visibleViewsAtTapPoint) {
        UIView *outlineView = [self outlineViewForView:view];
        [self.view addSubview:outlineView];
        NSValue *key = [NSValue valueWithNonretainedObject:view];
        [newOutlineViewsForVisibleViews setObject:outlineView forKey:key];
    }
    self.outlineViewsForVisibleViews = newOutlineViewsForVisibleViews;
    self.selectedView = [self viewForSelectionAtPoint:selectionPointInWindow];
    
    // Make sure the explorer toolbar doesn't end up behind the newly added outline views.
//    [self.view bringSubviewToFront:self.explorerToolbar];
    
    [self updateButtonStates];
}

- (UIView *)viewForSelectionAtPoint:(CGPoint)tapPointInWindow
{
    // Select in the window that would handle the touch, but don't just use the result of hitTest:withEvent: so we can still select views with interaction disabled.
    // Default to the the application's key window if none of the windows want the touch.
    UIWindow *windowForSelection = [[UIApplication sharedApplication] keyWindow];
    for (UIWindow *window in [[[LLHierarchyHelper sharedHelper] allWindows] reverseObjectEnumerator]) {
        // Ignore the explorer's own window.
        if (window != self.view.window) {
            if ([window hitTest:tapPointInWindow withEvent:nil]) {
                windowForSelection = window;
                break;
            }
        }
    }
    
    // Select the deepest visible view at the tap point. This generally corresponds to what the user wants to select.
    return [[self recursiveSubviewsAtPoint:tapPointInWindow inView:windowForSelection skipHiddenViews:YES] lastObject];
}

- (void)removeAndClearOutlineViews
{
    for (NSValue *key in self.outlineViewsForVisibleViews) {
        UIView *outlineView = self.outlineViewsForVisibleViews[key];
        [outlineView removeFromSuperview];
    }
    self.outlineViewsForVisibleViews = nil;
}

- (NSArray<UIView *> *)viewsAtPoint:(CGPoint)tapPointInWindow skipHiddenViews:(BOOL)skipHidden
{
    NSMutableArray<UIView *> *views = [NSMutableArray array];
    for (UIWindow *window in [[LLHierarchyHelper sharedHelper] allWindows]) {
        // Don't include the explorer's own window or subviews.
        if (window != self.view.window && [window pointInside:tapPointInWindow withEvent:nil]) {
            [views addObject:window];
            [views addObjectsFromArray:[self recursiveSubviewsAtPoint:tapPointInWindow inView:window skipHiddenViews:skipHidden]];
        }
    }
    return views;
}

- (NSArray<UIView *> *)recursiveSubviewsAtPoint:(CGPoint)pointInView inView:(UIView *)view skipHiddenViews:(BOOL)skipHidden
{
    NSMutableArray<UIView *> *subviewsAtPoint = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (skipHidden && isHidden) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
        }
        
        // If this view doesn't clip to its bounds, we need to check its subviews even if it doesn't contain the selection point.
        // They may be visible and contain the selection point.
        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self recursiveSubviewsAtPoint:pointInSubview inView:subview skipHiddenViews:skipHidden]];
        }
    }
    return subviewsAtPoint;
}

- (UIView *)outlineViewForView:(UIView *)view
{
    CGRect outlineFrame = [self frameInLocalCoordinatesForView:view];
    UIView *outlineView = [LLFactory getView:nil frame:outlineFrame backgroundColor:[UIColor clearColor]];
    [LLTool setView:outlineView borderColor:[LLTool colorFromObject:view] borderWidth:1];
    return outlineView;
}

- (CGRect)frameInLocalCoordinatesForView:(UIView *)view
{
    // First convert to window coordinates since the view may be in a different window than our view.
    CGRect frameInWindow = [view convertRect:view.bounds toView:nil];
    // Then convert from the window to our view's coordinate space.
    return [self.view convertRect:frameInWindow fromView:nil];
}

- (void)updateButtonStates {
    // Move and details only active when an object is selected.
    BOOL hasSelectedObject = self.selectedView != nil;
    self.hierarchyToolBar.moveItem.enabled = hasSelectedObject;
    if (self.currentMode == LLWindowViewControllerModeSelect) {
        self.hierarchyToolBar.selectedItem = self.hierarchyToolBar.selectItem;
    } else if (self.currentMode == LLWindowViewControllerModeMove) {
        self.hierarchyToolBar.selectedItem = self.hierarchyToolBar.moveItem;
    }
}

- (void)setSelectedView:(UIView *)selectedView
{
    if (![_selectedView isEqual:selectedView]) {
        if (![self.viewsAtTapPoint containsObject:_selectedView]) {
            [self stopObservingView:_selectedView];
        }
        
        _selectedView = selectedView;
        
        [self beginObservingView:selectedView];
        
        // Update the toolbar and selected overlay
        [self.hierarchyToolBar confirmWithView:selectedView];
#warning Need Update
//        self.explorerToolbar.selectedViewDescription = [FLEXUtility descriptionForView:selectedView includingFrame:YES];
//        self.explorerToolbar.selectedViewOverlayColor = [FLEXUtility consistentRandomColorForObject:selectedView];
        
        if (selectedView) {
            if (!self.selectedViewOverlay) {
                self.selectedViewOverlay = [LLFactory getView:self.view];
                [LLTool setView:self.selectedViewOverlay borderWidth:1];
            }
            UIColor *outlineColor = [LLTool colorFromObject:selectedView];
            self.selectedViewOverlay.backgroundColor = [outlineColor colorWithAlphaComponent:0.2];
            self.selectedViewOverlay.layer.borderColor = [outlineColor CGColor];
            self.selectedViewOverlay.frame = [self.view convertRect:selectedView.bounds fromView:selectedView];
            
            // Make sure the selected overlay is in front of all the other subviews except the toolbar, which should always stay on top.
            [self.view bringSubviewToFront:self.selectedViewOverlay];
#warning Need Update
            [self.view bringSubviewToFront:self.hierarchyToolBar];
        } else {
            [self.selectedViewOverlay removeFromSuperview];
            self.selectedViewOverlay = nil;
        }
        
        // Some of the button states depend on whether we have a selected view.
        [self updateButtonStates];
    }
}

- (void)setViewsAtTapPoint:(NSArray<UIView *> *)viewsAtTapPoint
{
    if (![_viewsAtTapPoint isEqual:viewsAtTapPoint]) {
        for (UIView *view in _viewsAtTapPoint) {
            if (view != self.selectedView) {
                [self stopObservingView:view];
            }
        }
        
        _viewsAtTapPoint = viewsAtTapPoint;
        
        for (UIView *view in viewsAtTapPoint) {
            [self beginObservingView:view];
        }
    }
}

- (void)setMode:(LLWindowViewControllerMode)mode {
    if (_mode != mode) {
        _mode = mode;
        switch (mode) {
            case LLWindowViewControllerModeDefault:
                [self removeAndClearOutlineViews];
                self.viewsAtTapPoint = nil;
                self.selectedView = nil;
                [self showExplorerView];
                break;
                
            case LLWindowViewControllerModeSelect:
                // Make sure the outline views are unhidden in case we came from the move mode.
                for (NSValue *key in self.outlineViewsForVisibleViews) {
                    UIView *outlineView = self.outlineViewsForVisibleViews[key];
                    outlineView.hidden = NO;
                }
                [self hideExplorerView];
                break;
                
            case LLWindowViewControllerModeMove:
                // Hide all the outline views to focus on the selected view, which is the only one that will move.
                for (NSValue *key in self.outlineViewsForVisibleViews) {
                    UIView *outlineView = self.outlineViewsForVisibleViews[key];
                    outlineView.hidden = YES;
                }
                break;
        }
        self.movePanGR.enabled = mode == LLWindowViewControllerModeMove;
        [self updateButtonStates];
    }
}

- (void)beginObservingView:(UIView *)view
{
    // Bail if we're already observing this view or if there's nothing to observe.
    if (!view || [self.observedViews containsObject:view]) {
        return;
    }
    
    for (NSString *keyPath in [[self class] viewKeyPathsToTrack]) {
        [view addObserver:self forKeyPath:keyPath options:0 context:NULL];
    }
    
    [self.observedViews addObject:view];
}

- (void)stopObservingView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    for (NSString *keyPath in [[self class] viewKeyPathsToTrack]) {
        [view removeObserver:self forKeyPath:keyPath];
    }
    
    [self.observedViews removeObject:view];
}

+ (NSArray<NSString *> *)viewKeyPathsToTrack
{
    static NSArray<NSString *> *trackedViewKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *frameKeyPath = NSStringFromSelector(@selector(frame));
        trackedViewKeyPaths = @[frameKeyPath];
    });
    return trackedViewKeyPaths;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context
{
    [self updateOverlayAndDescriptionForObjectIfNeeded:object];
}

- (void)updateOverlayAndDescriptionForObjectIfNeeded:(id)object
{
    NSUInteger indexOfView = [self.viewsAtTapPoint indexOfObject:object];
    if (indexOfView != NSNotFound) {
        UIView *view = self.viewsAtTapPoint[indexOfView];
        NSValue *key = [NSValue valueWithNonretainedObject:view];
        UIView *outline = self.outlineViewsForVisibleViews[key];
        if (outline) {
            outline.frame = [self frameInLocalCoordinatesForView:view];
        }
    }
    if (object == self.selectedView) {
        // Update the selected view description since we show the frame value there.
#warning NEED UPDATE
//        self.explorerToolbar.selectedViewDescription = [FLEXUtility descriptionForView:self.selectedView includingFrame:YES];
        CGRect selectedViewOutlineFrame = [self frameInLocalCoordinatesForView:self.selectedView];
        self.selectedViewOverlay.frame = selectedViewOutlineFrame;
    }
}


#pragma mark - Recode
- (UIViewController *)viewControllerForRotationAndOrientation
{
    UIWindow *window = self.previousKeyWindow ?: [[UIApplication sharedApplication] keyWindow];
    UIViewController *viewController = window.rootViewController;
    NSString *viewControllerSelectorString = [@[@"_vie", @"wContro", @"llerFor", @"Supported", @"Interface", @"Orientations"] componentsJoinedByString:@""];
    SEL viewControllerSelector = NSSelectorFromString(viewControllerSelectorString);
    if ([viewController respondsToSelector:viewControllerSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        viewController = [viewController performSelector:viewControllerSelector];
#pragma clang diagnostic pop
    }
    return viewController;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController *viewControllerToAsk = [self viewControllerForRotationAndOrientation];
    UIInterfaceOrientationMask supportedOrientations = [LLTool infoPlistSupportedInterfaceOrientationsMask];
    if (viewControllerToAsk && viewControllerToAsk != self) {
        supportedOrientations = [viewControllerToAsk supportedInterfaceOrientations];
    }
    
    // The UIViewController docs state that this method must not return zero.
    // If we weren't able to get a valid value for the supported interface orientations, default to all supported.
    if (supportedOrientations == 0) {
        supportedOrientations = UIInterfaceOrientationMaskAll;
    }
    
    return supportedOrientations;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewControllerToAsk = [self viewControllerForRotationAndOrientation];
    BOOL shouldAutorotate = YES;
    if (viewControllerToAsk && viewControllerToAsk != self) {
        shouldAutorotate = [viewControllerToAsk shouldAutorotate];
    }
    return shouldAutorotate;
}

// Fix the bug of missing status bars under ios9.
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [LLConfig sharedConfig].statusBarStyle;
}

// TODO: Know why does this method affect the statusBar for keywindow.
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIWindow *)statusWindow
{
    return [[UIApplication sharedApplication] valueForKey:@"_statusBarWindow"];
}

- (void)makeKeyAndPresentTabbarControllerWithIndex:(NSInteger)index params:(NSDictionary <NSString *,id>*)params{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makeKeyAndPresentTabbarControllerWithIndex:index params:params];
        });
        return;
    }
    
    self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.view.window makeKeyWindow];
    
    [[self statusWindow] setWindowLevel:self.view.window.windowLevel + 1.0];
    
    self.previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[LLConfig sharedConfig].statusBarStyle];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarController.selectedIndex = index;
    if (params.count) {
        UINavigationController *nav = self.tabBarController.viewControllers[index];
        UIViewController *vc = nav.viewControllers[0];
        for (NSString *key in params.allKeys) {
            id value = params[key];
            [vc setValue:value forKey:key];
        }
    }
    [self presentViewController:[[LLBaseNavigationController alloc] initWithRootViewController:self.functionViewController] animated:YES completion:nil];
}

- (void)resignKeyWindow {
    UIWindow *previousKeyWindow = self.previousKeyWindow;
    self.previousKeyWindow = nil;
    if (previousKeyWindow) {
        [previousKeyWindow makeKeyWindow];
        
        [[previousKeyWindow rootViewController] setNeedsStatusBarAppearanceUpdate];
        
        [[self statusWindow] setWindowLevel:UIWindowLevelStatusBar];
        
        [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusBarStyle];
        
        [self reloadTabbar];
    }
}

#pragma mark - Hierarchy Part
- (void)showHierarchyToolBar {
    self.hierarchyToolBar.frame = CGRectMake(-LL_SCREEN_WIDTH, self.hierarchyToolBar.frame.origin.y, self.hierarchyToolBar.frame.size.width, self.hierarchyToolBar.frame.size.height);
    [self.view addSubview:self.hierarchyToolBar];
    [UIView animateWithDuration:0.25 animations:^{
        self.hierarchyToolBar.frame = CGRectMake(0, self.hierarchyToolBar.frame.origin.y, self.hierarchyToolBar.frame.size.width, self.hierarchyToolBar.frame.size.height);
    }];
}

- (void)hideHierarchyToolBar {
    [UIView animateWithDuration:0.25 animations:^{
        self.hierarchyToolBar.frame = CGRectMake(-LL_SCREEN_WIDTH, self.hierarchyToolBar.frame.origin.y, self.hierarchyToolBar.frame.size.width, self.hierarchyToolBar.frame.size.height);
    } completion:^(BOOL finished) {
        [self.hierarchyToolBar removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)handleSelectionTap:(UITapGestureRecognizer *)gr
{
    // Only if we're in selection mode
    if (self.currentMode == LLWindowViewControllerModeSelect && gr.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPointInView = [gr locationInView:self.view];
        CGPoint tapPointInWindow = [self.view convertPoint:tapPointInView toView:nil];
        if (!CGRectContainsPoint(self.hierarchyToolBar.frame, tapPointInView)) {
            [self updateOutlineViewsForSelectionPoint:tapPointInWindow];
        }
    }
}

- (void)handleMovePan:(UIPanGestureRecognizer *)movePanGR
{
    switch (movePanGR.state) {
        case UIGestureRecognizerStateBegan:
            self.selectedViewFrameBeforeDragging = self.selectedView.frame;
            [self updateSelectedViewPositionWithDragGesture:movePanGR];
            break;
            
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            [self updateSelectedViewPositionWithDragGesture:movePanGR];
            break;
            
        default:
            break;
    }
}

- (void)updateSelectedViewPositionWithDragGesture:(UIPanGestureRecognizer *)movePanGR
{
    CGPoint translation = [movePanGR translationInView:self.selectedView.superview];
    CGRect newSelectedViewFrame = self.selectedViewFrameBeforeDragging;
    newSelectedViewFrame.origin.x = newSelectedViewFrame.origin.x + translation.x;
    newSelectedViewFrame.origin.y = newSelectedViewFrame.origin.y + translation.y;
    self.selectedView.frame = newSelectedViewFrame;
}

- (void)panGR:(UIPanGestureRecognizer *)gr {
    if ([LLConfig sharedConfig].suspensionBallMoveable) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGPoint panPoint = [gr locationInView:window];
        if (gr.state == UIGestureRecognizerStateBegan)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
            [self becomeActive];
        } else if (gr.state == UIGestureRecognizerStateChanged) {
            [self changeSBallViewFrameWithPoint:panPoint];
        } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
            [self resignActive];
        }
    }
}

- (void)tapGR:(UITapGestureRecognizer *)gr {
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
}

- (void)doubleTapGR:(UITapGestureRecognizer *)gr {
    [[LLScreenshotHelper sharedHelper] simulateTakeScreenshot];
}

#pragma mark - Lazy load
- (LLFunctionViewController *)functionViewController {
    if (_functionViewController == nil) {
        _functionViewController = [[LLFunctionViewController alloc] init];
    }
    return _functionViewController;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [LLFactory getBackgroundView:nil frame:CGRectZero];
        [LLTool setView:_contentView borderColor:LLCONFIG_TEXT_COLOR borderWidth:0];
        _contentView.layer.masksToBounds = YES;
        _contentView.alpha = [LLConfig sharedConfig].normalAlpha;
    }
    return _contentView;
}

- (UILabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [LLFactory getLabel:nil frame:CGRectZero text:@"loading" font:12 textColor:LLCONFIG_TEXT_COLOR];
        _memoryLabel.textAlignment = NSTextAlignmentCenter;
        _memoryLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _memoryLabel;
}

- (UILabel *)CPULabel {
    if (!_CPULabel) {
        _CPULabel = [LLFactory getLabel:nil frame:CGRectZero text:@"loading" font:10 textColor:LLCONFIG_TEXT_COLOR];
        _CPULabel.textAlignment = NSTextAlignmentCenter;
        _CPULabel.adjustsFontSizeToFitWidth = YES;
    }
    return _CPULabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [LLFactory getPrimaryView];
    }
    return _lineView;
}

- (NSMutableSet<UIView *> *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableSet set];
    }
    return _observedViews;
}

- (LLHierarchyExplorerToolBar *)hierarchyToolBar {
    if (!_hierarchyToolBar) {
        CGFloat actionViewHeight = 79;
        _hierarchyToolBar = [[LLHierarchyExplorerToolBar alloc] initWithFrame:CGRectMake(0, LL_SCREEN_HEIGHT - [self safeArea].bottom - actionViewHeight, LL_SCREEN_WIDTH, actionViewHeight)];
        _hierarchyToolBar.delegate = self;
    }
    return _hierarchyToolBar;
}

- (UIEdgeInsets)safeArea {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        // Can't call this method at begining. safeAreaInsets will be updated later.
        insets = self.view.safeAreaInsets;
    }
    return insets;
}

@end
