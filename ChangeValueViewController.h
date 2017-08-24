//
//  ChangeValueViewController.h
//  UniTrader
//
//  Created by 木丶阿伦 on 17/1/14.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeValueViewController : UIViewController

@property(nonatomic,copy)NSString *strTitle;
@property(nonatomic,copy)NSString *strPlacehoder;
@property(nonatomic,assign)NSInteger identifier;
@property(nonatomic,assign)id delegate;
@property(nonatomic,copy)NSString *strContent;

@end

@protocol  ChangeValueViewControllerDelegate<NSObject>

-(void)valueChangeToString:(NSString *)toString identifier:(NSInteger)identifier;

@end
