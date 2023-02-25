/********************************************************************************
 * 文件名称：FBKProtocolKettleBell.m
 * 内容摘要：壶铃蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年04月02日
 ********************************************************************************/

#import "FBKProtocolKettleBell.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolKettleBell
{
    FBKProNTrackerCmd *m_KettleBellCmd;
    FBKProNTrackerAnalytical *m_KettleBellAnalytical;
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
    
    m_KettleBellCmd = [[FBKProNTrackerCmd alloc] init];
    m_KettleBellCmd.delegate = self;
    
    m_KettleBellAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_KettleBellAnalytical.analyticalDeviceType = BleDeviceKettleBell;
    m_KettleBellAnalytical.delegate = self;
    
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
    m_KettleBellCmd.delegate = nil;
    m_KettleBellCmd = nil;
    
    m_KettleBellAnalytical.delegate = nil;
    m_KettleBellAnalytical = nil;
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
    KettleBellCmdNumber KettleBellCmd = (KettleBellCmdNumber)cmdId;
    
    switch (KettleBellCmd)
    {
        case KettleBellCmdSetTime:
            [m_KettleBellCmd setUTC];
            break;
            
        case KettleBellCmdGetTotalRecord:
            [m_KettleBellCmd getTotalRecordCmd];
            break;
            
        case KettleBellCmdAckCmd:
            [m_KettleBellCmd getAckCmd:(NSString *)object];
            break;
            
        case KettleBellCmdSendCmdSuseed:
            [m_KettleBellCmd sendCmdSuseed:(NSString *)object];
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
        [m_KettleBellAnalytical receiveBlueData:hexString];
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
    [m_KettleBellAnalytical receiveBlueDataError];
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

            m_KettleBellCmd.m_softVersion = softVersion;
            
            [m_KettleBellCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_KettleBellCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_KettleBellCmd getAckCmd:(NSString *)resultData];
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

@end
