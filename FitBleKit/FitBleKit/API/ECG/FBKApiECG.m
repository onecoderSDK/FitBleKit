/********************************************************************************
 * 文件名称：FBKApiECG.m
 * 内容摘要：ECG API
 * 版本编号：1.0.1
 * 创建日期：2021年01月20日
 ********************************************************************************/

#import "FBKApiECG.h"
#import "FBKECGHeartRate.h"
#import "FBKDateFormat.h"
#import "FBKECGFilter.h"

#define   ECGFILERNUMBER    600

@implementation FBKApiECG {
    NSMutableArray *m_rriArray;
    BOOL m_isStartHRV;
    int  m_hrvHeartRate;
    int  m_hrvHrNumber;
    FBKECGFilter *m_ecgFilter;
    FBKECGHeartRate *m_ecgHR;
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
    self.deviceType = BleDeviceECG;
    [self.managerController setManagerDeviceType:BleDeviceECG];
    m_rriArray = [[NSMutableArray alloc] init];
    m_hrvHeartRate = 0;
    m_isStartHRV = false;
    m_ecgHR = [[FBKECGHeartRate alloc] init];
    m_ecgFilter = [[FBKECGFilter alloc] init];
    return self;
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setDeviceColor:(ECGShowColor)showColor {
    NSString *myColor = [NSString stringWithFormat:@"%i",showColor];
    [self.managerController receiveApiCmd:ECGSetColor withObject:myColor];
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
            [self.delegate ECGHRVData:true withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
    }
}


/********************************************************************************
* 方法名称：enterECGMode
* 功能描述：进入ECG模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterECGMode:(BOOL)status {
}


/********************************************************************************
* 方法名称：ecgDataSwitch
* 功能描述：ecgDataSwitch
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)ecgDataSwitch:(BOOL)status {
    NSString *statusString = @"0";
    if (status) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ECGSendSwitch withObject:statusString];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    if (resultType == FBKArmBandResultECG) {
        NSDictionary *ecgMap = (NSDictionary *)resultData;
        NSArray *ecgList = [ecgMap objectForKey:@"ECG"];
        int sortNo = [[ecgMap objectForKey:@"sortNo"] intValue];
        [self.delegate realTimeECG:ecgList withSort:sortNo andDevice:self];

        NSDictionary *heartRateMap = [m_ecgHR addEcgData:ecgList];
        int heartRate = [[heartRateMap objectForKey:@"heartRate"] intValue];
        if (heartRate > 0) {
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            [resultMap addEntriesFromDictionary:heartRateMap];
            [resultMap setObject:@"255" forKey:@"mark"];

            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            [resultMap setObject:nowTime forKey:@"createTime"];
            [resultMap setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            
            if (m_isStartHRV) {
                m_hrvHeartRate = m_hrvHeartRate + heartRate;
                m_hrvHrNumber = m_hrvHrNumber + 1;
                NSArray *rriData = [resultMap objectForKey:@"interval"];
                if (rriData != nil) {
                    [m_rriArray addObjectsFromArray:rriData];
                }
            }
            
            [self.delegate realTimeHeartRate:resultMap andDevice:self];
        }
    }
    else if (resultType == FBKArmBandResultECGCOLOR) {
        NSString *statusStr = (NSString *)resultData;
        if ([statusStr intValue] == 1) {
            [self.delegate setColorResult:true andDevice:self];
        }
        else {
            [self.delegate setColorResult:false andDevice:self];
        }
    }
    else if (resultType == FBKArmBandResultECGSwitch) {
        NSString *statusStr = (NSString *)resultData;
        if ([statusStr intValue] == 1) {
            [self.delegate ecgSwitchResult:true andDevice:self];
        }
        else {
            [self.delegate ecgSwitchResult:false andDevice:self];
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
            [self.delegate ECGHRVData:false withData:resultMap andDevice:self];
            m_isStartHRV = false;
        }
        
        m_ecgFilter = [[FBKECGFilter alloc] init];
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


@end
