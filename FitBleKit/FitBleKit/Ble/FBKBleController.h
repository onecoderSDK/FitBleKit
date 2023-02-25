/********************************************************************************
 * 文件名称：FBKBleController.h
 * 内容摘要：蓝牙通讯
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#define   FBKLOGDATAINFO  // 是否打印蓝牙交互的数据信息
#define   FBKWRITENOTIFICATION   @"FBKWriteNotification" // 写入的数据通知
#define   FBKDATANOTIFICATION    @"FBKDataNotification"  // 得到的数据通知

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FBKEnumList.h"

@protocol FBKBleControllerDelegate <NSObject>

// 蓝牙连接失败信息
- (void)bleConnectError:(id)errorInfo andDeviceType:(BleDeviceType)type;

// 蓝牙连接状态
- (void)bleConnectStatus:(DeviceBleStatus)status andDeviceType:(BleDeviceType)type;

// 蓝牙写入状态
- (void)bleConnectWriteStatus:(BOOL)Succeed andDeviceType:(BleDeviceType)type;

// 蓝牙结果数据
- (void)bleConnectByteData:(CBCharacteristic *)characteristic andDeviceType:(BleDeviceType)type;

// 蓝牙UUID数据
- (void)bleConnectUuids:(NSArray *)charUuidArray andDeviceType:(BleDeviceType)type;

// 蓝牙LOG
- (void)bleConnectLog:(NSString *)logString andDevice:(id)device;

@end


@interface FBKBleController : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

// 协议
@property(assign,nonatomic)id <FBKBleControllerDelegate> delegate;

// 蓝牙名称
@property(strong,nonatomic) NSString *deviceName;

// 开始连接蓝牙设备
- (void)startConnectBleDevice:(NSArray *)UUIDArray withDeviceId:(NSString *)deviceId andDeviceType:(BleDeviceType)type compareWithIdType:(DeviceIdType)idType;

// 断开蓝牙连接
- (void)disconnectBleDevice;

// 操作通道状态
- (void)editCharacteristicNotify:(NSString *)charUuid withStatus:(BOOL)status;

// 读操作
- (void)readCharacteristic:(NSString *)charUuid;

// 向蓝牙通道写入数据
- (void)writeByte:(NSData *)byteData sendCharacteristic:(NSString *)charUuid writeWithResponse:(BOOL)isResponse;

@end


