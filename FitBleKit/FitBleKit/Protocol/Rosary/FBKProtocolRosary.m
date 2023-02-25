/********************************************************************************
 * 文件名称：FBKProtocolRosary.m
 * 内容摘要：念珠蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolRosary.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolRosary
{
    FBKProRosaryCmd *m_rosaryCmd;
    FBKProRosaryAnalytical *m_rosaryAnalytical;
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
    
    m_rosaryCmd = [[FBKProRosaryCmd alloc] init];
    m_rosaryCmd.delegate = self;
    
    m_rosaryAnalytical = [[FBKProRosaryAnalytical alloc] init];
    m_rosaryAnalytical.delegate = self;
    
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
    m_rosaryCmd.delegate = nil;
    m_rosaryCmd = nil;
    
    m_rosaryAnalytical.delegate = nil;
    m_rosaryAnalytical = nil;
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
    RosaryCmdNumber rosaryCmd = (RosaryCmdNumber)cmdId;
    
    switch (rosaryCmd)
    {
        case RosaryCmdEditMode:
            [m_rosaryCmd changeDeviceMode:(NSString *)object];
            break;
            
        case RosaryCmdSearchRemind:
            [m_rosaryCmd SearchOrSetNotice:@"1" andNoticeType:(NSString *)object];
            break;
            
        case RosaryCmdSetRemind:
             [m_rosaryCmd SearchOrSetNotice:@"2" andNoticeType:(NSString *)object];
            break;
            
        case RosaryCmdSearchPower:
            [m_rosaryCmd searchPower];
            break;
            
        case RosaryCmdSearchBeadNum:
            [m_rosaryCmd searchBeadNumber:@"1" andBeadNumber:(NSString *)object];
            break;
            
        case RosaryCmdSetBeadNum:
            [m_rosaryCmd searchBeadNumber:@"2" andBeadNumber:(NSString *)object];
            break;
            
        case RosaryCmdGetRTSteps:
            [m_rosaryCmd getRealTimeSteps];
            break;
            
        case RosaryCmdRTNumber:
            [m_rosaryCmd getBeadNumbers];
            break;
            
        case RosaryCmdSetTime:
            [m_rosaryCmd setDeviceTime];
            break;
            
        case RosaryCmdSetRemiadList:
            [m_rosaryCmd setNoticeSetting:(NSDictionary *)object];
            break;
            
        case RosaryCmdSetBookId:
            [m_rosaryCmd setBookId:(NSString *)object];
            break;
            
        case RosaryCmdSetAncs:
            [m_rosaryCmd bluetoothPairing:(NSString *)object];
            break;
            
        case RosaryCmdGetRecord:
            [m_rosaryCmd getBeadHistory];
            break;
            
        case RosaryCmdGetNowStatus:
            [m_rosaryCmd getBeadMode];
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
    [m_rosaryAnalytical receiveBlueData:hexString];
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
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalRosary)resultNumber
{
    NSDictionary *valueDic = (NSDictionary *)resultData;
    int cmdNum = [[valueDic objectForKey:@"cmdId"] intValue];
    
    [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
    
    if (cmdNum < 99)
    {
        if (cmdNum == 6)
        {
            [m_rosaryCmd callbackHis:[NSString stringWithFormat:@"%i",cmdNum] andBagId:[valueDic objectForKey:@"totalBag"]];
        }
        else
        {
            [m_rosaryCmd callbackCMD:[NSString stringWithFormat:@"%i",cmdNum]];
        }
    }
    
    if (resultNumber == FBKAnalyticalRosaryRecordStatus)
    {
        [self.delegate synchronizationStatus:DeviceBleSyncOver];
    }
    else if (resultNumber == FBKAnalyticalRosaryRecord)
    {
        [self.delegate synchronizationStatus:DeviceBleSynchronization];
    }
}


@end

