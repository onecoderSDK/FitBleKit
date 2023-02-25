/********************************************************************************
 * 文件名称：FBKProtocolBikeComputer.m
 * 内容摘要：码表蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年02月02日
 ********************************************************************************/

#import "FBKProtocolBikeComputer.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolBikeComputer
{
    FBKProNTrackerCmd *m_bikeComputerCmd;
    FBKProNTrackerAnalytical *m_bikeComputerAnalytical;
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
    
    m_bikeComputerCmd = [[FBKProNTrackerCmd alloc] init];
    m_bikeComputerCmd.delegate = self;
    
    m_bikeComputerAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_bikeComputerAnalytical.delegate = self;
    m_bikeComputerAnalytical.analyticalDeviceType = BleDeviceBikeComputer;
    
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
    m_bikeComputerCmd.delegate = nil;
    m_bikeComputerCmd = nil;
    
    m_bikeComputerAnalytical.delegate = nil;
    m_bikeComputerAnalytical = nil;
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
    BikeComputerCmdNumber trackerCmd = (BikeComputerCmdNumber)cmdId;
    
    switch (trackerCmd)
    {
        case BikeComputerCmdSetTime:
            [m_bikeComputerCmd setUTC];
            break;
            
        case BikeComputerCmdGetFitList:
            [m_bikeComputerCmd getFitNameList];
            break;
            
        case BikeComputerCmdGetFitFile:
            [m_bikeComputerCmd getFitFile:(NSString *)object];
            break;
            
        case BikeComputerCmdDeleteFit:
            [m_bikeComputerCmd deleteFitFile:(NSString *)object andDeleteType:1];
            break;
            
        case BikeComputerCmdDeleteFitHis:
            [m_bikeComputerCmd deleteFitFile:(NSString *)object andDeleteType:2];
            break;
            
        case BikeComputerCmdDeleteFitAll:
            [m_bikeComputerCmd deleteFitFile:(NSString *)object andDeleteType:3];
            break;
            
        case BikeComputerCmdSetZone:
            [m_bikeComputerCmd setFitTimeZone:[(NSString *)object intValue]];
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
    [m_bikeComputerAnalytical receiveBlueData:hexString];
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_bikeComputerAnalytical receiveBlueDataError];
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

            m_bikeComputerCmd.m_softVersion = softVersion;
            
            [m_bikeComputerCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_bikeComputerCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_bikeComputerCmd getAckCmd:(NSString *)resultData];
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
