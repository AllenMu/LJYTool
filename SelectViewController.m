//
//  SelectViewController.m
//  澳洲头条News
//
//  Created by 木丶阿伦 on 17/3/28.
//  Copyright © 2017年 youfeng. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择";
    [self tableViewInit];
}

-(void)tableViewInit
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrSelect.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *viewDown = [[UIView alloc]initWithFrame:CGRectMake(0, 49, WINDOWWIDTH, 1)];
        viewDown.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [cell addSubview:viewDown];
    }
    cell.textLabel.text = [self.arrSelect objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectViewControllerResult:[self.arrSelect objectAtIndex:indexPath.row] identifier:self.identifier];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
