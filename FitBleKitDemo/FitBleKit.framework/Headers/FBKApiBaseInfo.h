/*-****************************************************************************************
 * 版权所有 : 深圳市一非科技有限公司
 * 文件名称 : FBKApiBaseInfo.h
 * 功能介绍 : 蓝牙设备的基本信息
 * 编辑作者 : 彭于
 * 创建日期 : 2022.04.11
 *-****************************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKApiBaseInfo : NSObject

@property (assign, nonatomic) int battery;

@property (strong, nonatomic) NSString *firmVersion;

@property (strong, nonatomic) NSString *hardVersion;

@property (strong, nonatomic) NSString *softVersion;

@property (strong, nonatomic) NSData *systemId;

@property (strong, nonatomic) NSString *modelString;

@property (strong, nonatomic) NSString *serialNumber;

@property (strong, nonatomic) NSString *manufacturerName;

@property (strong, nonatomic) NSString *deviceMac;

@property (strong, nonatomic) NSString *dfuMac;

@property (strong, nonatomic) NSString *customerName;

@end



@interface FBKApiBaseInfoStatus : NSObject

@property (assign, nonatomic) BOOL readBattery;

@property (assign, nonatomic) BOOL readFirmVersion;

@property (assign, nonatomic) BOOL readHardVersion;

@property (assign, nonatomic) BOOL readSoftVersion;

@property (assign, nonatomic) BOOL readSystemId;

@property (assign, nonatomic) BOOL readModel;

@property (assign, nonatomic) BOOL readSerial;

@property (assign, nonatomic) BOOL readManufacturer;

@property (assign, nonatomic) BOOL getCmdVersion;

@property (assign, nonatomic) BOOL getCmdMac;

@property (assign, nonatomic) BOOL getCmdCustomer;

@end
