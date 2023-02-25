/*-****************************************************************************************
 * 版权所有 : 深圳市一非科技有限公司
 * 文件名称 : FBKApiBaseInfo.m
 * 功能介绍 : 蓝牙设备的基本信息
 * 编辑作者 : 彭于
 * 创建日期 : 2022.04.11
 *-****************************************************************************************/

#import "FBKApiBaseInfo.h"

@implementation FBKApiBaseInfo

#pragma mark - ********************************* 系统方法 **********************************
/*-****************************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 *-****************************************************************************************/
- (id)init {
    self = [super init];
    self.battery = -1;
    self.firmVersion = nil;
    self.hardVersion = nil;
    self.softVersion = nil;
    self.systemId = nil;
    self.modelString = nil;
    self.serialNumber = nil;
    self.manufacturerName = nil;
    self.deviceMac = nil;
    self.dfuMac = nil;
    self.customerName = nil;
    return self;
}

@end



@implementation FBKApiBaseInfoStatus

#pragma mark - ********************************* 系统方法 **********************************
/*-****************************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 *-****************************************************************************************/
- (id)init {
    self = [super init];
    self.readBattery = false;
    self.readFirmVersion = false;
    self.readHardVersion = false;
    self.readSoftVersion = false;
    self.readSystemId = false;
    self.readModel = false;
    self.readSerial = false;
    self.readManufacturer = false;
    self.getCmdVersion = false;
    self.getCmdMac = false;
    self.getCmdCustomer = false;
    return self;
}

@end
