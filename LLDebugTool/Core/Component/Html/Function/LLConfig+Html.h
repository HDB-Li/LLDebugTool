//
//  LLConfig+Html.h
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

#import "LLConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLConfig (Html)

/**
 Default html5 url string used in Html function. must has prefix with http:// or https://
 */
@property (nonatomic, copy, nullable) NSString *defaultHtmlUrl;

/**
 Custom view controller used in html function. you can use your custom viewController to dynamic debug your web view. must comply with `LLComponentDelegate`. ViewController must set background color.
 */
@property (nonatomic, copy, nullable) UIViewController *(^htmlViewControllerProvider)(NSString * _Nullable url);

@end

NS_ASSUME_NONNULL_END
