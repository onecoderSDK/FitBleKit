/********************************************************************************
 * 文件名称：FBKProtocolBase.m
 * 内容摘要：协议基础类
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolBase

/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object
{
    
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSString *)hexString  withUuid:(NSString *)uuid
{
    
}


/********************************************************************************
 * 方法名称：receiveBaseData
 * 功能描述：接收蓝牙原数据(特殊数据)
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)receiveBaseData:(CBCharacteristic *)characteristic;
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    const uint8_t *resultBytes = [characteristic.value bytes];
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < characteristic.value.length; i++) {
        NSString *byteString = [NSString stringWithFormat:@"%C",resultBytes[i]];
        [resultString appendString:byteString];
    }
    
    
    if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKALLDEVICEREPOWER]) {
        NSString *power = [NSString stringWithFormat:@"%i",resultBytes[0]];
        [resultDic setObject:power forKey:@"power"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICEREFIRMVERSION]) {
        [resultDic setObject:resultString forKey:@"firmwareVersion"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICEREHARDVERSION]) {
        [resultDic setObject:resultString forKey:@"hardwareVersion"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICERESOFTVERSION]) {
        [resultDic setObject:resultString forKey:@"softwareVersion"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_SYSTEMID]) {
        NSData *valueData = characteristic.value;
        if (valueData != nil) {
            [resultDic setObject:valueData forKey:@"systemID"];
        }
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_MODEL]) {
        [resultDic setObject:resultString forKey:@"modelString"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_SERIAL]) {
        [resultDic setObject:resultString forKey:@"serialNumber"];
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_MANUFACTURER]) {
        [resultDic setObject:resultString forKey:@"manufacturerName"];
    }
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{

}


@end
