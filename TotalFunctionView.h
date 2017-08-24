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
+(void)alertAndDoneWithContent:(NSString *)strContent onViewController:(UIViewController *)viewController;
@end
