/********************************************************************************
* 文件名称：FBKApiBroadcastScale.h
* 内容摘要：广播蓝牙秤API
* 版本编号：1.0.1
* 创建日期：2019年10月10日
********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKApiScanDevices.h"
#import "FBKEnumList.h"

@protocol FBKApiBroadcastScaleDelegate <NSObject>

// 蓝牙连接状态
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

// 蓝牙连接错误信息
- (void)bleConnectError:(id)error andDevice:(id)bleDevice;

// 版本号
- (void)scaleVersion:(NSString *)version andDevice:(id)bleDevice;

// 体重数据
- (void)weightData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

@end


@interface FBKApiBroadcastScale : NSObject<FBKApiScanDevicesDelegate>

// 协议
@property(assign,nonatomic)id <FBKApiBroadcastScaleDelegate> delegate;

// 设备类型
@property (assign,nonatomic) BleDeviceType deviceType;

// 设备类型
@property (strong,nonatomic) NSString *deviceId;

// 设备连接状态
@property (assign,nonatomic) BOOL isConnected;

// 开始连接蓝牙设备
- (void)startConnectBleApi:(NSString *)deviceId timeout:(int)seconds andIdType:(DeviceIdType)idType;

// 断开蓝牙连接
- (void)disconnectBleApi;

@end
