//
//  LLBaseViewController.h
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

#import <UIKit/UIKit.h>
#import "LLBaseModel.h"

@interface LLBaseViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate , UISearchBarDelegate>

/**
 * Whether use searchBar and searchController. Default is NO.
 */
@property (nonatomic , assign) BOOL isSearchEnable;

/**
 * Whether selectable. Default is NO.
 */
@property (nonatomic , assign) BOOL isSelectEnable;

@property (nonatomic , assign) BOOL isShareEnable;

@property (nonatomic , assign) BOOL isDeleteEnable;

/**
 * The default tableView.
 */
@property (nonatomic , strong , nonnull , readonly) UITableView *tableView;

@property (nonatomic , strong , nonnull , readonly) NSMutableArray *dataArray;

@property (nonatomic , strong , nonnull , readonly) NSMutableArray *searchDataArray;

@property (nonatomic , strong , nonnull , readonly) NSMutableArray *datas;

@property (nonatomic , strong , nullable , readonly) UIBarButtonItem *selectAllItem;

@property (nonatomic , strong , nullable , readonly) UIBarButtonItem *shareItem;

@property (nonatomic , strong , nullable , readonly) UIBarButtonItem *deleteItem;

/**
 * The searchController while use search.
 */
//@property (nonatomic , strong , nullable , readonly) UISearchController *searchController;

/**
 Initial method.
 */
- (instancetype _Nonnull)initWithStyle:(UITableViewStyle)style;
- (instancetype _Nonnull)init;// Default is UITableViewStyleGrouped.

/**
 * The searchBar of searchController.
 */
@property (nonatomic , strong , nullable , readonly) UISearchBar *searchBar;

/**
 * Simple toast.
 */
- (void)toastMessage:(NSString *_Nullable)message;

/**
 * Simple alert.
 */
- (void)showAlertControllerWithMessage:(NSString *_Nullable)message handler:(void (^_Nullable)(NSInteger action))handler;

#pragma mark - Rewrite
/**
 * Right item action.
 */
- (void)rightItemClick:(UIButton *)sender;
- (void)selectAllItemClick:(UIBarButtonItem *)sender;
- (void)shareItemClick:(UIBarButtonItem *)sender;
- (void)deleteItemClick:(UIBarButtonItem *)sender;
- (void)shareFilesWithIndexPaths:(NSArray *)indexPaths;
- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths;

@end
