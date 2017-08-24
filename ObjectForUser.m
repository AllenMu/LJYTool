//
//  ObjectForUser.m
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/22.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import "ObjectForUser.h"

@implementation ObjectForUser

+(void)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headphoto"];
}

+(BOOL)checkLogin
{
    if (USERID == nil || TOKEN == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
