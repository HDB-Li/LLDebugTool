//
//  LLImageNameConfigTests.m
//  LLDebugTool_Tests
//
//  Created by liuling on 2020/10/8.
//  Copyright © 2020 HDB-Li. All rights reserved.
//

#import "LLCoreTestCase.h"

@interface LLImageNameConfigTests : LLCoreTestCase

@end

@implementation LLImageNameConfigTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testImageName {
    NSBundle *bundle = [LLDebugConfig shared].imageBundle;
    XCTAssertNotNil(bundle);
    NSArray *array = [bundle pathsForResourcesOfType:@"png" inDirectory:nil];
    XCTAssertTrue(array.count == 77 * 2);
    XCTAssertNotNil([UIImage LL_imageNamed:kCrashImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kNetworkImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLogImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kAppImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kScreenshotImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kHierarchyImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kMagnifierImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRulerImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kWidgetBorderImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kHtml5ImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLocationImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kShortCutImageName]);

    // Navigation Item Icon
    XCTAssertNotNil([UIImage LL_imageNamed:kClearImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kCloseImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kEditImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kDoneImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kBackImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kFilterImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kShareImageName]);

    // Folder
    XCTAssertNotNil([UIImage LL_imageNamed:kFolderImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kEmptyFolderImageName]);

    // Draw   0x148816
    XCTAssertNotNil([UIImage LL_imageNamed:kCancelImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLineImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLineSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kPenImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kPenSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRectSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRoundImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRoundSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSureImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kTextImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kTextSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kUndoImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kUndoDisableImageName]);

    // Selector
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorTriangleImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorSmallImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorSmallSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorMediumImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorMediumSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorBigImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorBigSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorRedImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorBlueImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorGreenImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorYellowImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorGrayImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectorWhiteImageName]);

    // Sandbox File Type Icon
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileUnknownImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileAviImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileCssImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileDocImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileGifImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileHtmlImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileJpgImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileJsImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileMovImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileMp3ImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFilePdfImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFilePngImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileSqlImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileWavImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileXlsImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileZipImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileFolderImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSandboxFileEmptyFolderImageName]);

    // Common 2c2c2c
    XCTAssertNotNil([UIImage LL_imageNamed:kLeftImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kRightImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kTopImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kBottomImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLogoImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSelectImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kUnselectImageName]);

    // Hierarchy
    XCTAssertNotNil([UIImage LL_imageNamed:kParentImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kSubviewImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kLevelImageName]);
    XCTAssertNotNil([UIImage LL_imageNamed:kInfoImageName]);

    // Screenshot
    XCTAssertNotNil([UIImage LL_imageNamed:kCaptureImageName]);
    
    
    // TabBar Icon 0xBDBDBD
    XCTAssertTrue([kCrashImageName isEqualToString:@"crash"]);
    XCTAssertTrue([kNetworkImageName isEqualToString:@"network"]);
    XCTAssertTrue([kLogImageName isEqualToString:@"log"]);
    XCTAssertTrue([kAppImageName isEqualToString:@"app"]);
    XCTAssertTrue([kSandboxImageName isEqualToString:@"sandbox"]);
    XCTAssertTrue([kScreenshotImageName isEqualToString:@"screenshot"]);
    XCTAssertTrue([kHierarchyImageName isEqualToString:@"hierarchy"]);
    XCTAssertTrue([kMagnifierImageName isEqualToString:@"magnifier"]);
    XCTAssertTrue([kRulerImageName isEqualToString:@"ruler"]);
    XCTAssertTrue([kWidgetBorderImageName isEqualToString:@"widget-border"]);
    XCTAssertTrue([kHtml5ImageName isEqualToString:@"html5"]);
    XCTAssertTrue([kLocationImageName isEqualToString:@"location"]);
    XCTAssertTrue([kShortCutImageName isEqualToString:@"short-cut"]);

    // Navigation Item Icon
    XCTAssertTrue([kClearImageName isEqualToString:@"clear"]);
    XCTAssertTrue([kCloseImageName isEqualToString:@"close"]);
    XCTAssertTrue([kEditImageName isEqualToString:@"edit"]);
    XCTAssertTrue([kDoneImageName isEqualToString:@"done"]);
    XCTAssertTrue([kBackImageName isEqualToString:@"back"]);
    XCTAssertTrue([kFilterImageName isEqualToString:@"filter"]);
    XCTAssertTrue([kShareImageName isEqualToString:@"share"]);

    // Folder
    XCTAssertTrue([kFolderImageName isEqualToString:@"folder"]);
    XCTAssertTrue([kEmptyFolderImageName isEqualToString:@"folder-empty"]);

    // Draw   0x148816
    XCTAssertTrue([kCancelImageName isEqualToString:@"cancel"]);
    XCTAssertTrue([kLineImageName isEqualToString:@"line"]);
    XCTAssertTrue([kLineSelectImageName isEqualToString:@"line-select"]);
    XCTAssertTrue([kPenImageName isEqualToString:@"pen"]);
    XCTAssertTrue([kPenSelectImageName isEqualToString:@"pen-select"]);
    XCTAssertTrue([kRectImageName isEqualToString:@"rect"]);
    XCTAssertTrue([kRectSelectImageName isEqualToString:@"rect-select"]);
    XCTAssertTrue([kRoundImageName isEqualToString:@"round"]);
    XCTAssertTrue([kRoundSelectImageName isEqualToString:@"round-select"]);
    XCTAssertTrue([kSureImageName isEqualToString:@"sure"]);
    XCTAssertTrue([kTextImageName isEqualToString:@"text"]);
    XCTAssertTrue([kTextSelectImageName isEqualToString:@"text-select"]);
    XCTAssertTrue([kUndoImageName isEqualToString:@"undo"]);
    XCTAssertTrue([kUndoDisableImageName isEqualToString:@"undo-disable"]);

    // Selector
    XCTAssertTrue([kSelectorTriangleImageName isEqualToString:@"selector-triangle"]);
    XCTAssertTrue([kSelectorSmallImageName isEqualToString:@"selector-small"]);
    XCTAssertTrue([kSelectorSmallSelectImageName isEqualToString:@"selector-small-select"]);
    XCTAssertTrue([kSelectorMediumImageName isEqualToString:@"selector-medium"]);
    XCTAssertTrue([kSelectorMediumSelectImageName isEqualToString:@"selector-medium-select"]);
    XCTAssertTrue([kSelectorBigImageName isEqualToString:@"selector-big"]);
    XCTAssertTrue([kSelectorBigSelectImageName isEqualToString:@"selector-big-select"]);
    XCTAssertTrue([kSelectorRedImageName isEqualToString:@"selector-red"]);
    XCTAssertTrue([kSelectorBlueImageName isEqualToString:@"selector-blue"]);
    XCTAssertTrue([kSelectorGreenImageName isEqualToString:@"selector-green"]);
    XCTAssertTrue([kSelectorYellowImageName isEqualToString:@"selector-yellow"]);
    XCTAssertTrue([kSelectorGrayImageName isEqualToString:@"selector-gray"]);
    XCTAssertTrue([kSelectorWhiteImageName isEqualToString:@"selector-white"]);

    // Sandbox File Type Icon
    XCTAssertTrue([kSandboxFileUnknownImageName isEqualToString:@"unknown"]);
    XCTAssertTrue([kSandboxFileAviImageName isEqualToString:@"avi"]);
    XCTAssertTrue([kSandboxFileCssImageName isEqualToString:@"css"]);
    XCTAssertTrue([kSandboxFileDocImageName isEqualToString:@"doc"]);
    XCTAssertTrue([kSandboxFileGifImageName isEqualToString:@"gif"]);
    XCTAssertTrue([kSandboxFileHtmlImageName isEqualToString:@"html"]);
    XCTAssertTrue([kSandboxFileJpgImageName isEqualToString:@"jpg"]);
    XCTAssertTrue([kSandboxFileJsImageName isEqualToString:@"js"]);
    XCTAssertTrue([kSandboxFileMovImageName isEqualToString:@"mov"]);
    XCTAssertTrue([kSandboxFileMp3ImageName isEqualToString:@"mp3"]);
    XCTAssertTrue([kSandboxFilePdfImageName isEqualToString:@"pdf"]);
    XCTAssertTrue([kSandboxFilePngImageName isEqualToString:@"png"]);
    XCTAssertTrue([kSandboxFileSqlImageName isEqualToString:@"sql"]);
    XCTAssertTrue([kSandboxFileWavImageName isEqualToString:@"wav"]);
    XCTAssertTrue([kSandboxFileXlsImageName isEqualToString:@"xls"]);
    XCTAssertTrue([kSandboxFileZipImageName isEqualToString:@"zip"]);
    XCTAssertTrue([kSandboxFileFolderImageName isEqualToString:@"folder"]);
    XCTAssertTrue([kSandboxFileEmptyFolderImageName isEqualToString:@"folder-empty"]);

    // Common 2c2c2c
    XCTAssertTrue([kLeftImageName isEqualToString:@"left"]);
    XCTAssertTrue([kRightImageName isEqualToString:@"right"]);
    XCTAssertTrue([kTopImageName isEqualToString:@"top"]);
    XCTAssertTrue([kBottomImageName isEqualToString:@"bottom"]);
    XCTAssertTrue([kLogoImageName isEqualToString:@"logo"]);
    XCTAssertTrue([kSelectImageName isEqualToString:@"select"]);
    XCTAssertTrue([kUnselectImageName isEqualToString:@"unselect"]);

    // Hierarchy
    XCTAssertTrue([kParentImageName isEqualToString:@"parent"]);
    XCTAssertTrue([kSubviewImageName isEqualToString:@"subview"]);
    XCTAssertTrue([kLevelImageName isEqualToString:@"level"]);
    XCTAssertTrue([kInfoImageName isEqualToString:@"info"]);

    // Screenshot
    XCTAssertTrue([kCaptureImageName isEqualToString:@"capture"]);
}

@end
