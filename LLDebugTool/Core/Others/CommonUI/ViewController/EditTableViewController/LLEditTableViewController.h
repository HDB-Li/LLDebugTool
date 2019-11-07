//
//  LLEditTableViewController.h
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

#import "LLBaseTableViewController.h"

#import "LLTableViewSelectableDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// Editable table view controller.
@interface LLEditTableViewController : LLBaseTableViewController <UITableViewDataSource, UITextFieldDelegate>

/**
 * Whether use searchBar. Default is NO.
 */
@property (nonatomic, assign) BOOL isSearchEnable;

/**
 * Whether selectable. Default is NO.
 */
@property (nonatomic, assign) BOOL isSelectEnable;

/**
 * Whether shareable. Default is NO.
 */
@property (nonatomic, assign) BOOL isShareEnable;

/**
 * Whether deleteable. Default is NO.
 */
@property (nonatomic, assign) BOOL isDeleteEnable;

/**
 * Original data array.
 */
@property (nonatomic, strong, readonly) NSMutableArray<LLTableViewSelectableDelegate> *oriDataArray;

/**
 * Filter data array.
 */
@property (nonatomic, strong, readonly) NSMutableArray<LLTableViewSelectableDelegate> *searchDataArray;

@property (nonatomic, strong, readonly) NSMutableArray<LLTableViewSelectableDelegate> *datas;

/**
 * Header view use to show searchBar and filter view.
 */
@property (nonatomic, strong, nullable, readonly) UIView *headerView;

/**
 * The searchBar in view controller.
 */
@property (nonatomic, strong, nullable, readonly) UITextField *searchTextField;

/**
 * Select all item in toolbar.
 */
@property (nonatomic, strong, nullable, readonly) UIBarButtonItem *selectAllItem;

/**
 * Share item in toolbar.
 */
@property (nonatomic, strong, nullable, readonly) UIBarButtonItem *shareItem;

/**
 * Delete item in toolbar.
 */
@property (nonatomic, strong, nullable, readonly) UIBarButtonItem *deleteItem;

#pragma mark - Rewrite
/**
* Left item action.
*/
- (void)leftItemClick:(UIButton *)sender;

/**
 * Right item action. Must call super method.
 */
- (void)rightItemClick:(UIButton *)sender;

/**
 * Share files action. Must call super method.
 */
- (void)shareFilesWithIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

/**
 * Delete files action. Must call super method.
 */
- (void)deleteFilesWithIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

/**
 * Rewrite method to control whether is searching. Must call super method.
 */
- (BOOL)isSearching;

/**
 Called when text field's text did changed.
 */
- (void)textFieldDidChange:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
