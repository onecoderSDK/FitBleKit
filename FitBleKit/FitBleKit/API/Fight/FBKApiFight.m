/********************************************************************************
 * 文件名称：FBKApiFight.h
 * 内容摘要：Fight API
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKApiFight.h"

@implementation FBKApiFight

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init {
    self = [super init];
    self.deviceType = BleDeviceFight;
    [self.managerController setManagerDeviceType:BleDeviceFight];
    return self;
}


/********************************************************************************
 * 方法名称：enterDfuMode
 * 功能描述：enterDfuMode
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterDfuMode {
    [self.managerController receiveApiCmd:FightCmdEnterDfu withObject:nil];
}


/********************************************************************************
 * 方法名称：turnOffDevice
 * 功能描述：turnOffDevice
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)turnOffDevice {
    [self.managerController receiveApiCmd:FightCmdTurnOffDevice withObject:nil];
}


/********************************************************************************
 * 方法名称：setSandbag
 * 功能描述：setSandbag
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setSandbag:(FBKFightSandbag *)sandbag {
    [self.managerController receiveApiCmd:FightCmdSetSandbag withObject:sandbag];
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
    
    [self.delegate bleConnectStatus:status andDevice:self];
}


/********************************************************************************
 * 方法名称：蓝牙连接错误信息
 * 功能描述：bleConnectError
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error {
    [self.delegate bleConnectError:error andDevice:self];
}

/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：bleConnectLog
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)device {
    [self.delegate bleConnectLog:logString andDevice:self];
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    FightResultNumber resultType = (FightResultNumber)resultNumber;
    
    switch (resultType) {
        case FightResultInfo: {
            [self.delegate realTimeFight:(FBKFightInfo *)resultData andDevice:self];
            break;
        }

        case FightResultEnterDfu: {
            BOOL isCmdOk = true;
            NSString *value = (NSString *)resultData;
            if ([value intValue] == 0) {
                isCmdOk = false;
            }
            [self.delegate enterDfuResult:isCmdOk andDevice:self];
            break;
        }
            
        case FightResultTurnOffDevice: {
            BOOL isCmdOk = true;
            NSString *value = (NSString *)resultData;
            if ([value intValue] == 0) {
                isCmdOk = false;
            }
            [self.delegate turnOffDeviceResult:isCmdOk andDevice:self];
            break;
        }
            
        case FightResultSetSandbag: {
            BOOL isCmdOk = true;
            NSString *value = (NSString *)resultData;
            if ([value intValue] == 0) {
                isCmdOk = false;
            }
            [self.delegate setSandbagResult:isCmdOk andDevice:self];
            break;
        }
            
        default: {
            break;
        }
    }
}


@end
