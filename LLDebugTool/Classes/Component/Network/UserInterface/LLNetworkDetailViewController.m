//
//  LLNetworkDetailViewController.m
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

#import "LLNetworkDetailViewController.h"

#import "LLDebugConfig.h"
#import "LLInternalMacros.h"
#import "LLNetworkImageCell.h"
#import "LLNetworkModel.h"
#import "LLSubTitleTableViewCell.h"
#import "LLToastUtils.h"

#import "NSDictionary+LL_Utils.h"
#import "UIImage+LL_Utils.h"

static NSString *const kNetworkContentCellID = @"NetworkContentCellID";
static NSString *const kNetworkImageCellID = @"NetworkImageCellID";

@interface LLNetworkDetailViewController () <UITableViewDataSource, LLSubTitleTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSArray *canCopyArray;

@end

@implementation LLNetworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"network.detail");
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LLNetworkImageCell class] forCellReuseIdentifier:kNetworkImageCellID];
    [self.tableView registerClass:[LLSubTitleTableViewCell class] forCellReuseIdentifier:kNetworkContentCellID];
    [self loadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.contentArray[indexPath.row];
    // Config Image
    if ([obj isKindOfClass:[NSData class]] && self.model.isImage) {
        LLNetworkImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkImageCellID forIndexPath:indexPath];
        if (self.model.isGif) {
            [cell setUpImage:[UIImage LL_imageWithGIFData:obj]];
        } else {
            [cell setUpImage:[UIImage imageWithData:obj]];
        }
        return cell;
    }
    if ([obj isKindOfClass:[NSData class]]) {
        obj = [self convertDataToHexStr:obj];
    }

    LLSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkContentCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentText = obj;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titleArray[indexPath.row];
    if ([self.canCopyArray containsObject:title]) {
        id obj = self.contentArray[indexPath.row];
        if ([obj isKindOfClass:[NSData class]] && self.model.isImage) {
            UIImage *image = nil;
            if (self.model.isGif) {
                image = [UIImage LL_imageWithGIFData:obj];
            } else {
                image = [UIImage imageWithData:obj];
            }
            if ([image isKindOfClass:[UIImage class]]) {
                [[UIPasteboard generalPasteboard] setImage:image];
                [[LLToastUtils shared] toastMessage:[NSString stringWithFormat:LLLocalizedString(@"copy.success"), title]];
            }
        } else if ([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSString class]]) {
            if ([obj isKindOfClass:[NSData class]]) {
                obj = [self convertDataToHexStr:obj];
            }
            [[UIPasteboard generalPasteboard] setString:obj];
            [[LLToastUtils shared] toastMessage:[NSString stringWithFormat:LLLocalizedString(@"copy.success"), title]];
        }
    }
}

#pragma mark - LLSubTitleTableViewCellDelegate
- (void)LLSubTitleTableViewCell:(LLSubTitleTableViewCell *)cell didSelectedContentView:(UITextView *)contentTextView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Primary
- (void)loadData {
    if (self.model) {
        self.titleArray = [[NSMutableArray alloc] init];
        self.contentArray = [[NSMutableArray alloc] init];

        // Request url.
        [self loadTitle:@"Request Url" value:self.model.url.absoluteString ?: @"unknown"];

        // Method.
        [self loadTitle:@"Method" value:self.model.method];

        // Status code.
        [self loadTitle:@"Status Code" value:self.model.statusCode ?: @"0"];

        // Header
        [self loadTitle:@"Header Fields" value:self.model.headerFields.LL_displayString];

        // Request body.
        [self loadTitle:@"Request Body" value:self.model.requestBody ?: @"Null"];

        // Response data.
        if (self.model.responseData) {
            [self.titleArray addObject:@"Response Body"];
            if (self.model.isImage) {
                [self.contentArray addObject:self.model.responseData];
            } else {
                [self.contentArray addObject:self.model.responseString.length ? self.model.responseString : self.model.responseData];
            }
        }

        // Error
        [self loadTitle:@"Error" value:self.model.error.localizedDescription];

        // Mime type.
        [self loadTitle:@"Mime Type" value:self.model.mimeType];

        // Start date.
        [self loadTitle:@"Start Date" value:self.model.startDate];

        // Total duration.
        [self loadTitle:@"Total Duration" value:self.model.totalDuration];

        // Total data traffic.
        [self loadTitle:@"Data Traffic" value:self.model.totalDataTraffic ? [NSString stringWithFormat:@"%@ (%@↑ / %@↓)", self.model.totalDataTraffic, self.model.requestDataTraffic, self.model.responseDataTraffic] : nil];
    }
}

- (void)loadTitle:(NSString *)title value:(NSString *)value {
    if (title && value) {
        [self.titleArray addObject:title];
        [self.contentArray addObject:value];
    }
}

- (NSArray *)canCopyArray {
    if (!_canCopyArray) {
        _canCopyArray = @[@"Request Url", @"Error", @"Header Fields", @"Request Body", @"Response Body"];
    }
    return _canCopyArray;
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char *)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

@end
