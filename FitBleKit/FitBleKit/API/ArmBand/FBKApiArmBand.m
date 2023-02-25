/********************************************************************************
 * 文件名称：FBKApiArmBand.m
 * 内容摘要：臂带API
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiArmBand.h"
#import "FBKTemAlgorithm.h"

@implementation FBKApiArmBand {
    FBKTemAlgorithm *m_temAlgorithm;
    NSMutableArray *m_rriArray;
    BOOL m_isStartHRV;
    int m_hrvHeartRate;
    int  m_hrvHrNumber;
}


#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceType = BleDeviceArmBand;
    [self.managerController setManagerDeviceType:BleDeviceArmBand];
    m_temAlgorithm = [[FBKTemAlgorithm alloc] init];
    m_rriArray = [[NSMutableArray alloc] init];
    m_isStartHRV = false;
    m_hrvHeartRate = 0;
    m_hrvHrNumber = 0;
    
    return self;
}


/********************************************************************************
 * 方法名称：setArmBandTime
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setArmBandTime
{
    [self.managerController receiveApiCmd:ArmBandCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setHeartRateMax
 * 功能描述：设置心率最大值
 * 输入参数：maxRate-心率最大值
 * 返回数据：
 ********************************************************************************/
- (void)setHeartRateMax:(NSString *)maxRate
{
    [self.managerController receiveApiCmd:ArmBandCmdSetMaxHR withObject:maxRate];
}


/********************************************************************************
* 方法名称：setHeartRateColor
* 功能描述：设置心率区间颜色
* 输入参数：hrColor-心率区间颜色
* 返回数据：
********************************************************************************/
- (void)setHeartRateColor:(FBKDeviceHRColor *)hrColor {
    [self.managerController receiveApiCmd:ArmBandCmdSetHrColor withObject:hrColor];
}


/********************************************************************************
* 方法名称：enterHRVMode
* 功能描述：进入HRV模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterHRVMode:(BOOL)status {
    NSString *statusString = @"0";
    if (status) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ArmBandCmdEnterHRVMode withObject:statusString];
    
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
            [self.delegate ABHrvResultData:true withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
    }
}


/********************************************************************************
* 方法名称：enterSPO2Mode
* 功能描述：进入SPO2模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterSPO2Mode:(BOOL)status {
    NSString *statusString = @"0";
    if (status) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ArmBandCmdEnterSPO2Mode withObject:statusString];
}


/********************************************************************************
* 方法名称：enterTemperatureMode
* 功能描述：进入温度模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterTemperatureMode:(BOOL)status {
    NSString *statusString = @"0";
    if (status) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ArmBandCmdEnterTemMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：getArmBandTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getArmBandTotalHistory
{
    [self.managerController receiveApiCmd:ArmBandCmdGetTotalRecord withObject:nil];
}


/*-***********************************************************************************
* Method: setDeviceAge
* Description: setDeviceAge
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setDeviceAge:(int)ageNumber {
    [self.managerController receiveApiCmd:ArmBandCmdSetAge withObject:[NSString stringWithFormat:@"%i",ageNumber]];
}


/*-***********************************************************************************
* Method: setShock
* Description: set Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setShock:(int)shockNumber {
    [self.managerController receiveApiCmd:ArmBandCmdSetShock withObject:[NSString stringWithFormat:@"%i",shockNumber]];
}


/*-***********************************************************************************
* Method: getShock
* Description: get Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)getShock {
    [self.managerController receiveApiCmd:ArmBandCmdGetShock withObject:nil];
}


/*-***********************************************************************************
* Method: closeShock
* Description: close Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)closeShock {
    [self.managerController receiveApiCmd:ArmBandCmdCloseShock withObject:nil];
}


/*-***********************************************************************************
* Method: setMaxInterval
* Description: set Max Interval
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setMaxInterval:(int)maxNumber {
    [self.managerController receiveApiCmd:ArmBandCmdMaxInterval withObject:[NSString stringWithFormat:@"%i",maxNumber]];
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
    [self.managerController receiveApiCmd:ArmBandCmdLightSwitch withObject:statusString];
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
    [self.managerController receiveApiCmd:ArmBandCmdColorShock withObject:statusString];
}


/*-***********************************************************************************
* Method: setColorInterval
* Description: setColorInterval
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setColorInterval:(int)colorNumber {
    [self.managerController receiveApiCmd:ArmBandCmdColorInterval withObject:[NSString stringWithFormat:@"%i",colorNumber]];
}


/*-***********************************************************************************
* Method: clearRecord
* Description: clearRecord
* Parameter:
* Return Data:
*************************************************************************************/
- (void)clearRecord {
    [self.managerController receiveApiCmd:ArmBandCmdClearRecord withObject:nil];
}


/*-***********************************************************************************
* Method: getDeviceMacAddress
* Description: get Device Mac Address
* Parameter:
* Return Data:
*************************************************************************************/
- (void)getDeviceMacAddress {
    [self.managerController receiveApiCmd:ArmBandCmdGetMacAddress withObject:nil];
}


/*-***********************************************************************************
* Method: getDeviceVersion
* Description: get Device getDeviceVersion
* Parameter:
* Return Data:
*************************************************************************************/
- (void)getDeviceVersion {
    [self.managerController receiveApiCmd:ArmBandCmdGetVersion withObject:nil];
}


/*-***********************************************************************************
* Method: enterOTAMode
* Description: enter OTA Mode
* Parameter:
* Return Data:
*************************************************************************************/
- (void)enterOTAMode {
    [self.managerController receiveApiCmd:ArmBandCmdEnterOTA withObject:nil];
}


/*-***********************************************************************************
* Method: setDataFrequency
* Description: setDataFrequency
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setDataFrequency:(int)dataFrequency {
    [self.managerController receiveApiCmd:ArmBandCmdDataFrequency withObject:[NSString stringWithFormat:@"%i",dataFrequency]];
}


/*-***********************************************************************************
* Method: setHrvTime
* Description: set Hrv Time
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setHrvTime:(int)seconds {
    [self.managerController receiveApiCmd:ArmBandCmdSetHrvTime withObject:[NSString stringWithFormat:@"%i",seconds]];
}


- (void)setPrivateFiveZone:(NSArray *)zoneArray{
    [self.managerController receiveApiCmd:ArmBandCmdFiveZone withObject:zoneArray];
}

- (void)openSettingShow{
    [self.managerController receiveApiCmd:ArmBandCmdOpenShow withObject:nil];
}

- (void)closeSettingShow{
    [self.managerController receiveApiCmd:ArmBandCmdCloseShow withObject:nil];
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
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalRealTimeHR:
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
            [self.delegate armBandRealTimeHeartRate:dataMap andDevice:self];
            break;
        }
            
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate armBandVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRTStepFrequency:
        {
            [self.delegate armBandStepFrequency:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData:
        {
            [self.delegate armBandDetailData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRTTem: {
            NSDictionary *temMap = [m_temAlgorithm algorithmBodyTemperature:(NSDictionary *)resultData];
            [self.delegate armBandTemperature:temMap andDevice:self];
            break;
        }
            
        case FBKAnalyticalRTSPO2: {
            [self.delegate armBandSPO2:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHRVData: {
            int avgHR = 0;
            if (m_hrvHrNumber != 0) {
                avgHR = m_hrvHeartRate/m_hrvHrNumber;
            }
            
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)resultData];
            [resultMap setObject:[NSString stringWithFormat:@"%i",avgHR] forKey:@"heartRate"];
            [resultMap setObject:m_rriArray forKey:@"RRIInterval"];
            [self.delegate HRVResultData:resultMap andDevice:self];
            m_isStartHRV = false;
            break;
        }
            
        case FBKArmBandResultSetAge: {
            [self.delegate setAgeStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultSetShock: {
            [self.delegate setShockStatus:YES andDevice:self];
            break;
        }
        
        case FBKArmBandResultGetShock: {
            [self.delegate getShockStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKArmBandResultCloseShock: {
            [self.delegate closeShockStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultMaxInterval: {
            [self.delegate setMaxIntervalStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultLightSwitch: {
            [self.delegate setLightSwitchStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultColorShock: {
            [self.delegate setColorShockStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultColorInterval: {
            [self.delegate setColorIntervalStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultClearRecord: {
            [self.delegate clearRecordStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultMacAddress: {
            [self.delegate deviceMacAddress:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKArmBandResultAllVersion: {
            [self.delegate totalVersion:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKArmBandResultECG: {
            break;
        }
            
        case FBKResultAcceleration: {
            NSArray *dataArray = (NSArray *)resultData;
            [self.delegate accelerationData:dataArray andDevice:self];
            break;
        }
            
        case FBKArmBandResultFiveZone: {
            NSString *valueString = (NSString *)resultData;
            int valueNo = [valueString intValue];
            BOOL isSucced = true;
            if(valueNo == 0) {
                isSucced = false;
            }
            
            [self.delegate setPrivateFiveZone:isSucced andDevice:self];
            break;
        }
            
        case FBKArmBandResultOpenShow: {
            NSString *valueString = (NSString *)resultData;
            int valueNo = [valueString intValue];
            BOOL isSucced = true;
            if(valueNo == 0) {
                isSucced = false;
            }
            
            [self.delegate openSettingShow:isSucced andDevice:self];
            break;
        }
            
        case FBKArmBandResultCloseShow: {
            NSString *valueString = (NSString *)resultData;
            int valueNo = [valueString intValue];
            BOOL isSucced = true;
            if(valueNo == 0) {
                isSucced = false;
            }
            
            [self.delegate closeSettingShow:isSucced andDevice:self];
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
            [self.delegate ABHrvResultData:false withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


@end
