/********************************************************************************
 * 文件名称：FBKApiCadence.m
 * 内容摘要：踏频速度API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiCadence.h"
#import "FBKCadenceData.h"

@implementation FBKApiCadence {
    FBKCadenceData *m_cadenceData;
}

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init {
    self = [super init];
    self.deviceType = BleDeviceCadence;
    [self.managerController setManagerDeviceType:BleDeviceCadence];
    m_cadenceData = [[FBKCadenceData alloc] init];
    return self;
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：蓝牙连接状态
 * 功能描述：bleConnectStatus
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status {
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    
    if (!self.isConnected) {
        [m_cadenceData clearCadenceData];
        [m_cadenceData clearSpeedData];
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    NSDictionary *deviceMap = (NSDictionary *)resultData;
    NSDictionary *resultMap = [m_cadenceData calculationDeviceData:deviceMap];
    
    if ([resultMap objectForKey:@"cadence"] != nil) {
        double cadenceNo = [[resultMap objectForKey:@"cadence"] doubleValue];
        if (cadenceNo >= 0) {
            [self.delegate getCadence:cadenceNo andDevice:self];
        }
    }
    
    if ([resultMap objectForKey:@"speed"] != nil) {
        double speedNo = [[resultMap objectForKey:@"speed"] doubleValue];
        double distanceNo = [[resultMap objectForKey:@"distance"] doubleValue];
        
        if (speedNo >= 0 && distanceNo >= 0) {
            [self.delegate getSpeed:speedNo withDistance:distanceNo andDevice:self];
        }
    }
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setWhellDiameter:(double)whellDiameter {
    m_cadenceData.whellDiameter = whellDiameter;
}


@end
