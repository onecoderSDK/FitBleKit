/********************************************************************************
 * 文件名称：FBKDeviceNewScale.m
 * 内容摘要：新秤
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKDeviceNewScale.h"

@implementation FBKDeviceNewScale

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.stableDictionary = [[NSMutableDictionary alloc] init];
    self.recordArray = [[NSMutableArray alloc] init];
    
    return self;
}

@end

