//
//  UIView+LL_Hierarchy.m
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

#import "UIView+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLEnumDescription.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLHierarchyHelper.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCellModel.h"
#import "LLTool.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"
#import "NSObject+LL_Runtime.h"

@implementation UIView (LL_Hierarchy)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self LL_swizzleInstanceSelector:@selector(setFrame:) anotherSelector:@selector(LL_Hierarchy_setFrame:)];
        [self LL_swizzleInstanceSelector:@selector(setCenter:) anotherSelector:@selector(LL_Hierarchy_setCenter:)];
        [self LL_swizzleInstanceSelector:@selector(setAlpha:) anotherSelector:@selector(LL_Hierarchy_setAlpha:)];
        [self LL_swizzleInstanceSelector:@selector(setHidden:) anotherSelector:@selector(LL_Hierarchy_setHidden:)];
    });
}

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Layer" detailTitle:self.layer.description] noneInsets];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [LLDetailTitleCellModel modelWithTitle:@"Layer Class" detailTitle:NSStringFromClass(self.layer.class)];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Content Model" detailTitle:[LLEnumDescription viewContentModeDescription:self.contentMode]] noneInsets];
    model3.block = ^{
        [[LLHierarchyHelper shared] showActionSheetWithActions:[LLEnumDescription viewContentModeDescriptions]
                                                 currentAction:[LLEnumDescription viewContentModeDescription:weakSelf.contentMode]
                                                    completion:^(NSInteger index) {
                                                        weakSelf.contentMode = index;
                                                    }];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Tag" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.tag]];
    model4.block = ^{
        [weakSelf LL_showIntAlertAndAutomicSetWithKeyPath:@"tag"];
    };
    [settings addObject:model4];

    LLTitleSwitchCellModel *model5 = [[LLTitleSwitchCellModel modelWithTitle:@"User Interaction" isOn:self.isUserInteractionEnabled] noneInsets];
    model5.changePropertyBlock = ^(id obj) {
        weakSelf.userInteractionEnabled = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model5];

    LLTitleSwitchCellModel *model6 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Multiple Touch" isOn:self.isMultipleTouchEnabled];
    model6.changePropertyBlock = ^(id obj) {
        weakSelf.multipleTouchEnabled = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [[LLDetailTitleCellModel modelWithTitle:@"Alpha" detailTitle:[LLFormatterTool formatNumber:@(self.alpha)]] noneInsets];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"alpha"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Background" detailTitle:[LLHierarchyFormatter formatColor:self.backgroundColor]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"backgroundColor"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Tint" detailTitle:[LLHierarchyFormatter formatColor:self.tintColor]];
    model9.block = ^{
        [weakSelf LL_showColorAlertAndAutomicSetWithKeyPath:@"tintColor"];
    };
    [settings addObject:model9];

    LLTitleSwitchCellModel *model10 = [[LLTitleSwitchCellModel modelWithTitle:@"Drawing" detailTitle:@"Opaque" isOn:self.isOpaque] noneInsets];
    model10.changePropertyBlock = ^(id obj) {
        weakSelf.opaque = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model10];

    LLTitleSwitchCellModel *model11 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Hidden" isOn:self.isHidden] noneInsets];
    model11.changePropertyBlock = ^(id obj) {
        weakSelf.hidden = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model11];

    LLTitleSwitchCellModel *model12 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clears Graphics Context" isOn:self.clearsContextBeforeDrawing] noneInsets];
    model12.changePropertyBlock = ^(id obj) {
        weakSelf.clearsContextBeforeDrawing = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model12];

    LLTitleSwitchCellModel *model13 = [[LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Clip To Bounds" isOn:self.clipsToBounds] noneInsets];
    model13.changePropertyBlock = ^(id obj) {
        weakSelf.clipsToBounds = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model13];

    LLTitleSwitchCellModel *model14 = [LLTitleSwitchCellModel modelWithTitle:nil detailTitle:@"Autoresizes Subviews" isOn:self.autoresizesSubviews];
    model14.changePropertyBlock = ^(id obj) {
        weakSelf.autoresizesSubviews = [obj boolValue];
        [[LLHierarchyHelper shared] postDebugToolChangeHierarchyNotification];
    };
    [settings addObject:model14];

    LLDetailTitleCellModel *model15 = [[LLDetailTitleCellModel modelWithTitle:@"Trait Collection" detailTitle:nil] noneInsets];
    [settings addObject:model15];

    if (@available(iOS 12.0, *)) {
        LLDetailTitleCellModel *model16 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription userInterfaceStyleDescription:self.traitCollection.userInterfaceStyle]] noneInsets];
        [settings addObject:model16];
    }

    LLDetailTitleCellModel *model17 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[@"Vertical" stringByAppendingFormat:@" %@", [LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.verticalSizeClass]]] noneInsets];
    [settings addObject:model17];

    LLDetailTitleCellModel *model18 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[@"Horizontal" stringByAppendingFormat:@" %@", [LLEnumDescription userInterfaceSizeClassDescription:self.traitCollection.horizontalSizeClass]]] noneInsets];
    [settings addObject:model18];

    if (@available(iOS 10.0, *)) {
        LLDetailTitleCellModel *model19 = [LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLEnumDescription traitEnvironmentLayoutDirectionDescription:self.traitCollection.layoutDirection]];
        [settings addObject:model19];
    }

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

- (NSArray<LLTitleCellCategoryModel *> *)LL_sizeHierarchyCategoryModels {
    __weak typeof(self) weakSelf = self;
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [[LLDetailTitleCellModel modelWithTitle:@"Frame" detailTitle:[LLHierarchyFormatter formatPoint:self.frame.origin]] noneInsets];
    model1.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"frame"];
    };
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatSize:self.frame.size]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Bounds" detailTitle:[LLHierarchyFormatter formatPoint:self.bounds.origin]] noneInsets];
    model3.block = ^{
        [weakSelf LL_showFrameAlertAndAutomicSetWithKeyPath:@"bounds"];
    };
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [[LLDetailTitleCellModel modelWithTitle:nil detailTitle:[LLHierarchyFormatter formatSize:self.bounds.size]] noneInsets];
    [settings addObject:model4];

    LLDetailTitleCellModel *model5 = [[LLDetailTitleCellModel modelWithTitle:@"Center" detailTitle:[LLHierarchyFormatter formatPoint:self.center]] noneInsets];
    model5.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"center"];
    };
    [settings addObject:model5];

    LLDetailTitleCellModel *model6 = [[LLDetailTitleCellModel modelWithTitle:@"Position" detailTitle:[LLHierarchyFormatter formatPoint:self.layer.position]] noneInsets];
    model6.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.position"];
    };
    [settings addObject:model6];

    LLDetailTitleCellModel *model7 = [LLDetailTitleCellModel modelWithTitle:@"Z Position" detailTitle:[LLFormatterTool formatNumber:@(self.layer.zPosition)]];
    model7.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.zPosition"];
    };
    [settings addObject:model7];

    LLDetailTitleCellModel *model8 = [[LLDetailTitleCellModel modelWithTitle:@"Anchor Point" detailTitle:[LLHierarchyFormatter formatPoint:self.layer.anchorPoint]] noneInsets];
    model8.block = ^{
        [weakSelf LL_showPointAlertAndAutomicSetWithKeyPath:@"layer.anchorPoint"];
    };
    [settings addObject:model8];

    LLDetailTitleCellModel *model9 = [LLDetailTitleCellModel modelWithTitle:@"Anchor Point Z" detailTitle:[LLFormatterTool formatNumber:@(self.layer.anchorPointZ)]];
    model9.block = ^{
        [weakSelf LL_showDoubleAlertAndAutomicSetWithKeyPath:@"layer.anchorPointZ"];
    };
    [settings addObject:model9];

    LLTitleCellModel *lastConstrainModel = nil;

    for (NSLayoutConstraint *constrain in self.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        NSString *constrainDesc = [self LL_hierarchyLayoutConstraintDescription:constrain];
        if (constrainDesc) {
            LLDetailTitleCellModel *mod = [[LLDetailTitleCellModel modelWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
            __weak NSLayoutConstraint *cons = constrain;
            mod.block = ^{
                [[LLHierarchyHelper shared] showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)]
                                                               handler:^(NSString *originText, NSString *newText) {
                                                                   cons.constant = [newText doubleValue];
                                                                   [weakSelf setNeedsLayout];
                                                               }];
            };
            [settings addObject:mod];
            lastConstrainModel = mod;
        }
    }

    for (NSLayoutConstraint *constrain in self.superview.constraints) {
        if (!constrain.shouldBeArchived) {
            continue;
        }
        if (constrain.firstItem == self || constrain.secondItem == self) {
            NSString *constrainDesc = [self LL_hierarchyLayoutConstraintDescription:constrain];
            if (constrainDesc) {
                LLDetailTitleCellModel *mod = [[LLDetailTitleCellModel modelWithTitle:lastConstrainModel ? nil : @"Constrains" detailTitle:constrainDesc] noneInsets];
                __weak NSLayoutConstraint *cons = constrain;
                mod.block = ^{
                    [[LLHierarchyHelper shared] showTextFieldAlertWithText:[LLFormatterTool formatNumber:@(cons.constant)]
                                                                   handler:^(NSString *originText, NSString *newText) {
                                                                       cons.constant = [newText doubleValue];
                                                                       [weakSelf setNeedsLayout];
                                                                   }];
                };
                [settings addObject:mod];
                lastConstrainModel = mod;
            }
        }
    }

    [lastConstrainModel normalInsets];

    return @[[LLTitleCellCategoryModel modelWithTitle:@"View" items:settings]];
}

- (NSString *)LL_hierarchyLayoutConstraintDescription:(NSLayoutConstraint *)constraint {
    NSMutableString *string = [[NSMutableString alloc] init];
    if (constraint.firstItem == self) {
        [string appendString:@"self."];
    } else if (constraint.firstItem == self.superview) {
        [string appendString:@"superview."];
    } else {
        [string appendFormat:@"%@.", NSStringFromClass([constraint.firstItem class])];
    }
    [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.firstAttribute]];
    [string appendString:[LLEnumDescription layoutRelationDescription:constraint.relation]];
    if (constraint.secondItem) {
        if (constraint.secondItem == self) {
            [string appendString:@"self."];
        } else if (constraint.secondItem == self.superview) {
            [string appendString:@"superview."];
        } else {
            [string appendFormat:@"%@.", NSStringFromClass([constraint.secondItem class])];
        }
        [string appendString:[LLEnumDescription layoutAttributeDescription:constraint.secondAttribute]];
        if (constraint.multiplier != 1) {
            [string appendFormat:@" * %@", [LLFormatterTool formatNumber:@(constraint.multiplier)]];
        }
        if (constraint.constant > 0) {
            [string appendFormat:@" + %@", [LLFormatterTool formatNumber:@(constraint.constant)]];
        } else if (constraint.constant < 0) {
            [string appendFormat:@" - %@", [LLFormatterTool formatNumber:@(fabs(constraint.constant))]];
        }
    } else if (constraint.constant) {
        [string appendString:[LLFormatterTool formatNumber:@(constraint.constant)]];
    } else {
        return nil;
    }

    [string appendFormat:@" @ %@", [LLFormatterTool formatNumber:@(constraint.priority)]];
    return string;
}

- (void)LL_showFrameAlertAndAutomicSetWithKeyPath:(NSString *)keyPath {
    __block NSValue *value = [self valueForKeyPath:keyPath];
    __weak typeof(self) weakSelf = self;
    [[LLHierarchyHelper shared] showTextFieldAlertWithText:[LLTool stringFromFrame:value.CGRectValue]
                                                   handler:^(NSString *originText, NSString *newText) {
                                                       NSValue *newValue = [NSValue valueWithCGRect:[LLHierarchyFormatter rectFromString:newText defaultValue:[value CGRectValue]]];
                                                       if ([keyPath isEqualToString:@"frame"]) {
                                                           if (self.LL_isLock) {
                                                               [self willChangeValueForKey:@"frame"];
                                                               [self LL_Hierarchy_setFrame:newValue.CGRectValue];
                                                               [self didChangeValueForKey:@"frame"];
                                                           } else {
                                                               [weakSelf setValue:newValue forKeyPath:keyPath];
                                                           }
                                                       } else {
                                                           [weakSelf setValue:newValue forKey:keyPath];
                                                       }
                                                   }];
}

#pragma mark - Getters and setters
- (void)LL_Hierarchy_setFrame:(CGRect)frame {
    if (self.LL_isLock) {
        self.LL_lockFrame = [NSValue valueWithCGRect:frame];
    } else {
        [self LL_Hierarchy_setFrame:frame];
    }
}

- (void)LL_Hierarchy_setCenter:(CGPoint)center {
    if (self.LL_isLock) {
        self.LL_lockCenter = [NSValue valueWithCGPoint:center];
    } else {
        [self LL_Hierarchy_setCenter:center];
    }
}

- (void)LL_Hierarchy_setAlpha:(CGFloat)alpha {
    if (self.LL_isLock) {
        self.LL_lockAlpha = @(alpha);
    } else {
        [self LL_Hierarchy_setAlpha:alpha];
    }
}

- (void)LL_Hierarchy_setHidden:(BOOL)hidden {
    if (self.LL_isLock) {
        self.LL_lockHidden = @(hidden);
    } else {
        [self LL_Hierarchy_setHidden:hidden];
    }
}

- (void)setLL_lock:(BOOL)LL_lock {
    BOOL isLock = self.LL_isLock;
    if (isLock != LL_lock) {
        objc_setAssociatedObject(self, @selector(LL_isLock), @(LL_lock), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!LL_lock) {
            if (self.LL_lockFrame) {
                self.frame = self.LL_lockFrame.CGRectValue;
            }
            if (self.LL_lockCenter) {
                self.center = self.LL_lockCenter.CGPointValue;
            }
            if (self.LL_lockAlpha) {
                self.alpha = self.LL_lockAlpha.floatValue;
            }
            if (self.LL_lockHidden) {
                self.hidden = self.LL_lockHidden.boolValue;
            }

            self.LL_lockFrame = nil;
            self.LL_lockCenter = nil;
            self.LL_lockAlpha = nil;
            self.LL_lockHidden = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:LLDebugToolChangeHierarchyNotification object:nil];
        }
    }
}

- (BOOL)LL_isLock {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLL_lockFrame:(NSValue *)LL_lockFrame {
    objc_setAssociatedObject(self, @selector(LL_lockFrame), LL_lockFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.LL_lockCenter = nil;
}

- (NSValue *)LL_lockFrame {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockCenter:(NSValue *)LL_lockCenter {
    objc_setAssociatedObject(self, @selector(LL_lockCenter), LL_lockCenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)LL_lockCenter {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockAlpha:(NSNumber *)LL_lockAlpha {
    objc_setAssociatedObject(self, @selector(LL_lockAlpha), LL_lockAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)LL_lockAlpha {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLL_lockHidden:(NSNumber *)LL_lockHidden {
    objc_setAssociatedObject(self, @selector(LL_lockHidden), LL_lockHidden, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)LL_lockHidden {
    return objc_getAssociatedObject(self, _cmd);
}

@end
