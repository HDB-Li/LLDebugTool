//
//  ViewController.m
//  LLDebugToolDemo
//
//  Created by liuling on 2018/3/15.
//  Copyright © 2018年 li. All rights reserved.
//

#import "ViewController.h"
#import "LLDebug.h"
#import <AFNetworking.h>
#import "LLURLProtocol.h"

static NSString *const kCellID = @"cellID";

@interface ViewController () <UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // LLDebugTool need time to start.
    sleep(0.5);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"openCrash"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openCrash"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:2];
        });

    }
    
    //Network Request
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525346881086&di=b234c66c82427034962131d20e9f6b56&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F011cf15548caf50000019ae9c5c728.jpg%402o.jpg"]];
    [urlRequest setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                self.imgView.image = image;
            }
        });
    }];

    // Json Response
    [[AFHTTPSessionManager manager] GET:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    // Log
    LLog(NSLocalizedString(@"initial.log", nil));
}

#pragma mark - Actions
- (void)testNormalNetworkRequest {
    NSString *url = @"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600";
    
    // Use AFHttpSessionManager
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
    
    // Use AFURLSessionManager
    /*
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
     */
}

- (void)testImageNetworkRequest {
    //NSURLConnection
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525346881086&di=b234c66c82427034962131d20e9f6b56&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F011cf15548caf50000019ae9c5c728.jpg%402o.jpg"]];
    [urlRequest setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
}

- (void)testHTMLNetworkRequest {
    //NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
    [dataTask resume];
}

- (void)testNormalLog {
    LLog(NSLocalizedString(@"normal.log.info", nil));
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:1];
}

- (void)testErrorLog {
    LLog_Error(NSLocalizedString(@"error.log.info", nil));
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:1];
}

- (void)testEventLog {
    LLog_Error_Event(NSLocalizedString(@"call", nil),NSLocalizedString(@"call.log.info", nil));
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:1];
}

- (void)testArrayOutRangeCrash {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openCrash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *array = @[@"a",@"b"];
    __unused NSString *str = array[3];
}

- (void)testPointErrorCrash {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openCrash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *a = (NSArray *)@"dssdf";
    __unused NSString *b = [a firstObject];
}

- (void)testAppInfo {
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:3];
}

- (void)testSandbox {
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:4];
}

- (void)testColorStyle {
    [LLConfig sharedConfig].colorStyle = LLConfigColorStyleSystem;
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
}

- (void)testCustomColorConfig {
    [[LLConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
}

- (void)testSystemColorConfig {
    [LLConfig sharedConfig].useSystemColor = YES;
    [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }
    if (section == 5) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"normal.network", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"image.network", nil);
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"HTML.network", nil);
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"insert.log", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"insert.error.log", nil);
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"insert.call.log", nil);
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"try.array.crash", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"crash.info", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"try.pointer.crash", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"crash.info", nil);
        }
    } else if (indexPath.section == 3) {
        cell.textLabel.text = NSLocalizedString(@"app.info", nil);
    } else if (indexPath.section == 4) {
        cell.textLabel.text = NSLocalizedString(@"sandbox.info", nil);
    } else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"color.style", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"color.custom", nil);
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"color.none", nil);
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self testNormalNetworkRequest];
        } else if (indexPath.row == 1) {
            [self testImageNetworkRequest];
        } else if (indexPath.row == 2) {
            [self testHTMLNetworkRequest];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self testNormalLog];
        } else if (indexPath.row == 1) {
            [self testErrorLog];
        } else if (indexPath.row == 2) {
            [self testEventLog];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self testArrayOutRangeCrash];
        } else if (indexPath.row == 1) {
            [self testPointErrorCrash];
        }
    } else if (indexPath.section == 3) {
        [self testAppInfo];
    } else if (indexPath.section == 4) {
        [self testSandbox];
    } else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            [self testColorStyle];
        } else if (indexPath.row == 1) {
            [self testCustomColorConfig];
        } else if (indexPath.row == 2) {
            [self testSystemColorConfig];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Network Request";
    } else if (section == 1) {
        return @"Log";
    } else if (section == 2) {
        return @"Crash";
    } else if (section == 3) {
        return @"App Info";
    } else if (section == 4) {
        return @"Sandbox Info";
    } else if (section == 5) {
        return @"Config";
    }
    return nil;
}

@end
