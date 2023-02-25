/********************************************************************************
 * 文件名称：FBKAnalyticalHubConfig.h
 * 内容摘要：hub配置数据解析
 * 版本编号：1.0.1
 * 创建日期：2018年06月27日
 ********************************************************************************/

#import "FBKAnalyticalHubConfig.h"
#import "FBKSpliceBle.h"

@implementation FBKAnalyticalHubConfig


/********************************************************************************
 * 方法名称：loginStatus
 * 功能描述：上传HUB登录状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)loginStatus:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int loginStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",loginStatus] forKey:@"hubLoginStatus"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：loginPassword
 * 功能描述：上传hub登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)loginPassword:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int isHavePw = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *password = [[NSMutableString alloc] init];
    if (isHavePw == 1)
    {
        for (int i = 0; i < hexArray.count-2; i++)
        {
            unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
            NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
            [password appendString:asciiCodeStr];
            offSet++;
        }
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",isHavePw] forKey:@"hubIsHavePw"];
    [resultDic setObject:password forKey:@"hubPassword"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiWorkMode
 * 功能描述：上传wifi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiWorkMode:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int workMode = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",workMode] forKey:@"hubWorkMode"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiSTAInfo
 * 功能描述：上传 WIFI STA 信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiSTAInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int ssidLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ssidString = [[NSMutableString alloc] init];
    for (int i = 0; i < ssidLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ssidString appendString:asciiCodeStr];
        offSet++;
    }
    
    int encryption = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int algorithm = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int passwordLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *password = [[NSMutableString alloc] init];
    for (int i = 0; i < passwordLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [password appendString:asciiCodeStr];
        offSet++;
    }
    
    NSString *ssidAssi = [[NSString alloc] initWithString:[FBKSpliceBle stringToAscii:ssidString]];
    NSData *ssidData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:ssidAssi]];
    NSString *ssidResult = [[NSString alloc] initWithData:ssidData encoding:NSUTF8StringEncoding];
    
    [resultDic setObject:ssidString forKey:@"hubSsid"];
    [resultDic setObject:ssidResult forKey:@"ssidName"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",encryption] forKey:@"hubEncryption"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",algorithm] forKey:@"hubAlgorithm"];
    [resultDic setObject:password forKey:@"hubPassword"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiSocketInfo
 * 功能描述：上传 wifi Socket 信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiSocketInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int hubSocketNo = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int hubSocketProtocol = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int hubSocketCs = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int ipLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ipString = [[NSMutableString alloc] init];
    for (int i = 0; i < ipLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ipString appendString:asciiCodeStr];
        offSet++;
    }
    
    int portLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *portString = [[NSMutableString alloc] init];
    for (int i = 0; i < portLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [portString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketNo] forKey:@"hubSocketNo"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketProtocol] forKey:@"hubSocketProtocol"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketCs] forKey:@"hubSocketCs"];
    [resultDic setObject:ipString forKey:@"hubSocketIp"];
    [resultDic setObject:portString forKey:@"hubSocketPort"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：netWorkMode
 * 功能描述：上传HUB内外网模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)netWorkMode:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int netWorkMode = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",netWorkMode] forKey:@"hubNetWorkMode"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubRemarkInfo
 * 功能描述：上传HUB备注信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubRemarkInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    NSMutableString *remarkString = [[NSMutableString alloc] init];
    for (int i = 0; i < hexArray.count-1; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [remarkString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:remarkString forKey:@"hubRemark"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubIpKey
 * 功能描述：上传HUB IP
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubIpKey:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int ipLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ipString = [[NSMutableString alloc] init];
    for (int i = 0; i < ipLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ipString appendString:asciiCodeStr];
        offSet++;
    }
    
    int maskLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *maskString = [[NSMutableString alloc] init];
    for (int i = 0; i < maskLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [maskString appendString:asciiCodeStr];
        offSet++;
    }
    
    int gateWayLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *gateWayString = [[NSMutableString alloc] init];
    for (int i = 0; i < gateWayLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [gateWayString appendString:asciiCodeStr];
        offSet++;
    }
    
    NSString *maskResString;
    maskResString = [maskString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    maskResString = [maskResString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    [resultDic setObject:ipString forKey:@"hubIp"];
    [resultDic setObject:maskResString forKey:@"hubMask"];
    [resultDic setObject:gateWayString forKey:@"hubGateWay"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubWifiList
 * 功能描述：上传wifi列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubWifiList:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int totalNum = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int sortNum = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int wifiModel = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *wifiString = [[NSMutableString alloc] init];
    for (int i = 0; i < hexArray.count-4; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [wifiString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",totalNum] forKey:@"totalNum"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",sortNum] forKey:@"sortNum"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",wifiModel] forKey:@"wifiModel"];
    [resultDic setObject:wifiString forKey:@"wifiString"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubWifiStatus
 * 功能描述：上传wifi状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubWifiStatus:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int cfgStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int connectStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",cfgStatus] forKey:@"hubWifiCfgStatus"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",connectStatus] forKey:@"hubWifiConnectStatus"];
    
    return resultDic;
}


/*-******************************************************************************
* 方法名称：hub4GAPNStatus
* 功能描述：上传4G APN信息
* 输入参数：
* 返回数据：
********************************************************************************/
- (NSDictionary *)hub4GAPNStatus:(NSArray *)hexArray{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    NSMutableString *APNString = [[NSMutableString alloc] init];
    for (int i = 0; i < hexArray.count-1; i++) {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [APNString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:APNString forKey:@"hub4GAPN"];
    return resultDic;
}


/*-******************************************************************************
* 方法名称：hubSystemStatus
* 功能描述：上传系统状态
* 输入参数：
* 返回数据：
********************************************************************************/
- (NSDictionary *)hubSystemStatus:(NSArray *)hexArray{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int dataType = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int scanSwitch = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int nameLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *nameString = [[NSMutableString alloc] init];
    for (int i = 0; i < nameLen; i++) {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [nameString appendString:asciiCodeStr];
        offSet++;
    }
    
    int uuidLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *uuidString = [[NSMutableString alloc] init];
    for (int i = 0; i < uuidLen; i++) {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [FBKSpliceBle decimalToHex:asciiCode];
        [uuidString appendString:asciiCodeStr];
        offSet++;
    }
    
    int rssi = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int communicationMode = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int etherneStatus= [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int wifiStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int status4G = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int loraStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    if (loraStatus == 1) {
        int totalChannel = [[self noFlashString:hexArray withRow:offSet] intValue];
        offSet++;
        
        int nowChannel = [[self noFlashString:hexArray withRow:offSet] intValue];
        offSet++;
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",totalChannel] forKey:@"loraChannels"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",nowChannel] forKey:@"nowChannel"];
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",dataType] forKey:@"dataType"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",scanSwitch] forKey:@"scanSwitch"];
    [resultDic setObject:nameString forKey:@"name"];
    [resultDic setObject:uuidString forKey:@"uuid"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",(char) rssi] forKey:@"rssi"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",communicationMode] forKey:@"communicationMode"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",etherneStatus] forKey:@"etherneStatus"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",wifiStatus] forKey:@"wifiStatus"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",status4G] forKey:@"status4G"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",loraStatus] forKey:@"loraStatus"];
    
    return resultDic;
}


/*-******************************************************************************
* 方法名称：hubIPV4Info
* 功能描述：上传IPV4数据
* 输入参数：
* 返回数据：
********************************************************************************/
- (NSDictionary *)hubIPV4Info:(NSArray *)hexArray {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int ipType = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int dnsType = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ipString = [[NSMutableString alloc] init];
    NSMutableString *maskString = [[NSMutableString alloc] init];
    NSMutableString *gatewayString = [[NSMutableString alloc] init];
    NSMutableString *dnsString = [[NSMutableString alloc] init];
    NSMutableString *spareDnsString = [[NSMutableString alloc] init];

    if (hexArray.count >= 7) {
        for (int i = 0; i < 4; i++) {
            int value = [[self noFlashString:hexArray withRow:offSet] intValue];
            [ipString appendFormat:@"%i",value];
            if (i != 3) {
                [ipString appendString:@"."];
            }
            offSet++;
        }
    }
        
    if (hexArray.count >= 11) {
        for (int i = 0; i < 4; i++) {
            int value = [[self noFlashString:hexArray withRow:offSet] intValue];
            [maskString appendFormat:@"%i",value];
            if (i != 3) {
                [maskString appendString:@"."];
            }
            offSet++;
        }
    }
        
    if (hexArray.count >= 15) {
        for (int i = 0; i < 4; i++) {
            int value = [[self noFlashString:hexArray withRow:offSet] intValue];
            [gatewayString appendFormat:@"%i",value];
            if (i != 3) {
                [gatewayString appendString:@"."];
            }
            offSet++;
        }
    }
        
    if (hexArray.count >= 19) {
        for (int i = 0; i < 4; i++) {
            int value = [[self noFlashString:hexArray withRow:offSet] intValue];
            [dnsString appendFormat:@"%i",value];
            if (i != 3) {
                [dnsString appendString:@"."];
            }
            offSet++;
        }
    }
        
    if (hexArray.count >= 23) {
        for (int i = 0; i < 4; i++) {
            int value = [[self noFlashString:hexArray withRow:offSet] intValue];
            [spareDnsString appendFormat:@"%i",value];
            if (i != 3) {
                [spareDnsString appendString:@"."];
            }
            offSet++;
        }
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",ipType] forKey:@"ipType"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",dnsType] forKey:@"dnsType"];
    [resultDic setObject:ipString forKey:@"ip"];
    [resultDic setObject:maskString forKey:@"mask"];
    [resultDic setObject:gatewayString forKey:@"gateway"];
    [resultDic setObject:dnsString forKey:@"dns"];
    [resultDic setObject:spareDnsString forKey:@"spareDns"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubSetLoraResult
 * 功能描述：设置Lora结果
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubSetLoraResult:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int nowChannel = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int devicesNumber = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableArray *statusArray = [[NSMutableArray alloc] init];
    if (hexArray.count > 10) {
        for (int i = 0; i < 8; i++) {
            int status = [[self noFlashString:hexArray withRow:offSet] intValue];
            offSet++;
            
            for (int j = 0; j < 8; j++) {
                int resultNo = [FBKSpliceBle getBitNumber:status andStart:j withStop:j];
                [statusArray addObject:[NSString stringWithFormat:@"%i",resultNo]];
                if (devicesNumber == statusArray.count) {
                    break;
                }
            }
            
            if (devicesNumber == statusArray.count) {
                break;
            }
        }
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",nowChannel] forKey:@"nowChannel"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",devicesNumber] forKey:@"devicesNumber"];
    [resultDic setObject:statusArray forKey:@"statusArray"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubDiagnosisLoraResult
 * 功能描述：诊断Lora结果
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubDiagnosisLoraResult:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int nowChannel = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int rssiLow = [[self noFlashString:hexArray withRow:offSet] intValue];
    int rssiHi  = [[self noFlashString:hexArray withRow:offSet+1] intValue];
    int rssiNo  = (rssiHi<<8) + rssiLow;
    rssiNo = (int)[FBKSpliceBle getSignedData:rssiNo andCount:2];
    
    offSet = offSet + 2;
    
    int status = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",nowChannel] forKey:@"nowChannel"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",rssiNo] forKey:@"rssi"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",status] forKey:@"status"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：noFlashString
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)noFlashString:(NSArray *)hexArray withRow:(int)myRow
{
    if (myRow < hexArray.count)
    {
        return [hexArray objectAtIndex:myRow];
    }
    else
    {
        return @"error";
    }
}


@end
