/********************************************************************************
 * 文件名称：FBKApiScanDevices.h
 * 内容摘要：扫描设备API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKBleScan.h"

@protocol FBKApiScanDevicesDelegate <NSObject>

// 手机蓝牙状态
- (void)phoneBleStatus:(BOOL)isPoweredOn;

// 设备列表
- (void)getDeviceList:(NSArray *)deviceList;

@end


@interface FBKApiScanDevices : NSObject<FBKBleScanDelegate>

// 协议
@property(assign,nonatomic)id <FBKApiScanDevicesDelegate> delegate;

// 搜索调度类
@property (strong,nonatomic) FBKBleScan *scanDevices;

// 开始查找蓝牙设备
- (void)startScanBleApi:(NSArray *)UUIDArray isRealTimeDevice:(BOOL)isRealTime withRssi:(int)rssi;

// 停止查找蓝牙设备
- (void)stopScanBleApi;

@end
