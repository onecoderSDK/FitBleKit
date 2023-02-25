/********************************************************************************
 * 文件名称：FBKApiBsaeMethod.h
 * 内容摘要：API基础类
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKEnumList.h"
#import "FBKManagerController.h"
#import "FBKApiBaseInfo.h"

@protocol FBKApiBsaeDataSource <NSObject>

// 蓝牙连接状态
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

// 蓝牙连接错误信息
- (void)bleConnectError:(id)error andDevice:(id)bleDevice;

// 蓝牙LOG
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice;

// 获取电量
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice;

// 获取固件版本号
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice;

// 获取硬件版本号
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice;

// 获取软件版本号
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice;

// 获取私有版本号
- (void)privateVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice;

// 获取私有MAC地址
- (void)privateMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice;

// 获取SystemID
- (void)deviceSystemData:(NSData *)systemData andDevice:(id)bleDevice;

// 获取Model String
- (void)deviceModelString:(NSString *)modelString andDevice:(id)bleDevice;

// 获取序列号
- (void)deviceSerialNumber:(NSString *)serialNumber andDevice:(id)bleDevice;

// 获取制造商信息
- (void)deviceManufacturerName:(NSString *)manufacturerName andDevice:(id)bleDevice;

- (void)deviceBaseInfo:(FBKApiBaseInfo *)baseInfo andDevice:(id)bleDevice;

@end


@interface FBKApiBsaeMethod : NSObject<FBKManagerControllerDelegate>

// 协议
@property(assign,nonatomic)id <FBKApiBsaeDataSource> dataSource;

// 设备类型
@property (assign,nonatomic) BleDeviceType deviceType;

// 设备类型
@property (strong,nonatomic) NSString *deviceId;

// 调度类
@property (strong,nonatomic) FBKManagerController *managerController;

// 设备连接状态
@property (assign,nonatomic) BOOL isConnected;

// 开始连接蓝牙设备
- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType;

// 断开蓝牙连接
- (void)disconnectBleApi;

// 操作通道状态
- (void)editCharacteristicNotifyApi:(BOOL)status withCharacteristic:(NSString *)uuid;

// 读操作
- (void)readCharacteristicApi:(NSString *)uuid;

// 写入数据
- (void)writeData:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response;

// 获取电量
- (void)readDevicePower;

// 获取固件版本号
- (void)readFirmwareVersion;

// 获取硬件版本号
- (void)readHardwareVersion;

// 获取软件版本号
- (void)readSoftwareVersion;

// 获取System Id
- (void)readSystemId;

// 获取Model String
- (void)readModelString;

// 获取序列号
- (void)readSerialNumber;

// 获取制造商信息
- (void)readManufacturerName;

// 获取私有版本号
- (void)getPrivateVersion;

// 获取私有Mac地址
- (void)getPrivateMacAddress;

// 进入OTA模式
- (void)enterOTAMode;

// 获取设备名称
- (NSString *)readDeviceName;

- (void)getDeviceBaseInfo;

@end

