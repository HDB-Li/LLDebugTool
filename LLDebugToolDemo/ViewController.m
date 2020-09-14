//
//  ViewController.m
//  LLDebugToolDemo
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 li. All rights reserved.
//

#import "ViewController.h"

// If you integrate with cocoapods, used #import <LLDebug.h>.
#import "LLDebug.h"

// Used to example.
#import <CoreLocation/CoreLocation.h>
#import <Photos/PHPhotoLibrary.h>
#import "NetTool.h"

#import "TestColorStyleViewController.h"
#import "TestCrashViewController.h"
#import "TestHierarchyViewController.h"
#import "TestHtmlViewController.h"
#import "TestLocationViewController.h"
#import "TestLogViewController.h"
#import "TestNetworkViewController.h"
#import "TestShortCutViewController.h"
#import "TestWindowStyleViewController.h"

#import "LLStorageManager.h"

static NSString *const kCellID = @"cellID";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    // LLDebugTool need time to start.
    sleep(0.5);
    [self doSomeActions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Primary
- (void)initUI {
    self.imgView = [[UIImageView alloc] init];
    self.imgView.tag = 101;
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.imgView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 28;
    self.tableView.sectionFooterHeight = 28;
    [self.view addSubview:self.tableView];

    [self addImgViewConstrains];
    [self addTableViewConstrains];
}

- (void)addImgViewConstrains {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:220];
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imgView.superview addConstraints:@[left, right, top, height]];
}

- (void)addTableViewConstrains {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.superview addConstraints:@[left, right, top, bottom]];
}

- (void)doSomeActions {
    [self requestLocationAuthorization];
    [self doSandboxIfNeeded];
    [self doCrashIfNeeded];
    [self doNetwork];
    [self doLog];
}

- (void)requestLocationAuthorization {
    // Try to get location permission, and if possible, mock location will get your current location.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)doCrashIfNeeded {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"openCrash"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openCrash"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LLDebugTool sharedTool] executeAction:LLDebugToolActionCrash];
        });
    }
}

- (void)doSandboxIfNeeded {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *extensions = @[@"gif", @"html", @"jpg", @"json", @"md", @"mp3", @"mp4", @"pdf", @"plist", @"png", @"txt"];
        for (NSString *extension in extensions) {
            [self copyFileWithExtensionIfNeeded:extension];
        }
    });
}

- (void)copyFileWithExtensionIfNeeded:(NSString *)extension {
    if ([extension length] == 0) {
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"LLDebugTool.%@", extension]];
    if (![manager fileExistsAtPath:targetPath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LLDebugTool" ofType:extension];
        if (path) {
            NSError *error = nil;
            if (![manager copyItemAtPath:path toPath:targetPath error:&error]) {
                NSLog(@"Copy resource failed");
            }
        }
    }
}

- (void)doNetwork {
    __block __weak typeof(self) weakSelf = self;
    //Network Request
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1567589759362&di=20c415aa38f25ca77270c717ae988424&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201602%2F15%2F20160215231800_zrCN8.jpeg"]];
    [urlRequest setHTTPMethod:@"GET"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (!connectionError) {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       weakSelf.imgView.image = image;
                                   }
                               });
                           }];
#pragma clang diagnostic pop

    // Json Response
    [[NetTool shared]
            .afHTTPSessionManager GET:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

        }];

    //NSURLSession
    NSMutableURLRequest *htmlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [htmlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [[NetTool shared]
                                          .session dataTaskWithRequest:htmlRequest
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){

                                                     }];
    [dataTask resume];
}

- (void)doLog {
    // Log.
    // NSLocalizedString is used for multiple languages.
    // You can just use as LLog(@"What you want to pring").
    LLog(NSLocalizedString(@"initial.log", nil));

    LLog_Alert_Event(@"Demo", NSLocalizedString(@"initial.log", nil));
}

#pragma mark - Actions
- (void)testColorConfig {
    TestColorStyleViewController *vc = [[TestColorStyleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testWindowStyle {
    TestWindowStyleViewController *vc = [[TestWindowStyleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testNetwork {
    TestNetworkViewController *vc = [[TestNetworkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testLog {
    TestLogViewController *vc = [[TestLogViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testCrash {
    TestCrashViewController *vc = [[TestCrashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testAppInfo {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionAppInfo];
}

- (void)testSandbox {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionSandbox];
}

- (void)testScreenshot {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionConvenientScreenshot];
}

- (void)testHierarchy {
    TestHierarchyViewController *vc = [[TestHierarchyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testMagnifier {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionMagnifier];
}

- (void)testRuler {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionRuler];
}

- (void)testWidgetBorder {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionWidgetBorder];
}

- (void)testHtml {
    TestHtmlViewController *vc = [[TestHtmlViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testLocation {
    TestLocationViewController *vc = [[TestLocationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testShortCut {
    TestShortCutViewController *vc = [[TestShortCutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testStartWorking {
    [[LLDebugTool sharedTool] startWorking];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = nil;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"test.color.style", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch ([LLDebugConfig shared].colorStyle) {
                case LLDebugConfigColorStyleHack: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleHack";
                } break;
                case LLDebugConfigColorStyleSimple: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleSimple";
                } break;
                case LLDebugConfigColorStyleSystem: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleSystem";
                } break;
                case LLDebugConfigColorStyleGrass: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleGrass";
                } break;
                case LLDebugConfigColorStyleHomebrew: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleHomebrew";
                } break;
                case LLDebugConfigColorStyleManPage: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleManPage";
                } break;
                case LLDebugConfigColorStyleNovel: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleNovel";
                } break;
                case LLDebugConfigColorStyleOcean: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleOcean";
                } break;
                case LLDebugConfigColorStylePro: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStylePro";
                } break;
                case LLDebugConfigColorStyleRedSands: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleRedSands";
                } break;
                case LLDebugConfigColorStyleSilverAerogel: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleSilverAerogel";
                } break;
                case LLDebugConfigColorStyleSolidColors: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleSolidColors";
                } break;
                case LLDebugConfigColorStyleCustom: {
                    cell.detailTextLabel.text = @"LLDebugConfigColorStyleCustom";
                } break;
            }
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"test.window.style", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch ([LLDebugConfig shared].entryWindowStyle) {
                case LLDebugConfigEntryWindowStyleBall: {
                    cell.detailTextLabel.text = @"LLDebugConfigEntryWindowStyleBall";
                } break;
                case LLDebugConfigEntryWindowStyleTitle: {
                    cell.detailTextLabel.text = @"LLDebugConfigEntryWindowStyleTitle";
                } break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                case LLDebugConfigEntryWindowStylePowerBar: {
                    cell.detailTextLabel.text = @"LLDebugConfigEntryWindowStylePowerBar";
                } break;
                case LLDebugConfigEntryWindowStyleNetBar: {
                    cell.detailTextLabel.text = @"LLDebugConfigEntryWindowStyleNetBar";
                } break;
                case LLDebugConfigEntryWindowStyleAppInfo: {
                    cell.detailTextLabel.text = @"LLDebugConfigEntryWindowStyleAppInfo";
                } break;
#pragma clang diagnostic pop
            }
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"test.network.request", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 2) {
        cell.textLabel.text = NSLocalizedString(@"test.log", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 3) {
        cell.textLabel.text = NSLocalizedString(@"test.crash", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 4) {
        cell.textLabel.text = NSLocalizedString(@"app.info", nil);
    } else if (indexPath.section == 5) {
        cell.textLabel.text = NSLocalizedString(@"sandbox.info", nil);
    } else if (indexPath.section == 6) {
        cell.textLabel.text = NSLocalizedString(@"test.screenshot", nil);
    } else if (indexPath.section == 7) {
        cell.textLabel.text = NSLocalizedString(@"test.hierarchy", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 8) {
        cell.textLabel.text = NSLocalizedString(@"test.magnifier", nil);
    } else if (indexPath.section == 9) {
        cell.textLabel.text = NSLocalizedString(@"test.ruler", nil);
    } else if (indexPath.section == 10) {
        cell.textLabel.text = NSLocalizedString(@"test.widget.border", nil);
    } else if (indexPath.section == 11) {
        cell.textLabel.text = NSLocalizedString(@"test.html", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 12) {
        cell.textLabel.text = NSLocalizedString(@"test.location", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 13) {
        cell.textLabel.text = NSLocalizedString(@"test.short.cut", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 14) {
        cell.textLabel.text = NSLocalizedString(@"test.debug.tool", nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self testColorConfig];
        } else if (indexPath.row == 1) {
            [self testWindowStyle];
        }
    } else if (indexPath.section == 1) {
        [self testNetwork];
    } else if (indexPath.section == 2) {
        [self testLog];
    } else if (indexPath.section == 3) {
        [self testCrash];
    } else if (indexPath.section == 4) {
        [self testAppInfo];
    } else if (indexPath.section == 5) {
        [self testSandbox];
    } else if (indexPath.section == 6) {
        [self testScreenshot];
    } else if (indexPath.section == 7) {
        [self testHierarchy];
    } else if (indexPath.section == 8) {
        [self testMagnifier];
    } else if (indexPath.section == 9) {
        [self testRuler];
    } else if (indexPath.section == 10) {
        [self testWidgetBorder];
    } else if (indexPath.section == 11) {
        [self testHtml];
    } else if (indexPath.section == 12) {
        [self testLocation];
    } else if (indexPath.section == 13) {
        [self testShortCut];
    } else if (indexPath.section == 14) {
        [self testStartWorking];
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"LLDebugConfig";
    } else if (section == 1) {
        return @"Network Request";
    } else if (section == 2) {
        return @"Log";
    } else if (section == 3) {
        return @"Crash";
    } else if (section == 4) {
        return @"App Info";
    } else if (section == 5) {
        return @"Sandbox Info";
    } else if (section == 6) {
        return @"Screen Shot";
    } else if (section == 7) {
        return @"Hierarchy";
    } else if (section == 8) {
        return @"Magnifier";
    } else if (section == 9) {
        return @"Ruler";
    } else if (section == 10) {
        return @"Widget Border";
    } else if (section == 11) {
        return @"Html";
    } else if (section == 12) {
        return @"Location";
    } else if (section == 13) {
        return @"Short Cut";
    } else if (section == 14) {
        return @"Action";
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
