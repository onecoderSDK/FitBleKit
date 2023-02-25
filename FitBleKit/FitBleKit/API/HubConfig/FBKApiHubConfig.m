/********************************************************************************
 * 文件名称：FBKApiHubConfig.h
 * 内容摘要：Hub Config API
 * 版本编号：1.0.1
 * 创建日期：2018年07月04日
 ********************************************************************************/

#import "FBKApiHubConfig.h"
#import "FBKSpliceBle.h"

@implementation FBKApiHubConfig
{
    NSMutableString *m_wifiString;
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
    
    m_wifiString = [[NSMutableString alloc] init];
    self.deviceType = BleDeviceHubConfig;
    [self.managerController setManagerDeviceType:BleDeviceHubConfig];
    
    return self;
}

#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：hubLogin
 * 功能描述：HUB登录
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubLogin:(NSString *)hubPassword
{
    [self.managerController receiveApiCmd:HubConfigCmdLogin withObject:hubPassword];
}


/********************************************************************************
 * 方法名称：getHubPassword
 * 功能描述：获取登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubPassword
{
    [self.managerController receiveApiCmd:HubConfigCmdGetPassword withObject:nil];
}


/********************************************************************************
 * 方法名称：setHubPassword
 * 功能描述：设置登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubPassword:(NSDictionary *)hubPwDic
{
    [self.managerController receiveApiCmd:HubConfigCmdSetPassword withObject:hubPwDic];
}


/********************************************************************************
 * 方法名称：getHubWifiMode
 * 功能描述：获取WiFi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubWifiMode
{
    [self.managerController receiveApiCmd:HubConfigCmdGetWifiMode withObject:nil];
}


/********************************************************************************
 * 方法名称：setHubWifiMode
 * 功能描述：设置WiFi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubWifiMode:(int)wifiMode
{
    NSString *wifiModeString = [NSString stringWithFormat:@"%i",wifiMode];
    [self.managerController receiveApiCmd:HubConfigCmdSetWifiMode withObject:wifiModeString];
}


/********************************************************************************
 * 方法名称：getHubWifiSTA
 * 功能描述：获取 WiFi STA
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubWifiSTA
{
    [self.managerController receiveApiCmd:HubConfigCmdGetWifiSTA withObject:nil];
}

/********************************************************************************
 * 方法名称：hubWifiSTA
 * 功能描述：设置 WiFi STA
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubWifiSTA:(NSDictionary *)hubStaDic
{
    [self.managerController receiveApiCmd:HubConfigCmdSetWifiSTA withObject:hubStaDic];
}


/********************************************************************************
 * 方法名称：getHubSocketInfo
 * 功能描述：获取Socket信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubSocketInfo:(NSDictionary *)hubSocketDic
{
    [self.managerController receiveApiCmd:HubConfigCmdGetWifiSocket withObject:hubSocketDic];
}


/********************************************************************************
 * 方法名称：setHubSocketInfo
 * 功能描述：设置Socket信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubSocketInfo:(NSDictionary *)hubSocketDic
{
    [self.managerController receiveApiCmd:HubConfigCmdSetWifiSocket withObject:hubSocketDic];
}


/********************************************************************************
 * 方法名称：getHubNetworkMode
 * 功能描述：获取HUB内外网模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubNetWorkMode
{
    [self.managerController receiveApiCmd:HubConfigCmdGetNetWorkMode withObject:nil];
}


/********************************************************************************
 * 方法名称：setHubNetworkMode
 * 功能描述：设置HUB内外网模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubNetWorkMode:(int)networkMode
{
    NSString *networkModeStr = [NSString stringWithFormat:@"%i",networkMode];
    [self.managerController receiveApiCmd:HubConfigCmdSetNetWorkMode withObject:networkModeStr];
}


/********************************************************************************
 * 方法名称：getHubRemark
 * 功能描述：获取HUB备注
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubRemark
{
    [self.managerController receiveApiCmd:HubConfigCmdGetRemark withObject:nil];
}


/********************************************************************************
 * 方法名称：setHubRemark
 * 功能描述：设置HUB备注
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHubRemark:(NSString *)markString
{
    [self.managerController receiveApiCmd:HubConfigCmdSetRemark withObject:markString];
}


/********************************************************************************
 * 方法名称：getHubIpKey
 * 功能描述：获取HUB IP key
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubIpKey
{
    [self.managerController receiveApiCmd:HubConfigCmdGetIpKey withObject:nil];
}


/********************************************************************************
 * 方法名称：scanHubWifi
 * 功能描述：HUB扫描WiFi
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)scanHubWifi
{
    [self.managerController receiveApiCmd:HubConfigCmdScanWifi withObject:nil];
}


/********************************************************************************
 * 方法名称：restartHub
 * 功能描述：HUB复位重启
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)restartHub
{
    [self.managerController receiveApiCmd:HubConfigCmdRestart withObject:nil];
}


/********************************************************************************
 * 方法名称：resetHub
 * 功能描述：HUB恢复出厂设置
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)resetHub
{
    [self.managerController receiveApiCmd:HubConfigCmdReset withObject:nil];
}


/********************************************************************************
 * 方法名称：getHubWifiStatus
 * 功能描述：获取WiFi状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHubWifiStatus
{
    [self.managerController receiveApiCmd:HubConfigCmdGetWifiStatus withObject:nil];
}


/*-******************************************************************************
* 方法名称：getHub4GAPN
* 功能描述：获取4G APN信息
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)getHub4GAPN
{
    [self.managerController receiveApiCmd:HubConfigCmdGet4GAPN withObject:nil];
}


/*-******************************************************************************
* 方法名称：setHub4GAPN
* 功能描述：配置4G APN信息
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setHub4GAPN:(NSString *)APNString
{
    [self.managerController receiveApiCmd:HubConfigCmdSet4GAPN withObject:APNString];
}


/*-******************************************************************************
* 方法名称：setHubDataType
* 功能描述：设置数据上下行模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setHubDataType:(int)dataType
{
    NSString *dataTypeString = [NSString stringWithFormat:@"%i",dataType];
    [self.managerController receiveApiCmd:HubConfigCmdDataType withObject:dataTypeString];
}


/*-******************************************************************************
* 方法名称：setHubScanSwitch
* 功能描述：设置扫描开关
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setHubScanSwitch:(int)scanSwitch
{
    NSString *scanSwitchString = [NSString stringWithFormat:@"%i",scanSwitch];
    [self.managerController receiveApiCmd:HubConfigCmdScanSwitch withObject:scanSwitchString];
}


/*-******************************************************************************
* 方法名称：hubScanInfo
* 功能描述：设置蓝牙扫描参数
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)hubScanInfo:(NSDictionary *)hubScanDic
{
    [self.managerController receiveApiCmd:HubConfigCmdScanInfo withObject:hubScanDic];
}


/*-******************************************************************************
* 方法名称：hubSystenStatus
* 功能描述：获取系统状态
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)hubSystenStatus
{
    [self.managerController receiveApiCmd:HubConfigCmdSystemStatus withObject:nil];
}

// 获取IPV4信息
- (void)getIPV4Info {
    [self.managerController receiveApiCmd:HubConfigCmdGetIPV4 withObject:nil];
}

// 设置IPV4信息
- (void)setIPV4Info:(NSDictionary *)ipvMap{
    [self.managerController receiveApiCmd:HubConfigCmdSetIPV4 withObject:ipvMap];
}

// 设置Lora通道
- (void)setLoraChannel:(NSDictionary *)loraMap {
    [self.managerController receiveApiCmd:HubConfigCmdSetLora withObject:loraMap];
}

// 诊断Lora通道
- (void)diagnosisLoraChannel:(NSDictionary *)loraMap {
    [self.managerController receiveApiCmd:HubConfigCmdDiagnosisLora withObject:loraMap];
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
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate hubVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubLoginStatus:
        {
            NSDictionary *dataDic = (NSDictionary *)resultData;
            NSString *statusString = [dataDic objectForKey:@"hubLoginStatus"];
            
            if ([statusString isEqualToString:@"1"])
            {
                [self.delegate hubLoginStatus:NO andDevice:self];
            }
            else
            {
                [self.delegate hubLoginStatus:YES andDevice:self];
            }
            
            break;
        }
            
        case FBKAnalyticalHubLoginPw:
        {
            [self.delegate hubLoginPassword:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubWifiWorkMode:
        {
            NSDictionary *dataDic = (NSDictionary *)resultData;
            NSString *hubWorkMode = [dataDic objectForKey:@"hubWorkMode"];
            [self.delegate hubWifiWorkMode:hubWorkMode andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubWifiSTA:
        {
            [self.delegate hubWifiSTAInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubWifiSocket:
        {
            [self.delegate hubWifiSocketInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubNetWorkMode:
        {
            NSDictionary *dataDic = (NSDictionary *)resultData;
            NSString *hubNetWorkMode = [dataDic objectForKey:@"hubNetWorkMode"];
            [self.delegate hubNetWorkMode:hubNetWorkMode andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubRemark:
        {
            NSDictionary *dataDic = (NSDictionary *)resultData;
            NSString *hubRemark = [dataDic objectForKey:@"hubRemark"];
            [self.delegate hubRemarkInfo:hubRemark andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubIpKey:
        {
            [self.delegate hubIpKeyInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubWifiList:
        {
            NSDictionary *dataDic = (NSDictionary *)resultData;
            int totalNum = [[dataDic objectForKey:@"totalNum"] intValue];
            int sortNum = [[dataDic objectForKey:@"sortNum"] intValue];
            int wifiModel = [[dataDic objectForKey:@"wifiModel"] intValue];
            NSString *wifiString = [dataDic objectForKey:@"wifiString"];
            if (sortNum == 1)
            {
                m_wifiString = [[NSMutableString alloc] init];
                [m_wifiString appendString:wifiString];
            }
            else if (sortNum == totalNum)
            {
                [m_wifiString appendString:wifiString];
                
                
                NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:[self getWifiResultList:m_wifiString withWifiModel:wifiModel]];
                [self.delegate hubWifiList:resultArray andDevice:self];
                
                m_wifiString = [[NSMutableString alloc] init];
            }
            else
            {
                [m_wifiString appendString:wifiString];
            }
            
            break;
        }
            
        case FBKAnalyticalHubWifiStatus:
        {
            [self.delegate hubWifiStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHub4GAPN:
        {
            [self.delegate hub4GAPN:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubSystemStatus:
        {
            [self.delegate hubSystemStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalHubIPV4:
        {
            [self.delegate hubIPV4Info:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalSetLora:
        {
            [self.delegate hubSetLoraResult:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalDiagnosisLora:
        {
            [self.delegate hubDiagnosisLoraResult:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：getWifiResultList
 * 功能描述：获取WiFi列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getWifiResultList:(NSString *)wifiString withWifiModel:(int)model
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    wifiString = [wifiString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n\r"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:[wifiString componentsSeparatedByString:@"\n\r"]];
    
    if (dataArray.count > 0)
    {
        if (model == 0)
        {
            for (int i = 0; i < dataArray.count; i++)
            {
                NSString *detailString = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:i]];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSMutableArray *detailArray = [[NSMutableArray alloc] initWithArray:[detailString componentsSeparatedByString:@","]];
                
                if (detailArray.count >= 4)
                {
                    NSString *comString = [detailArray objectAtIndex:0];
                    if (![comString isEqualToString:@"Ch"])
                    {
                        NSString *ssidString = [detailArray objectAtIndex:1];
                        NSString *ssidAssi = [[NSString alloc] initWithString:[FBKSpliceBle stringToAscii:ssidString]];
                        NSData *ssidData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:ssidAssi]];
                        NSString *ssidResult = [[NSString alloc] initWithData:ssidData encoding:NSUTF8StringEncoding];
                        if (ssidResult == nil) {
                            ssidResult = ssidString;
                        }
                        
                        NSString *mode = [detailArray objectAtIndex:3];
                        NSMutableArray *modeArray = [[NSMutableArray alloc] initWithArray:[mode componentsSeparatedByString:@"/"]];
                        
                        NSMutableDictionary *encryptionDic = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *algorithmDic  = [[NSMutableDictionary alloc] init];
                        if (modeArray.count == 2)
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:[modeArray objectAtIndex:0]]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:[modeArray objectAtIndex:1]]];
                        }
                        else if (modeArray.count == 1)
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:[modeArray objectAtIndex:0]]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:[modeArray objectAtIndex:0]]];
                        }
                        else
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:@""]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:@""]];
                        }
                        
                        NSMutableDictionary *wifiInfoDic = [[NSMutableDictionary alloc] init];
                        [wifiInfoDic addEntriesFromDictionary:algorithmDic];
                        [wifiInfoDic addEntriesFromDictionary:encryptionDic];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:1] forKey:@"hubSsid"];
                        [wifiInfoDic setObject:ssidResult forKey:@"ssidName"];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:2] forKey:@"wifiMac"];
                        [resultArray addObject:wifiInfoDic];
                    }
                }
            }
        }
        else if (model == 1)
        {
            for (int i = 0; i < dataArray.count; i++)
            {
                NSString *detailString = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:i]];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSMutableArray *detailArray = [[NSMutableArray alloc] initWithArray:[detailString componentsSeparatedByString:@","]];
                
                if (detailArray.count >= 4)
                {
                    NSString *comString = [detailArray objectAtIndex:0];
                    if (![comString isEqualToString:@"Ch"])
                    {
                        NSString *ssidString = [detailArray objectAtIndex:1];
                        NSString *ssidAssi = [[NSString alloc] initWithString:[FBKSpliceBle stringToAscii:ssidString]];
                        NSData *ssidData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:ssidAssi]];
                        NSString *ssidResult = [[NSString alloc] initWithData:ssidData encoding:NSUTF8StringEncoding];
                        if (ssidResult == nil) {
                            ssidResult = ssidString;
                        }
                        
                        NSString *mode = [detailArray objectAtIndex:3];
                        NSMutableArray *modeArray = [[NSMutableArray alloc] initWithArray:[mode componentsSeparatedByString:@"/"]];
                        
                        NSMutableDictionary *encryptionDic = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary *algorithmDic  = [[NSMutableDictionary alloc] init];
                        if (modeArray.count == 2)
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:[modeArray objectAtIndex:0]]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:[modeArray objectAtIndex:1]]];
                        }
                        else if (modeArray.count == 1)
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:[modeArray objectAtIndex:0]]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:[modeArray objectAtIndex:0]]];
                        }
                        else
                        {
                            [encryptionDic addEntriesFromDictionary:[self getHubEncryption:@""]];
                            [algorithmDic addEntriesFromDictionary:[self getHubAlgorithm:@""]];
                        }
                        
                        NSMutableDictionary *wifiInfoDic = [[NSMutableDictionary alloc] init];
                        [wifiInfoDic addEntriesFromDictionary:algorithmDic];
                        [wifiInfoDic addEntriesFromDictionary:encryptionDic];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:1] forKey:@"hubSsid"];
                        [wifiInfoDic setObject:ssidResult forKey:@"ssidName"];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:2] forKey:@"wifiMac"];
                        [resultArray addObject:wifiInfoDic];
                    }
                }
            }
        }
        else if (model == 2)
        {
            for (int i = 0; i < dataArray.count; i++)
            {
                NSString *detailString = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:i]];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                detailString = [detailString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSMutableArray *detailArray = [[NSMutableArray alloc] initWithArray:[detailString componentsSeparatedByString:@","]];
                
                if (detailArray.count >= 6)
                {
                    NSString *comString = [detailArray objectAtIndex:0];
                    if (![comString isEqualToString:@"RSSI"])
                    {
                        NSString *ssidString = [detailArray objectAtIndex:1];
                        NSString *ssidAssi = [[NSString alloc] initWithString:[FBKSpliceBle stringToAscii:ssidString]];
                        NSData *ssidData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:ssidAssi]];
                        NSString *ssidResult = [[NSString alloc] initWithData:ssidData encoding:NSUTF8StringEncoding];
                        if (ssidResult == nil) {
                            ssidResult = ssidString;
                        }
                        
                        NSMutableDictionary *encryptionDic = [[NSMutableDictionary alloc] initWithDictionary:[self getHubEncryption:[detailArray objectAtIndex:5]]];
                        NSMutableDictionary *algorithmDic  = [[NSMutableDictionary alloc] initWithDictionary:[self getHubAlgorithm:[detailArray objectAtIndex:4]]];
                        
                        NSMutableDictionary *wifiInfoDic = [[NSMutableDictionary alloc] init];
                        [wifiInfoDic addEntriesFromDictionary:algorithmDic];
                        [wifiInfoDic addEntriesFromDictionary:encryptionDic];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:1] forKey:@"hubSsid"];
                        [wifiInfoDic setObject:ssidResult forKey:@"ssidName"];
                        [wifiInfoDic setObject:[detailArray objectAtIndex:2] forKey:@"wifiMac"];
                        [resultArray addObject:wifiInfoDic];
                    }
                }
            }
        }
    }
    
    return resultArray;
}


/********************************************************************************
 * 方法名称：getHubEncryption
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)getHubEncryption:(NSString *)hubEncryption
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSString *valueString = [hubEncryption uppercaseString];
    
    if ([valueString containsString:@"WPA2PSK"])
    {
        [resultDic setObject:@"4" forKey:@"hubEncryption"];
        [resultDic setObject:@"WPA2PSK" forKey:@"encryptionName"];
    }
    else if ([valueString containsString:@"WPAPSK"] || [valueString containsString:@"WPA1PSK"])
    {
        [resultDic setObject:@"3" forKey:@"hubEncryption"];
        [resultDic setObject:@"WPAPSK" forKey:@"encryptionName"];
    }
    else if ([valueString containsString:@"SHARED"])
    {
        [resultDic setObject:@"2" forKey:@"hubEncryption"];
        [resultDic setObject:@"SHARED" forKey:@"encryptionName"];
    }
    else if ([valueString containsString:@"OPEN"])
    {
        [resultDic setObject:@"1" forKey:@"hubEncryption"];
        [resultDic setObject:@"OPEN" forKey:@"encryptionName"];
    }
    else
    {
        [resultDic setObject:@"0" forKey:@"hubEncryption"];
        [resultDic setObject:@"NULL" forKey:@"encryptionName"];
    }
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：getHubAlgorithm
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)getHubAlgorithm:(NSString *)hubAlgorithm
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSString *valueString = [hubAlgorithm uppercaseString];
    
    if ([valueString containsString:@"AES"])
    {
        [resultDic setObject:@"5" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"AES" forKey:@"algorithmName"];
    }
    else if ([valueString containsString:@"TKIP"])
    {
        [resultDic setObject:@"4" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"TKIP" forKey:@"algorithmName"];
    }
    else if ([valueString containsString:@"WEP_A"] || [valueString containsString:@"WEP-A"])
    {
        [resultDic setObject:@"3" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"WEP_A" forKey:@"algorithmName"];
    }
    else if ([valueString containsString:@"WEP_H"] || [valueString containsString:@"WEP-H"])
    {
        [resultDic setObject:@"2" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"WEP_H" forKey:@"algorithmName"];
    }
    else if ([valueString containsString:@"NONE"])
    {
        [resultDic setObject:@"1" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"NONE" forKey:@"algorithmName"];
    }
    else
    {
        [resultDic setObject:@"0" forKey:@"hubAlgorithm"];
        [resultDic setObject:@"NULL" forKey:@"algorithmName"];
    }
    
    return resultDic;
}


@end
