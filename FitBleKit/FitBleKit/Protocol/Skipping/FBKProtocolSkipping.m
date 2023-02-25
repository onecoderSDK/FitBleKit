/********************************************************************************
 * 文件名称：FBKProtocolSkipping.m
 * 内容摘要：跳绳蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolSkipping.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolSkipping

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
    return self;
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
    return;
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid {
    const uint8_t *bytes = [hexData bytes];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    int c2 = bytes[2]&0xFF;
    int c3 = bytes[3]&0xFF;
    int c4 = bytes[4]&0xFF;
    int c5 = bytes[5]&0xFF;
    NSString *dumNum = [NSString stringWithFormat:@"%d",(c2<<24)+(c3<<16)+(c4<<8)+c5];
    [resultDic setObject:dumNum forKey:@"skipCount"];
    
    int c6 = bytes[6]&0xFF;
    int c7 = bytes[7]&0xFF;
    NSString *timeNum = [NSString stringWithFormat:@"%d",(c6<<8)+c7];
    [resultDic setObject:timeNum forKey:@"skipTime"];
    
    NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
    [resultDic setObject:nowTime forKey:@"createTime"];
    [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
    
    [self.delegate analyticalBleData:resultDic withResultNumber:0];
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    return;
}


@end
