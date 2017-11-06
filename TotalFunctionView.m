//
//  TotalFunctionView.m
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/22.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import "TotalFunctionView.h"

#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import <sys/utsname.h>


@implementation TotalFunctionView


+(void)alertContent:(NSString *)strContent onViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:strContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:^{
        nil;
    }];
}

+(void)alertAndPopWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:strContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:^{
        nil;
    }];
}
+(void)alertAndDismissWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:strContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:^{
        nil;
    }];
}

+(UIImage *)imageWithBase64String:(NSString *)strBase64
{
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:strBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}



//获取转换文件所在文件夹
+ (NSString *)getRecPathUrl{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *recordDir = [str stringByAppendingPathComponent:@"RecordCourse"];
    
    return recordDir;
}


//获取时间戳用于文件的命名
+(NSString *)getTimestamp{
    NSDate *nowDate = [NSDate date];
    double timestamp = (double)[nowDate timeIntervalSince1970]*1000;
    long nowTimestamp = [[NSNumber numberWithDouble:timestamp] longValue];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld",nowTimestamp];
    return timestampStr;
}
//PCM转换MP3配置
+(NSDictionary *)getAudioSettingWithPCM {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //设置录音格式
    [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dic setObject:@(44100.0) forKey:AVSampleRateKey];
    //设置通道,这里采用双声道
    [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dic setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dic;
}
//CAF转换MP3配置
+ (NSDictionary *)getAudioSettingWithCAF {
    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:AVAudioQualityMin],
                             AVEncoderAudioQualityKey,
                             [NSNumber numberWithInt:16],
                             AVEncoderBitRateKey,
                             [NSNumber numberWithInt:2],
                             AVNumberOfChannelsKey,
                             [NSNumber numberWithFloat:44100.0],
                             AVSampleRateKey,
                             nil];
    
    return setting;
}

//PCM转换MP3的lame方法
+ (NSString *)audioPCMtoMP3:(NSString *)wavPath
{
    NSString *cafFilePath = wavPath;
    
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@.mp3",[NSString stringWithFormat:@"%@%@",[cafFilePath substringToIndex:cafFilePath.length - 4],[self getTimestamp]]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除原MP3文件");
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
    }
}
//CAF转换MP3的lame方法
+ (NSString *)audioCAFtoMP3:(NSString *)wavPath {
    
    NSString *cafFilePath = wavPath;
    
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@.mp3",[NSString stringWithFormat:@"%@%@",[cafFilePath substringToIndex:cafFilePath.length - 4],[self getTimestamp]]];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,8);
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
    }
}

+(void)addFileToListWithInfo:(NSDictionary *)dicInfo filePath:(NSString *)strFilePath
{
    NSMutableDictionary *dicFiles = [[NSMutableDictionary alloc]initWithDictionary:DICDOWNLOADFILES];
    NSMutableArray *arrFiles = [[NSMutableArray alloc]initWithArray:ARRDOWNLOADFILES];
    
    NSMutableDictionary *dicInfoNew = [[NSMutableDictionary alloc]initWithDictionary:dicInfo];
    [dicInfoNew setObject:strFilePath forKey:@"localpath"];
    
    [dicFiles setObject:dicInfoNew forKey:dicInfo[@"id"]];
    if (![arrFiles containsObject:dicInfo[@"id"]])
    {
        [arrFiles addObject:dicInfo[@"id"]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arrFiles forKey:@"arrdownloadfiles"];
    [[NSUserDefaults standardUserDefaults] setObject:dicFiles forKey:@"dicdownloadfiles"];
    
}
+(void)DeleteFileFromListWithID:(NSString *)strID
{
    if (DICDOWNLOADFILES == nil)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dicdownloadfiles"];
    }
    if (ARRDOWNLOADFILES == nil)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"arrdownloadfiles"];
    }
    NSMutableDictionary *dicFiles = [[NSMutableDictionary alloc]initWithDictionary:DICDOWNLOADFILES];
    NSMutableArray *arrFiles = [[NSMutableArray alloc]initWithArray:ARRDOWNLOADFILES];
    
    [arrFiles removeObject:strID];
    [dicFiles removeObjectForKey:strID];
    
    [[NSUserDefaults standardUserDefaults] setObject:arrFiles forKey:@"arrdownloadfiles"];
    [[NSUserDefaults standardUserDefaults] setObject:dicFiles forKey:@"dicdownloadfiles"];
}
+(BOOL)FileListContainFileID:(NSString *)strID
{
    NSArray *arrFiles = ARRDOWNLOADFILES;

    return [arrFiles containsObject:strID];
}
+(void)addContentToSearchList:(NSString *)str
{
    if (ARRSEARCHTITLE == nil)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"arrsearchtitle"];
    }
    NSMutableArray *arrSearchTitle = [[NSMutableArray alloc]initWithArray:ARRSEARCHTITLE];
    [arrSearchTitle insertObject:str atIndex:0];
    
    while (arrSearchTitle.count > 10)
    {
        [arrSearchTitle removeLastObject];
    }

    [[NSUserDefaults standardUserDefaults] setObject:arrSearchTitle forKey:@"arrsearchtitle"];

    
}
+(NSArray *)fileTitleSearched
{
    if (ARRSEARCHTITLE == nil)
    {
        return @[];
    }
    else
    {
        return ARRSEARCHTITLE;
    }

}
+(NSString*)iphoneType
{
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"])return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"])return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"])return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"])return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])return@"iPhone Simulator";
    
    return platform;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
