//
//  TestNetworkViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2018/8/29.
//  Copyright © 2018年 li. All rights reserved.
//

#import "TestNetworkViewController.h"
#import "NetTool.h"
#import "LLDebugTool.h"

static NSString *const kCellID = @"cellID";

@interface TestNetworkViewController ()

@end

@implementation TestNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.network.request", nil);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"normal.network", nil);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"normal.session.network", nil);
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"image.network", nil);
    } else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"HTML.network", nil);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testNormalNetworkRequest];
    } else if (indexPath.row == 1) {
        [self testNormalSessionNetworkRequest];
    } else if (indexPath.row == 2) {
        [self testImageNetworkRequest];
    } else if (indexPath.row == 3) {
        [self testHTMLNetworkRequest];
    }
}

#pragma mark - Actions
- (void)testNormalNetworkRequest {
    NSString *url = @"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600";
    
    // Use AFHttpSessionManager
    [[NetTool sharedTool].afHTTPSessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
}

- (void)testNormalSessionNetworkRequest {
    NSString *url = @"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?&format=json&appid=379020&bk_key=%E7%81%AB%E5%BD%B1%E5%BF%8D%E8%80%85&bk_length=600";
    
    // Use AFURLSessionManager
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *task = [[NetTool sharedTool].afURLSessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
    [task resume];
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
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [[NetTool sharedTool].session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[LLDebugTool sharedTool] showDebugViewControllerWithIndex:0];
    }];
    [dataTask resume];
}

@end
