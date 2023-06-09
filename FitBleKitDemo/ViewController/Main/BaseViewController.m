/************************************************************************************
 * 文件名称：BaseViewController.m
 * 内容摘要：基础页面
 * 版本编号：1.0.1
 * 创建日期：2019年07月29日
 ************************************************************************************/

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - ****************************** 系统方法 ********************************
/************************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
}


@end
