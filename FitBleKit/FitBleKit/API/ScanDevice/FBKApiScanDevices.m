/********************************************************************************
 * 文件名称：FBKApiScanDevices.m
 * 内容摘要：扫描设备API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiScanDevices.h"

@implementation FBKApiScanDevices

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
    
    self.scanDevices = [[FBKBleScan alloc] init];
    self.scanDevices.delegate = self;
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startScanBleApi
 * 功能描述：开始查找蓝牙设备
 * 输入参数：UUIDArray-筛选条件   isRealTime-是否为即时数据
 * 返回数据：
 ********************************************************************************/
- (void)startScanBleApi:(NSArray *)UUIDArray isRealTimeDevice:(BOOL)isRealTime withRssi:(int)rssi
{
    [self.scanDevices startScanBleDevice:UUIDArray isRealTimeDevice:isRealTime withRssi:rssi];
}


/********************************************************************************
 * 方法名称：stopScanBleApi
 * 功能描述：停止查找蓝牙设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)stopScanBleApi
{
    [self.scanDevices stopScanBleDevice];
}


#pragma mark - **************************** 扫描回调 *****************************
/********************************************************************************
 * 方法名称：phoneBleStatus
 * 功能描述：手机蓝牙状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)phoneBleStatus:(BOOL)isPoweredOn
{
    [self.delegate phoneBleStatus:isPoweredOn];
}


/********************************************************************************
 * 方法名称：getDeviceList
 * 功能描述：设备列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceList:(NSArray *)deviceList
{
    [self.delegate getDeviceList:deviceList];
}


@end
