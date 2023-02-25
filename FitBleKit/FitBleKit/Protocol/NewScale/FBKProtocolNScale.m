/********************************************************************************
 * 文件名称：FBKProtocolNScale.h
 * 内容摘要：新秤蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月18日
 ********************************************************************************/

#import "FBKProtocolNScale.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolNScale
{
    FBKProNTrackerCmd *m_newScaleCmd;
    FBKProNTrackerAnalytical *m_newScaleAnalytical;
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
    
    m_newScaleCmd = [[FBKProNTrackerCmd alloc] init];
    m_newScaleCmd.delegate = self;
    
    m_newScaleAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_newScaleAnalytical.delegate = self;
    m_newScaleAnalytical.analyticalDeviceType = BleDeviceNewScale;
    
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
    m_newScaleCmd.delegate = nil;
    m_newScaleCmd = nil;
    
    m_newScaleAnalytical.delegate = nil;
    m_newScaleAnalytical = nil;
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
    NScaleCmdNumber trackerCmd = (NScaleCmdNumber)cmdId;
    
    switch (trackerCmd)
    {
        case NScaleCmdSetTime:
            [m_newScaleCmd setUTC];
            break;
            
        case NScaleCmdSetType:
            [m_newScaleCmd setWeightInfoCmd:(NSString *)object andUnit:@"0"];
            break;
            
        case NScaleCmdSetUnit:
            [m_newScaleCmd setWeightInfoCmd:@"8" andUnit:(NSString *)object];
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
    [m_newScaleAnalytical receiveBlueData:hexString];
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_newScaleAnalytical receiveBlueDataError];
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
            
            m_newScaleCmd.m_softVersion = softVersion;
            
            [m_newScaleCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_newScaleCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_newScaleCmd getAckCmd:(NSString *)resultData];
            break;
            
        default:
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
    }
}


@end
