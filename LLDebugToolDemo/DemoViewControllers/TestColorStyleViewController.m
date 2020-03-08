//
//  TestColorStyleViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2018/8/29.
//  Copyright © 2018年 li. All rights reserved.
//

#import "TestColorStyleViewController.h"
#import "LLDebugTool.h"

@interface TestColorStyleViewController ()

@end

@implementation TestColorStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.color.style", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleHack\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleHack ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleSimple\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleSimple ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleSystem\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleSystem ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleGrass\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleGrass ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleHomebrew\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleHomebrew ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleManPage\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleManPage ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleNovel\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleNovel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleOcean\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleOcean ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 8) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStylePro\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStylePro ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 9) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleRedSands\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleRedSands ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 10) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleSilverAerogel\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleSilverAerogel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 11) {
        cell.textLabel.text = @"Use \"LLDebugConfigColorStyleSolidColors\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleSolidColors ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 12) {
        cell.textLabel.text = @"Use \"[[LLDebugConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault]\"";
        cell.accessoryType = [LLDebugConfig shared].colorStyle == LLDebugConfigColorStyleCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testHackColorStyle];
    } else if (indexPath.row == 1) {
        [self testSimpleColorSytle];
    } else if (indexPath.row == 2) {
        [self testSystemColorStyle];
    } else if (indexPath.row == 3) {
        [self testGrassColorStyle];
    } else if (indexPath.row == 4) {
        [self testHomebrewColorStyle];
    } else if (indexPath.row == 5) {
        [self testManPageColorStyle];
    } else if (indexPath.row == 6) {
        [self testNovelColorStyle];
    } else if (indexPath.row == 7) {
        [self testOceanColorStyle];
    } else if (indexPath.row == 8) {
        [self testProColorStyle];
    } else if (indexPath.row == 9) {
        [self testRedSandsColorStyle];
    } else if (indexPath.row == 10) {
        [self testSilverAerogelColorStyle];
    } else if (indexPath.row == 11) {
        [self testSolidColorsColorStyle];
    } else if (indexPath.row == 12) {
        [self testCustomColorConfig];
    }
    [tableView reloadData];
}

#pragma mark - Actions
- (void)testHackColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleHack;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSimpleColorSytle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleSimple;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSystemColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleSystem;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testGrassColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleGrass;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testHomebrewColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleHomebrew;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testManPageColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleManPage;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testNovelColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleNovel;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testOceanColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleOcean;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testProColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStylePro;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testRedSandsColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleRedSands;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSilverAerogelColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleSilverAerogel;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSolidColorsColorStyle {
    [LLDebugConfig shared].colorStyle = LLDebugConfigColorStyleSolidColors;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testCustomColorConfig {
    [[LLDebugConfig shared] configPrimaryColor:[UIColor whiteColor] backgroundColor:[UIColor orangeColor] statusBarStyle:UIStatusBarStyleLightContent];
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

@end
