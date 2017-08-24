//
//  SelectViewController.h
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/28.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController

@property(retain,nonatomic)NSArray *arrSelect;
@property(assign,nonatomic)id delegate;
@property(assign,nonatomic)NSInteger identifier;


@end

@protocol SelectViewControllerDelegate <NSObject>
@required
-(void)selectViewControllerResult:(NSString *)selectResult identifier:(NSInteger)identifier;

@end
