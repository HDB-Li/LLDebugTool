//
//  LLFactoryTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLFactoryTests : LLCoreTestCase <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) CGRect frame;

@end

@implementation LLFactoryTests

- (void)setUp {
    self.frame = CGRectMake(0, 0, 1, 1);
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testView {
    UIView *view = [LLFactory getView];
    XCTAssertNotNil(view);
    
    UIView *lineView = [LLFactory getLineView:view frame:CGRectMake(0, 0, 1, 1)];
    XCTAssertNotNil(lineView);
    XCTAssertTrue(lineView.superview == view);
    XCTAssertTrue([lineView.backgroundColor isEqual:[LLThemeManager shared].primaryColor]);
    XCTAssertTrue(CGRectEqualToRect(lineView.frame, CGRectMake(0, 0, 1, 1)));
}

- (void)testLabel {
    UILabel *superview = [LLFactory getLabel];
    XCTAssertNotNil(superview);
    
    UILabel *label = [LLFactory getLabel:superview frame:self.frame text:@"text" font:10 textColor:[UIColor blueColor]];
    XCTAssertNotNil(label);
    XCTAssertTrue(label.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(label.frame, self.frame));
    XCTAssertTrue([label.text isEqualToString:@"text"]);
    XCTAssertTrue([label.font isEqual:[UIFont systemFontOfSize:10]]);
    XCTAssertTrue([label.textColor isEqual:[UIColor blueColor]]);
}

- (void)testTextField {
    UITextField *superview = [LLFactory getTextField];
    XCTAssertNotNil(superview);
}

- (void)testTextView {
    UITextView *superview = [LLFactory getTextView];
    XCTAssertNotNil(superview);
    
    UITextView *textView = [LLFactory getTextView:superview frame:self.frame delegate:self];
    XCTAssertNotNil(textView);
    XCTAssertTrue(textView.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(textView.frame, self.frame));
    XCTAssertTrue(textView.delegate == self);
}

- (void)testImageView {
    UIImageView *superview = [LLFactory getImageView];
    XCTAssertNotNil(superview);
    
    UIImage *image = [UIImage LL_imageNamed:kBackImageName];
    XCTAssertNotNil(image);
    
    UIImageView *imgView = [LLFactory getImageView:superview frame:self.frame image:image];
    XCTAssertNotNil(imgView);
    XCTAssertTrue(CGRectEqualToRect(imgView.frame, self.frame));
    XCTAssertTrue(imgView.image == image);
}

- (void)testButton {
    UIButton *superview = [LLFactory getButton];
    XCTAssertNotNil(superview);
    
    UIButton *button = [LLFactory getButton:superview frame:self.frame target:self action:@selector(testButton)];
    XCTAssertNotNil(button);
    XCTAssertTrue(button.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(button.frame, self.frame));
    XCTAssertTrue(button.allTargets.count == 1);
    NSString *selectorName = [[button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] firstObject];
    XCTAssertTrue([selectorName isEqualToString:NSStringFromSelector(_cmd)]);
}

- (void)testTableView {
    UITableView *superview = [LLFactory getTableView];
    XCTAssertNotNil(superview);
    
    UITableView *tableview = [LLFactory getTableView:superview frame:self.frame delegate:self style:UITableViewStyleGrouped];
    XCTAssertNotNil(tableview);
    XCTAssertTrue(tableview.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(tableview.frame, self.frame));
    XCTAssertTrue(tableview.delegate == self);
    XCTAssertTrue(tableview.dataSource == self);
    XCTAssertTrue(tableview.style == UITableViewStyleGrouped);
}

- (void)testCollectionView {
    UIView *superview = [LLFactory getView];
    XCTAssertNotNil(superview);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [LLFactory getCollectionView:superview layout:layout];
    XCTAssertNotNil(collectionView);
    XCTAssertTrue(collectionView.superview == superview);
}

- (void)testSegmentedControl {
    UISegmentedControl *superview = [LLFactory getSegmentedControl];
    XCTAssertNotNil(superview);
    
    NSArray *items = @[@"1", @"2"];
    UISegmentedControl *control = [LLFactory getSegmentedControl:superview frame:self.frame items:items];
    XCTAssertNotNil(control);
    XCTAssertTrue(control.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(control.frame, self.frame));
    XCTAssertTrue(control.numberOfSegments == 2);
    XCTAssertTrue([[control titleForSegmentAtIndex:1] isEqualToString:@"2"]);
}

- (void)testSwitch {
    UISwitch *swit = [LLFactory getSwitch];
    XCTAssertNotNil(swit);
}

- (void)testSlider {
    UISlider *slider = [LLFactory getSlider];
    XCTAssertNotNil(slider);
}

- (void)testScrollView {
    UIScrollView *scrollView = [LLFactory getScrollView];
    XCTAssertNotNil(scrollView);
}

- (void)testSearchBar {
    UISearchBar *bar = [LLFactory getSearchBar];
    XCTAssertNotNil(bar);
}

- (void)testPickerView {
    UIPickerView *superview = [LLFactory getPickerView];
    XCTAssertNotNil(superview);
    
    UIPickerView *picker = [LLFactory getPickerView:superview frame:self.frame delegate:self];
    XCTAssertNotNil(picker);
    XCTAssertTrue(picker.superview == superview);
    XCTAssertTrue(CGRectEqualToRect(picker.frame, self.frame));
    XCTAssertTrue(picker.delegate == self);
    XCTAssertTrue(picker.dataSource == self);
}

#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 0;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

@end
