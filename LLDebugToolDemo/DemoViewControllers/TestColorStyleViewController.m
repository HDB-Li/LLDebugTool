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
        cell.textLabel.text = @"Use \"LLConfigColorStyleHack\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleHack ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleSimple\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleSimple ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleSystem\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleSystem ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleGrass\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleGrass ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleHomebrew\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleHomebrew ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleManPage\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleManPage ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleNovel\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleNovel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleOcean\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleOcean ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 8) {
        cell.textLabel.text = @"Use \"LLConfigColorStylePro\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStylePro ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 9) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleRedSands\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleRedSands ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 10) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleSilverAerogel\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleSilverAerogel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 11) {
        cell.textLabel.text = @"Use \"LLConfigColorStyleSolidColors\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleSolidColors ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (indexPath.row == 12) {
        cell.textLabel.text = @"Use \"[[LLConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault]\"";
        cell.accessoryType = [LLConfig shared].colorStyle == LLConfigColorStyleCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
    [LLConfig shared].colorStyle = LLConfigColorStyleHack;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSimpleColorSytle {
    [LLConfig shared].colorStyle = LLConfigColorStyleSimple;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSystemColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleSystem;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testGrassColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleGrass;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testHomebrewColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleHomebrew;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testManPageColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleManPage;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testNovelColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleNovel;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testOceanColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleOcean;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testProColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStylePro;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testRedSandsColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleRedSands;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSilverAerogelColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleSilverAerogel;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testSolidColorsColorStyle {
    [LLConfig shared].colorStyle = LLConfigColorStyleSolidColors;
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

- (void)testCustomColorConfig {
    [[LLConfig shared] configPrimaryColor:[UIColor whiteColor] backgroundColor:[UIColor orangeColor] statusBarStyle:UIStatusBarStyleLightContent];
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSetting];
}

@end
