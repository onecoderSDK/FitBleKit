/********************************************************************************
 * 文件名称：FBKProtocolNTracker.m
 * 内容摘要：新手环蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import "FBKProtocolNTracker.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolNTracker
{
    FBKProNTrackerCmd *m_newTrackerCmd;
    FBKProNTrackerAnalytical *m_newTrackerAnalytical;
    
    NSString *m_sitSwitch;
    NSString *m_waterSwitch;
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
    
    m_newTrackerCmd = [[FBKProNTrackerCmd alloc] init];
    m_newTrackerCmd.delegate = self;
    
    m_newTrackerAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_newTrackerAnalytical.delegate = self;
    m_newTrackerAnalytical.analyticalDeviceType = BleDeviceNewBand;
    
    m_sitSwitch = @"1";
    m_waterSwitch = @"1";
    
    return self;
}


/********************************************************************************
* 方法名称：dealloc
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)dealloc
{
    m_newTrackerCmd.delegate = nil;
    m_newTrackerCmd = nil;
    
    m_newTrackerAnalytical.delegate = nil;
    m_newTrackerAnalytical = nil;
}


#pragma mark - **************************** 接收数据  *****************************
/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object
{
    NTrackerCmdNumber trackerCmd = (NTrackerCmdNumber)cmdId;
    
    switch (trackerCmd)
    {
        case NTrackerCmdSetTime:
            [m_newTrackerCmd setUTC];
            break;
            
        case NTrackerCmdSetUserInfo:
            [m_newTrackerCmd setUserInfoCmd:(FBKDeviceUserInfo *)object];
            break;
            
        case NTrackerCmdSetSleepInfo:
            [m_newTrackerCmd setSleepInfoCmd:(FBKDeviceSleepInfo *)object];
            break;
            
        case NTrackerCmdSetWaterInfo:
            m_waterSwitch = ((FBKDeviceIntervalInfo *)object).switchStatus;
            [m_newTrackerCmd setWaterInfoCmd:(FBKDeviceIntervalInfo *)object withSitSwitch:m_sitSwitch];
            break;
            
        case NTrackerCmdSetSitInfo:
            m_sitSwitch = ((FBKDeviceIntervalInfo *)object).switchStatus;
            [m_newTrackerCmd setSitInfoCmd:(FBKDeviceIntervalInfo *)object withWaterSwitch:m_waterSwitch];
            break;
            
        case NTrackerCmdSetNoticeInfo:
            [m_newTrackerCmd setNoticeInfoCmd:(FBKDeviceNoticeInfo *)object];
            break;
            
        case NTrackerCmdSetAlarmInfo:
            [m_newTrackerCmd setAlarmInfoCmd:(NSArray *)object];
            break;
            
        case NTrackerCmdSetBikeInfo:
            [m_newTrackerCmd setBikeInfoCmd:(NSString *)object];
            break;
            
        case NTrackerCmdSetHRMax:
            [m_newTrackerCmd setHeartRateMaxCmd:(NSString *)object];
            break;
            
        case NTrackerCmdSetANTInfo:
            [m_newTrackerCmd setANTInfoCmd:(NSString *)object];
            break;
            
        case NTrackerCmdOpenRealTImeSteps:
            [m_newTrackerCmd openRealTimeStepsCmd:(NSString *)object];
            break;
            
        case NTrackerCmdOpenTakePhoto:
            [m_newTrackerCmd openTakePhotoCmd:(NSString *)object];
            break;
            
        case NTrackerCmdOpenHRMode:
            [m_newTrackerCmd openHeartRateModeCmd:(NSString *)object];
            break;
            
        case NTrackerCmdOpenHRTenMode:
            [m_newTrackerCmd openTenHR:(NSString *)object];
            break;
            
        case NTrackerCmdOpenANCSMode:
            [m_newTrackerCmd openANCSModeCmd:(NSString *)object];
            break;
            
        case NTrackerCmdGetDeviceSupport:
            [m_newTrackerCmd getDeviceSupportCmd];
            break;
            
        case NTrackerCmdGetBeforeUtc:
            [m_newTrackerCmd getBeforeUtcCmd];
            break;
            
        case NTrackerCmdGetTotalRecord:
            [m_newTrackerCmd getTotalRecordCmd];
            break;
            
        case NTrackerCmdGetStepRecord:
            [m_newTrackerCmd getStepRecordCmd];
            break;
            
        case NTrackerCmdGetSleepRecord:
            [m_newTrackerCmd getSleepRecordCmd];
            break;
            
        case NTrackerCmdGetHRRecord:
            [m_newTrackerCmd getHeartRateRecordCmd];
            break;
            
        case NTrackerCmdGetBikeRecord:
            [m_newTrackerCmd getBikeRecordCmd];
            break;
            
        case NTrackerCmdGetTrainRecord:
            [m_newTrackerCmd getTrainRecordCmd];
            break;
            
        case NTrackerCmdGetEverydayRecord:
            [m_newTrackerCmd getEverydayRecordCmd];
            break;
            
        case NTrackerCmdAckCmd:
            [m_newTrackerCmd getAckCmd:(NSString *)object];
            break;
            
        case NTrackerCmdSendCmdSuseed:
            [m_newTrackerCmd sendCmdSuseed:(NSString *)object];
            break;
            
        default:
            break;
    }
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid {
    NSString *hexString = [FBKSpliceBle bleDataToString:hexData];
    if ([FBKSpliceBle compareUuid:uuid withUuid:FBKNEWBANDNOTIFYFD19]) {
        [m_newTrackerAnalytical receiveBlueData:hexString];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBKHEARTRATENOTIFY2A37]) {
        NSDictionary *dataDic = [self getRealTimeData:hexString isHeart:YES];
        [self.delegate analyticalBleData:dataDic withResultNumber:FBKAnalyticalRealTimeHR];
    }
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_newTrackerAnalytical receiveBlueDataError];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：sendBleCmdData
 * 功能描述：传输写入的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendBleCmdData:(NSData *)byteData;
{
    [self.delegate writeBleByte:byteData];
}


/********************************************************************************
 * 方法名称：analyticalSucceed
 * 功能描述：解析数据返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalNumber)resultNumber
{
    switch (resultNumber)
    {
        case FBKAnalyticalDeviceVersion:
        {
            int softVersion = [[NSString stringWithFormat:@"%@",(NSString *)resultData] intValue];
            if (softVersion == 1 || softVersion == 2)
            {
                softVersion = 1;
            }

            m_newTrackerCmd.m_softVersion = 1;
            
            [m_newTrackerCmd setUTC];
            [m_newTrackerCmd openANCSModeCmd:@"1"];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_newTrackerCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_newTrackerCmd getAckCmd:(NSString *)resultData];
            break;
            
        case FBKAnalyticalBigData:
            [self.delegate synchronizationStatus:DeviceBleSyncOver];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
            
        case FBKAnalyticalSyncing:
            [self.delegate synchronizationStatus:DeviceBleSynchronization];
            break;
            
        default:
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
    }
}


/********************************************************************************
 * 方法名称：getRateData
 * 功能描述：解析心率数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)getRealTimeData:(NSString *)myString isHeart:(BOOL)status
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    int j=0;
    Byte bytes[20];
    
    for(int i=0;i<[myString length];i++)
    {
        int int_ch; //// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [myString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [myString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch; ///将转化后的数放入Byte数组里
        j++;
    }
    
    if (status)
    {
        int c0 = bytes[0]&0xFF;
        NSString *dataLength = [NSString stringWithFormat:@"%d",c0];
        [resultDic setObject:dataLength forKey:@"dataLength"];
        
        int c1 = bytes[1]&0xFF;
        NSString *nowXinLv = [NSString stringWithFormat:@"%d",c1];
        [resultDic setObject:nowXinLv forKey:@"heartRate"];
        [resultDic setObject:@"0" forKey:@"mark"];
        
        NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
        int intervalLength = (int)myString.length/2;
        if (intervalLength > 2 && intervalLength%2 == 0) {
            for (int i = 2; i < intervalLength; i++) {
                if (i%2 == 0) {
                    int lowByte = bytes[i]&0xFF;
                    int hiByte = bytes[i+1]&0xFF;
                    NSString *interval = [NSString stringWithFormat:@"%d",(hiByte<<8) + lowByte];
                    [intervalArray addObject:interval];
                }
            }
        }
        
        if (intervalArray.count > 0) {
            [resultDic setObject:intervalArray forKey:@"interval"];
        }
        
        NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
        [resultDic setObject:nowTime forKey:@"createTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
    }
    else
    {
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *handTime = [NSDate date];
        NSString *locTime = [myFormatter stringFromDate:handTime];
        [resultDic setObject:locTime forKey:@"locTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:locTime]] forKey:@"timestamps"];
        
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *stepNum = [NSString stringWithFormat:@"%d",c4+(c3<<8)+(c2<<16)];
        [resultDic setObject:stepNum forKey:@"stepNum"];
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        int c7 = bytes[7]&0xFF;
        NSString *stepDistance = [NSString stringWithFormat:@"%.1f",(float)(c7+(c6<<8)+(c5<<16))/100000];
        [resultDic setObject:stepDistance forKey:@"stepDistance"];
        
        int c8 = bytes[8]&0xFF;
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        NSString *stepKcal = [NSString stringWithFormat:@"%.1f",(float)(c10+(c9<<8)+(c8<<16))/10];
        [resultDic setObject:stepKcal forKey:@"stepKcal"];
    }
    
    return resultDic;
}


@end

