//
//  TotalFunctionView.m
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/22.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import "TotalFunctionView.h"

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

+(void)alertAndDoneWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController
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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
