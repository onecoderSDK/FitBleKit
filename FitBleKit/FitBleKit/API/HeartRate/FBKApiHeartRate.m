/********************************************************************************
 * 文件名称：FBKApiHeartRate.h
 * 内容摘要：心率设备API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiHeartRate.h"

@implementation FBKApiHeartRate {
    NSMutableArray *m_rriArray;
    BOOL m_isStartHRV;
    int  m_hrvHeartRate;
    int  m_hrvHrNumber;
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
    self.deviceType = BleDeviceHeartRate;
    [self.managerController setManagerDeviceType:BleDeviceHeartRate];
    m_rriArray = [[NSMutableArray alloc] init];
    m_hrvHeartRate = 0;
    m_hrvHrNumber = 0;
    m_isStartHRV = false;
    return self;
}


/********************************************************************************
 * 方法名称：getRecordHrData
 * 功能描述：获取历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRecordHrData {
    [self editCharacteristicNotifyApi:YES withCharacteristic:FBKOLDBANDNOTIFYFC20];
}


/********************************************************************************
* 方法名称：enterHRVMode
* 功能描述：进入HRV模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterHRVMode:(BOOL)status {
    if (status) {
        m_hrvHeartRate = 0;
        m_hrvHrNumber = 0;
        [m_rriArray removeAllObjects];
        m_isStartHRV = true;
    }
    else {
        if (m_isStartHRV) {
            int avgHR = 0;
            if (m_hrvHrNumber != 0) {
                avgHR = m_hrvHeartRate/m_hrvHrNumber;
            }
            
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            [resultMap setObject:[NSString stringWithFormat:@"%i",avgHR] forKey:@"heartRate"];
            [resultMap setObject:m_rriArray forKey:@"RRIInterval"];
            [self.delegate HRHrvResultData:true withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
    }
}

/*-***********************************************************************************
* Method: setShock
* Description: set Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setShock:(int)shockNumber {
    [self.managerController receiveApiCmd:OTrackerCmdSetShock withObject:[NSString stringWithFormat:@"%i",shockNumber]];
}


/*-***********************************************************************************
* Method: getShock
* Description: get Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)getShock {
    [self.managerController receiveApiCmd:OTrackerCmdGetShock withObject:nil];
}


/*-***********************************************************************************
* Method: closeShock
* Description: close Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)closeShock {
    [self.managerController receiveApiCmd:OTrackerCmdCloseShock withObject:nil];
}


/*-***********************************************************************************
* Method: setMaxInterval
* Description: set Max Interval
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setMaxInterval:(int)maxNumber {
    [self.managerController receiveApiCmd:OTrackerCmdMaxInterval withObject:[NSString stringWithFormat:@"%i",maxNumber]];
}


/*-***********************************************************************************
* Method: setLightSwitch
* Description: set Light Switch
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setLightSwitch:(BOOL)isOpen {
    NSString *statusString = @"0";
    if (isOpen) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:OTrackerCmdLightSwitch withObject:statusString];
}


/*-***********************************************************************************
* Method: setColorShock
* Description: setColorShock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setColorShock:(BOOL)isOpen {
    NSString *statusString = @"0";
    if (isOpen) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:OTrackerCmdColorShock withObject:statusString];
}


/*-***********************************************************************************
* Method: setColorInterval
* Description: setColorInterval
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setColorInterval:(int)colorNumber {
    [self.managerController receiveApiCmd:OTrackerCmdColorInterval withObject:[NSString stringWithFormat:@"%i",colorNumber]];
}


/*-***********************************************************************************
* Method: clearRecord
* Description: clearRecord
* Parameter:
* Return Data:
*************************************************************************************/
- (void)clearRecord {
    [self.managerController receiveApiCmd:OTrackerCmdClearRecord withObject:nil];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    FBKAnalyticalOldBand resultType = (FBKAnalyticalOldBand)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalOldBandRTHR:
        {
            NSDictionary *dataMap = (NSDictionary *)resultData;
            if (m_isStartHRV) {
                m_hrvHeartRate = m_hrvHeartRate + [[dataMap objectForKey:@"heartRate"] intValue];
                m_hrvHrNumber = m_hrvHrNumber + 1;
                NSArray *rriData = [dataMap objectForKey:@"interval"];
                if (rriData != nil) {
                    [m_rriArray addObjectsFromArray:rriData];
                }
            }
            [self.delegate getRealTimeHeartRate:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalOldBandBigData:
        {
            [self editCharacteristicNotifyApi:NO withCharacteristic:FBKOLDBANDNOTIFYFC20];
            NSDictionary *dataDic = (NSDictionary *)resultData;
            [self.delegate getHeartRateRecord:dataDic andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandSetShock: {
            [self.delegate setHRShockStatus:YES andDevice:self];
            break;
        }
        
        case FBKAnalyOldBandGetShock: {
            [self.delegate getHRShockStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandCloseShock: {
            [self.delegate closeHRShockStatus:YES andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandMaxInterval: {
            [self.delegate setHRMaxIntervalStatus:YES andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandLightSwitch: {
            [self.delegate setHRLightSwitchStatus:YES andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandColorShock: {
            [self.delegate setHRColorShockStatus:YES andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandColorInterval: {
            [self.delegate setHRColorIntervalStatus:YES andDevice:self];
            break;
        }
            
        case FBKAnalyOldBandClearRecord: {
            [self.delegate clearHRRecordStatus:YES andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


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
    
    if (status == DeviceBleDisconneced || status == DeviceBleReconnect) {
        if (m_isStartHRV) {
            int avgHR = 0;
            if (m_hrvHrNumber != 0) {
                avgHR = m_hrvHeartRate/m_hrvHrNumber;
            }
            
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            [resultMap setObject:[NSString stringWithFormat:@"%i",avgHR] forKey:@"heartRate"];
            [resultMap setObject:m_rriArray forKey:@"RRIInterval"];
            [self.delegate HRHrvResultData:false withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


@end
