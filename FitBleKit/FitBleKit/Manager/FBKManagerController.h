/********************************************************************************
 * 文件名称：FBKManagerController.h
 * 内容摘要：调度层
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKBleController.h"
#import "FBKManagerCmd.h"
#import "FBKManagerAnaly.h"
#import "FBKProtocolBase.h"
#import "FBKProtocolNTracker.h"
#import "FBKProtocolNScale.h"
#import "FBKProtocolSkipping.h"
#import "FBKProtocolCadence.h"
#import "FBKProtocolOldScale.h"
#import "FBKProtocolOldBand.h"
#import "FBKProtocolRosary.h"
#import "FBKProtocolBikeComputer.h"
#import "FBKProtocolArmBand.h"
#import "FBKProtocolKettleBell.h"
#import "FBKProtocolHubConfig.h"
#import "FBKProtocolBoxing.h"
#import "FBKProtocolPower.h"
#import "FBKProtocolECG.h"
#import "FBKProtocolRun.h"
#import "FBKProtocolPPG.h"
#import "FBKProtocolFight.h"

@protocol FBKManagerControllerDelegate <NSObject>

// 蓝牙连接状态
- (void)bleConnectStatus:(DeviceBleStatus)status;

// 蓝牙连接错误信息
- (void)bleConnectError:(id)error;

// 蓝牙UUID数据
- (void)bleConnectUuids:(NSArray *)charUuidArray;

// 蓝牙结果数据
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber;

// 蓝牙公共结果数据
- (void)analyCommonData:(id)resultData withResultNumber:(int)resultNumber;

// 蓝牙LOG
- (void)bleConnectLog:(NSString *)logString andDevice:(id)device;

// 获取电量
- (void)deviceManagerPower:(NSString *)powerInfo;

// 获取固件版本号
- (void)deviceManagerFirmwareVersion:(NSString *)versionInfo;

// 获取硬件版本号
- (void)deviceManagerHardwareVersion:(NSString *)versionInfo;

// 获取软件版本号
- (void)deviceManagerSoftwareVersion:(NSString *)versionInfo;

// 获取SystemID
- (void)deviceManagerSystemData:(NSData *)systemData;

// 获取Model String
- (void)deviceManagerModelString:(NSString *)modelString;

// 获取序列号
- (void)deviceManagerSerialNumber:(NSString *)serialNumber;

// 获取制造商信息
- (void)deviceManagerManufacturerName:(NSString *)manufacturerName;

@end


@interface FBKManagerController : NSObject<FBKBleControllerDelegate,FBKProtocolBaseDelegate>

// 协议
@property(assign,nonatomic)id <FBKManagerControllerDelegate> delegate;

// 设备类型
@property (assign,nonatomic) BleDeviceType deviceType;

// 设备连接状态
@property (assign,nonatomic) BOOL isConnected;

// BLE
@property (strong,nonatomic) FBKBleController *bleController;

// 新手环信息
@property (strong,nonatomic) FBKProtocolBase *protocolBase;

// 设置设备类型
- (void)setManagerDeviceType:(BleDeviceType)type;

// 开始连接蓝牙设备
- (void)startConnectBleManage:(NSString *)deviceId withDeviceType:(BleDeviceType)type andIdType:(DeviceIdType)idType;

// 断开蓝牙连接
- (void)disconnectBleManage;

// 操作通道状态
- (void)editCharacteristicNotifyManage:(BOOL)status withCharacteristic:(NSString *)uuid;

// 读操作
- (void)readCharacteristicManage:(NSString *)uuid;

// 写入数据
- (void)writeDataManage:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response;

// 接收API命令
- (void)receiveApiCmd:(int)cmdNumber withObject:(id)object;

// 获取私有版本号
- (void)getPrivateVersion;

// 获取私有Mac地址
- (void)getPrivateMacAddress;

- (void)getOtaCustomerName;

// 进入OTA模式
- (void)enterOTAMode;

// 获取设备名称
- (NSString *)readDeviceName;

@end
