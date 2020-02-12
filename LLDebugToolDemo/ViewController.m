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
#import "NetTool.h"
#import <Photos/PHPhotoLibrary.h>
#import <CoreLocation/CoreLocation.h>

#import "TestNetworkViewController.h"
#import "TestLogViewController.h"
#import "TestCrashViewController.h"
#import "TestColorStyleViewController.h"
#import "TestWindowStyleViewController.h"
#import "TestHierarchyViewController.h"
#import "TestHtmlViewController.h"
#import "TestLocationViewController.h"
#import "TestShortCutViewController.h"

#import "LLStorageManager.h"

static NSString *const kCellID = @"cellID";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // LLDebugTool need time to start.
    sleep(0.5);
    [self doSomeActions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Primary
- (void)doSomeActions {
    [self requestPhotoAuthorization];
    [self requestLocationAuthorization];
    [self doSandboxIfNeeded];
    [self doCrashIfNeeded];
    [self doNetwork];
    [self doLog];
}

- (void)requestPhotoAuthorization {
    // Try to get album permission, and if possible, screenshots are stored in the album at the same time.
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
    }];
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
        NSArray *extensions = @[@"html", @"pdf", @"docx", @"doc", @"pages", @"txt", @"md", @"xlsx", @"xls", @"numbers", @"json", @"plist", @"jpeg", @"png", @"mp4", @"mp3", @"gif"];
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
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject];
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"LLDebugTool.%@",extension]];
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
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                weakSelf.imgView.image = image;
            }
        });
    }];
#pragma clang diagnostic pop
    
    // Json Response
    [[NetTool shared].afHTTPSessionManager GET:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //NSURLSession
    NSMutableURLRequest *htmlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://cocoapods.org/pods/LLDebugTool"]];
    [htmlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [[NetTool shared].session dataTaskWithRequest:htmlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Not important. Just check to see if the current Demo version is consistent with the latest version.
        // 只是检查一下当前Demo版本和最新版本是否一致，不一致就提示一下新版本。
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array = [htmlString componentsSeparatedByString:@"http://cocoadocs.org/docsets/LLDebugTool/"];
        if (array.count > 2) {
            NSString *str = array[1];
            NSArray *array2 = [str componentsSeparatedByString:@"/preview.png"];
            if (array2.count >= 2) {
                NSString *newVersion = array2[0];
                if ([newVersion componentsSeparatedByString:@"."].count == 3) {
                    if ([[LLDebugTool versionNumber] compare:newVersion] == NSOrderedAscending) {
                        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Note" message:[NSString stringWithFormat:@"%@\nNew Version : %@\nCurrent Version : %@",NSLocalizedString(@"new.version", nil),newVersion,[LLDebugTool versionNumber]] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"I known" style:UIAlertActionStyleDefault handler:nil];
                        [vc addAction:action];
                        [self presentViewController:vc animated:YES completion:nil];
                    }
                }
            }
        }
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

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 14;
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
            switch ([LLConfig shared].colorStyle) {
                case LLConfigColorStyleHack:{
                    cell.detailTextLabel.text = @"LLConfigColorStyleHack";
                }
                    break;
                case LLConfigColorStyleSimple:{
                    cell.detailTextLabel.text = @"LLConfigColorStyleSimple";
                }
                    break;
                case LLConfigColorStyleSystem:{
                    cell.detailTextLabel.text = @"LLConfigColorStyleSystem";
                }
                    break;
                case LLConfigColorStyleGrass: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleGrass";
                }
                    break;
                case LLConfigColorStyleHomebrew: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleHomebrew";
                }
                    break;
                case LLConfigColorStyleManPage: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleManPage";
                }
                    break;
                case LLConfigColorStyleNovel: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleNovel";
                }
                    break;
                case LLConfigColorStyleOcean: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleOcean";
                }
                    break;
                case LLConfigColorStylePro: {
                    cell.detailTextLabel.text = @"LLConfigColorStylePro";
                }
                    break;
                case LLConfigColorStyleRedSands: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleRedSands";
                }
                    break;
                case LLConfigColorStyleSilverAerogel: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleSilverAerogel";
                }
                    break;
                case LLConfigColorStyleSolidColors: {
                    cell.detailTextLabel.text = @"LLConfigColorStyleSolidColors";
                }
                    break;
                case LLConfigColorStyleCustom:{
                    cell.detailTextLabel.text = @"LLConfigColorStyleCustom";
                }
                    break;
            }
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"test.window.style", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch ([LLConfig shared].entryWindowStyle) {
                case LLConfigEntryWindowStyleBall:{
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStyleBall";
                }
                    break;
                case LLConfigEntryWindowStyleTitle:{
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStyleTitle";
                }
                    break;
                case LLConfigEntryWindowStyleLeading: {
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStyleLeading";
                }
                    break;
                case LLConfigEntryWindowStyleTrailing: {
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStyleTrailing";
                }
                    break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                case LLConfigEntryWindowStylePowerBar:{
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStylePowerBar";
                }
                    break;
                case LLConfigEntryWindowStyleNetBar:{
                    cell.detailTextLabel.text = @"LLConfigEntryWindowStyleNetBar";
                }
                    break;
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
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"LLConfig";
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
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
