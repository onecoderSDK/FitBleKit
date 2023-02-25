/********************************************************************************
 * 文件名称：FBKApiPower.m
 * 内容摘要：Power API
 * 版本编号：1.0.1
 * 创建日期：2021年01月05日
 ********************************************************************************/

#import "FBKApiPower.h"
#import "FBKCadenceData.h"

@implementation FBKApiPower {
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
    m_cadenceData = [[FBKCadenceData alloc] init];
    self.deviceType = BleDevicePower;
    [self.managerController setManagerDeviceType:BleDevicePower];
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
 * 方法名称：isDataEncryption
 * 功能描述：isDataEncryption
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)isDataEncryption:(BOOL)isEncryption {
    NSString *encryptionString = @"0";
    if (isEncryption) {
        encryptionString = @"1";
    }
    [self.managerController receiveApiCmd:PowerEncryption withObject:encryptionString];
}

/********************************************************************************
 * 方法名称：calibrationPower
 * 功能描述：calibrationPower
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)calibrationPower {
    [self.managerController receiveApiCmd:PowerCalibration withObject:nil];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    PowerResult resultType = (PowerResult)resultNumber;
    if (resultType == PowerResultRealTime) {
        NSDictionary *deviceMap = (NSDictionary *)resultData;
        NSString *powerString = [deviceMap objectForKey:@"power"];
//        NSString *powerString1 = [deviceMap objectForKey:@"power1"];
        NSDictionary *resultMap = [m_cadenceData calculationDeviceData:deviceMap];
        
        int readCadence = 0;
        if ([resultMap objectForKey:@"cadence"] != nil) {
            double cadenceNo = [[resultMap objectForKey:@"cadence"] doubleValue];
            readCadence = [[NSString stringWithFormat:@"%.0f",round(cadenceNo)] intValue];
        }
        
        if (readCadence < 0) {
            readCadence = 0;
        }
        
        [self.delegate realTimePower:[powerString intValue] withCadence:readCadence andDevice:self];
    }
    else if (resultType == PowerResultCalibration) {
        NSDictionary *resultMap = (NSDictionary *)resultData;
        NSString *status = [resultMap objectForKey:@"status"];
        NSString *value = [resultMap objectForKey:@"value"];
        BOOL isSucceed = false;
        if ([status isEqualToString:@"1"]) {
            isSucceed = true;
        }
        [self.delegate calibrationPowerResult:isSucceed andValue:[value intValue] andDevice:self];
    }
}


@end
