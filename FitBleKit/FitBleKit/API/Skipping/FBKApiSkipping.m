/********************************************************************************
 * 文件名称：FBKApiSkipping.m
 * 内容摘要：跳绳API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiSkipping.h"

@implementation FBKApiSkipping

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceType = BleDeviceSkipping;
    [self.managerController setManagerDeviceType:BleDeviceSkipping];
    
    return self;
}

#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    [self.delegate getSkipData:(NSDictionary *)resultData andDevice:self];
}


@end
