/********************************************************************************
 * 文件名称：FBKProtocolOldScale.h
 * 内容摘要：老秤蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolOldScale.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolOldScale
{
    FBKProOldScaleCmd *m_oldScaleCmd;
    FBKProOldScaleAnalytical *m_oldScaleAnalytical;
    FBKDeviceScaleInfo *m_oldScaleInfo;
    BOOL m_isConnect;
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
    
    m_oldScaleCmd = [[FBKProOldScaleCmd alloc] init];
    m_oldScaleCmd.delegate = self;
    
    m_oldScaleAnalytical = [[FBKProOldScaleAnalytical alloc] init];
    m_oldScaleAnalytical.delegate = self;
    
    m_oldScaleInfo = [[FBKDeviceScaleInfo alloc] init];
    
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
    m_oldScaleCmd.delegate = nil;
    m_oldScaleCmd = nil;
    
    m_oldScaleAnalytical.delegate = nil;
    m_oldScaleAnalytical = nil;
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
    OldScaleCmdNumber oldScaleCmd = (OldScaleCmdNumber)cmdId;
    
    switch (oldScaleCmd)
    {
        case OldScaleCmdSetTime:
            [m_oldScaleCmd setWeightTimeData];
            break;
            
        case OldScaleCmdSetUserInfo:
            m_oldScaleInfo = (FBKDeviceScaleInfo *)object;
            [m_oldScaleCmd setUserInfo:m_oldScaleInfo];
            break;
            
        case OldScaleCmdSetUnit:
            [m_oldScaleCmd setDeviceUnit:(NSString *)object];
            break;
            
        case OldScaleCmdGetInfo:
            [m_oldScaleCmd getDeviceBaseInfo];
            break;
            
        case OldScaleCmdAddUser:
            [m_oldScaleCmd editUserNumberData:(FBKDeviceScaleInfo *)object andEditState:@"0"];
            break;
            
        case OldScaleCmdDeleUser:
            [m_oldScaleCmd editUserNumberData:(FBKDeviceScaleInfo *)object andEditState:@"1"];
            break;
            
        case OldScaleCmdTipUser:
            m_oldScaleInfo = (FBKDeviceScaleInfo *)object;
            [m_oldScaleCmd editUserNumberData:(FBKDeviceScaleInfo *)object andEditState:@"2"];
            break;
            
        case OldScaleCmdAckCmd:
            [m_oldScaleCmd ackCmd:(NSString *)object];
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
    [m_oldScaleAnalytical receiveBlueData:hexString];
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_oldScaleAnalytical receiveBlueDataError];
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
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalOScale)resultNumber
{
    switch (resultNumber)
    {
        case FBKAnalyOScaleAck:
        {
            int commandNum = [[(NSDictionary *)resultData objectForKey:@"commandNum"] intValue];
            if (commandNum == 1)
            {
//                NSLog(@"m_oldScaleInfo is %@",m_oldScaleInfo.scaleHeight);
                [m_oldScaleCmd setUserInfo:m_oldScaleInfo];
            }
            else if (commandNum == 2)
            {
                [m_oldScaleCmd setDeviceUnit:@"0"];
            }
            break;
        }
            
        case FBKAnalyOScaleError:
        {
            break;
        }
            
        case FBKAnalyOScaleRealTime:
        {
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyOScaleUserInfo:
        {
            NSDictionary *user1 = [(NSDictionary *)resultData objectForKey:@"user1"];
            
            if ([m_oldScaleInfo.scaleUserId intValue] > 8)
            {
                if (user1 != nil)
                {
                    NSString *weightID = [NSString stringWithFormat:@"%@",[user1 objectForKey:@"weight_ID"]];
                    NSString *weightAge = [NSString stringWithFormat:@"%@",[user1 objectForKey:@"weight_age"]];
                    NSString *weightSex = [NSString stringWithFormat:@"%@",[user1 objectForKey:@"weight_gender"]];
                    NSString *weightHeight = [NSString stringWithFormat:@"%@",[user1 objectForKey:@"weight_height"]];
                    
                    FBKDeviceScaleInfo *oldScaleInfo = [[FBKDeviceScaleInfo alloc] init];
                    oldScaleInfo.scaleUserId = weightID;
                    oldScaleInfo.scaleHeight = weightHeight;
                    oldScaleInfo.scaleAge = weightAge;
                    oldScaleInfo.scaleGender = weightSex;
                    m_oldScaleInfo = oldScaleInfo;
                }
            }
            
            [m_oldScaleCmd editUserNumberData:m_oldScaleInfo andEditState:@"2"];
            
            NSString *ackNum = [(NSDictionary *)resultData objectForKey:@"weightMark"];
            [m_oldScaleCmd ackCmd:ackNum];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        default:
        {
            NSString *ackNum = [(NSDictionary *)resultData objectForKey:@"weightMark"];
            [m_oldScaleCmd ackCmd:ackNum];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
    }
}


@end

