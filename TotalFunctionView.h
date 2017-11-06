//
//  TotalFunctionView.h
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/22.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalFunctionView : UIView


+(void)alertContent:(NSString *)strContent onViewController:(UIViewController *)viewController;
+(void)alertAndPopWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController;
+(void)alertAndDismissWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController;
+(UIImage *)imageWithBase64String:(NSString *)strBase64;

//录音转换
//获取转换文件所在文件夹
+ (NSString *)getRecPathUrl;

//获取时间戳用于文件的命名
+(NSString *)getTimestamp;

//PCM转换MP3配置
+(NSDictionary *)getAudioSettingWithPCM;

//CAF转换MP3配置
+ (NSDictionary *)getAudioSettingWithCAF;

//PCM转换MP3的lame方法
+ (NSString *)audioPCMtoMP3:(NSString *)wavPath;

//CAF转换MP3的lame方法
+ (NSString *)audioCAFtoMP3:(NSString *)wavPath;

//记录本地下载文件
+(void)addFileToListWithInfo:(NSDictionary *)dicInfo filePath:(NSString *)strFilePath;

//删除本地下载文件记录
+(void)DeleteFileFromListWithID:(NSString *)strID;

//判断列表是否已经记录某个文件id
+(BOOL)FileListContainFileID:(NSString *)strID;

//增加搜索记录
+(void)addContentToSearchList:(NSString *)str;

//获取搜索记录内容
+(NSArray *)fileTitleSearched;

//手机型号
+(NSString*)iphoneType;


@end
