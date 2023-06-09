/********************************************************************************
 * 文件名称：FBKBleScan.h
 * 内容摘要：扫描蓝牙设备
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol FBKBleScanDelegate <NSObject>

// 手机蓝牙状态
- (void)phoneBleStatus:(BOOL)isPoweredOn;

// 设备列表
- (void)getDeviceList:(NSArray *)deviceList;

@end


@interface FBKBleScan : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

// 协议
@property(assign,nonatomic)id <FBKBleScanDelegate> delegate;

// 开始查找蓝牙设备
- (void)startScanBleDevice:(NSArray *)UUIDArray isRealTimeDevice:(BOOL)isRealTime withRssi:(int)rssi;

// 停止查找蓝牙设备
- (void)stopScanBleDevice;

@end

