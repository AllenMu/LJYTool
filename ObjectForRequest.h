//
//  ObjectForRequest.h
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/22.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectForRequest : NSObject

+(ObjectForRequest *)shareObject;

-(void)POSTWithURLString:(NSString *)urlStr Parameters:(NSDictionary *)paraDic resultBlock:(void(^)(NSDictionary *resultDic))resultBlock;
-(void)POSTWithTotalURLString:(NSString *)urlStr Parameters:(NSDictionary *)paraDic resultBlock:(void(^)(NSDictionary *resultDic))resultBlock;
-(void)requestToPostImagesWithURLString:(NSString *)urlStr images:(NSArray *)arrImages Parameters:(NSDictionary *)paraDic resultBlock:(void(^)(NSDictionary *resultDic))resultBlock;

-(void)GetWithURLString:(NSString *)urlStr resultBlock:(void(^)(NSDictionary *resultDic))resultBlock;

-(void)GetWithTotalURLString:(NSString *)urlStr para:(NSDictionary *)para resultBlock:(void(^)(NSDictionary *resultDic))resultBlock;

@end
