/********************************************************************************
 * 文件名称：FBKProtocolHubConfig.h
 * 内容摘要：HUB蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年07月04日
 ********************************************************************************/

#import "FBKProtocolHubConfig.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolHubConfig
{
    FBKProNTrackerCmd *m_hubConfigCmd;
    FBKProNTrackerAnalytical *m_hubConfigAnalytical;
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
    
    m_hubConfigCmd = [[FBKProNTrackerCmd alloc] init];
    m_hubConfigCmd.delegate = self;
    
    m_hubConfigAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_hubConfigAnalytical.analyticalDeviceType = BleDeviceHubConfig;
    m_hubConfigAnalytical.delegate = self;
    
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
    m_hubConfigCmd.delegate = nil;
    m_hubConfigCmd = nil;
    
    m_hubConfigAnalytical.delegate = nil;
    m_hubConfigAnalytical = nil;
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
    HubConfigCmdNumber hubConfigCmd = (HubConfigCmdNumber)cmdId;
    
    switch (hubConfigCmd)
    {
        case HubConfigCmdLogin:
        {
            [m_hubConfigCmd hubLogin:(NSString *)object];
            break;
        }
            
        case HubConfigCmdGetPassword:
        {
            [m_hubConfigCmd hubPassword:(NSDictionary *)object isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSetPassword:
        {
            [m_hubConfigCmd hubPassword:(NSDictionary *)object isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdGetWifiMode:
        {
            int wifiMode = [(NSString *)object intValue];
            [m_hubConfigCmd hubWifiMode:wifiMode isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSetWifiMode:
        {
            int wifiMode = [(NSString *)object intValue];
            [m_hubConfigCmd hubWifiMode:wifiMode isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdGetWifiSTA:
        {
            [m_hubConfigCmd hubWifiSTA:(NSDictionary *)object staMode:0];
            break;
        }
            
        case HubConfigCmdSetWifiSTA:
        {
            NSDictionary *dataDic = (NSDictionary *)object;
            int setMode = [[dataDic objectForKey:@"setMode"] intValue];
            if (setMode != 1)
            {
                setMode = 2;
            }
            
            [m_hubConfigCmd hubWifiSTA:(NSDictionary *)object staMode:setMode];
            break;
        }
            
        case HubConfigCmdGetWifiSocket:
        {
            [m_hubConfigCmd hubSocketInfo:(NSDictionary *)object isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSetWifiSocket:
        {
            [m_hubConfigCmd hubSocketInfo:(NSDictionary *)object isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdGetNetWorkMode:
        {
            int wifiMode = [(NSString *)object intValue];
            [m_hubConfigCmd hubNetworkMode:wifiMode isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSetNetWorkMode:
        {
            int wifiMode = [(NSString *)object intValue];
            [m_hubConfigCmd hubNetworkMode:wifiMode isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdGetRemark:
        {
            [m_hubConfigCmd hubRemark:(NSString *)object isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSetRemark:
        {
            [m_hubConfigCmd hubRemark:(NSString *)object isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdGetIpKey:
        {
            [m_hubConfigCmd hubGetIpKey];
            break;
        }
            
        case HubConfigCmdScanWifi:
        {
            [m_hubConfigCmd hubScanWifi];
            break;
        }
            
        case HubConfigCmdRestart:
        {
            [m_hubConfigCmd hubRestart];
            break;
        }
            
        case HubConfigCmdReset:
        {
            [m_hubConfigCmd hubReset];
            break;
        }
            
        case HubConfigCmdGetWifiStatus:
        {
            [m_hubConfigCmd hubGetWifiStatus];
            break;
        }
            
        case HubConfigCmdGet4GAPN:
        {
            [m_hubConfigCmd hub4GAPN:(NSString *)object isGetInfo:YES];
            break;
        }
            
        case HubConfigCmdSet4GAPN:
        {
            [m_hubConfigCmd hub4GAPN:(NSString *)object isGetInfo:NO];
            break;
        }
            
        case HubConfigCmdDataType:
        {
            int dataType = [(NSString *)object intValue];
            [m_hubConfigCmd hubSetDataType:dataType];
            break;
        }
            
        case HubConfigCmdScanSwitch:
        {
            int switchNumber = [(NSString *)object intValue];
            [m_hubConfigCmd hubSetScanSwitch:switchNumber];
            break;
        }
            
        case HubConfigCmdScanInfo:
        {
            [m_hubConfigCmd hubScanInfo:(NSDictionary *)object];
            break;
        }
            
        case HubConfigCmdSystemStatus:
        {
            [m_hubConfigCmd hubSystenStatus];
            break;
        }
            
        case HubConfigCmdGetIPV4:
        {
            [m_hubConfigCmd hubIPV4Info:nil isGetInfo:true];
            break;
        }
            
        case HubConfigCmdSetIPV4:
        {
            NSDictionary *dataDic = (NSDictionary *)object;
            [m_hubConfigCmd hubIPV4Info:dataDic isGetInfo:false];
            break;
        }
            
        case HubConfigCmdSetLora:
        {
            [m_hubConfigCmd hubSetLoraNo:(NSDictionary *)object];
            break;
        }
            
        case HubConfigCmdDiagnosisLora:
        {
            [m_hubConfigCmd hubDiagnosisLoraNo:(NSDictionary *)object];
            break;
        }
            
        default:
        {
            break;
        }
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
        [m_hubConfigAnalytical receiveBlueData:hexString];
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
    [m_hubConfigAnalytical receiveBlueDataError];
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
            
            m_hubConfigCmd.m_softVersion = softVersion;
            
            [m_hubConfigCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_hubConfigCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_hubConfigCmd getAckCmd:(NSString *)resultData];
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
