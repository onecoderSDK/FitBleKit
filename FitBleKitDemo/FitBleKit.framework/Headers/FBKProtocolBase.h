/********************************************************************************
 * 文件名称：FBKProtocolBase.h
 * 内容摘要：协议基础类
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKDeviceBaseInfo.h"
#import "FBKEnumList.h"

@protocol FBKProtocolBaseDelegate <NSObject>

// 向蓝牙写入数据
- (void)writeBleByte:(NSData *)byteData;

// 向蓝牙写入数据
- (void)writeSpliceByte:(NSData *)byteData withUuid:(NSString *)uuidString;

// 解析完成的Ble数据
- (void)analyticalBleData:(id)resultData withResultNumber:(int)resultNumber;

// 大数据同步状态
- (void)synchronizationStatus:(DeviceBleStatus)status;

@end


@interface FBKProtocolBase : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProtocolBaseDelegate> delegate;

// 接收拼接命令
- (void)receiveBleCmd:(int)cmdId withObject:(id)object;

// 接收蓝牙原数据
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid;

// 接收蓝牙原数据(特殊数据)
- (NSDictionary *)receiveBaseData:(CBCharacteristic *)characteristic;;

// 蓝牙异常重连
- (void)bleErrorReconnect;

@end
