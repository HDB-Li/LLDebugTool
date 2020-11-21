//
//  NetTool.h
//  LLDebugToolDemo
//
//  Created by Li on 2018/5/30.
//  Copyright © 2018年 li. All rights reserved.
//

#import <AFNetworking.h>
#import <Foundation/Foundation.h>

@interface NetTool : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) AFURLSessionManager *afURLSessionManager;

@property (nonatomic, strong) AFHTTPSessionManager *afHTTPSessionManager;

@end
