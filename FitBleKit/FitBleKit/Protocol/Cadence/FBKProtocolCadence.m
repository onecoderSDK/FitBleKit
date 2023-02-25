/********************************************************************************
 * 文件名称：FBKProtocolCadence.m
 * 内容摘要：速度踏频蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolCadence.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolCadence

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
    NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
    
    int c0 = bytes[0]&0xFF;
    if (c0 == 1) {
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *luanNum = [NSString stringWithFormat:@"%d",(c4<<24)+(c3<<16)+(c2<<8)+c1];
        [resultDic setObject:luanNum forKey:@"wheelCount"];
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        NSString *luanTime = [NSString stringWithFormat:@"%d",(c6<<8)+c5];
        [resultDic setObject:luanTime forKey:@"wheelTime"];
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",c0] forKey:@"deviceType"];
        [resultDic setObject:nowTime forKey:@"createTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
        NSLog(@"hexData:%@\nresultDic :%@",hexData,resultDic);
    }
    else if (c0 == 2) {
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        NSString *taNum = [NSString stringWithFormat:@"%d",(c2<<8)+c1];
        [resultDic setObject:taNum forKey:@"cadenceCount"];
        
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *taTime = [NSString stringWithFormat:@"%d",(c4<<8)+c3];
        [resultDic setObject:taTime forKey:@"cadenceTime"];
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",c0] forKey:@"deviceType"];
        [resultDic setObject:nowTime forKey:@"createTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
        NSLog(@"%@",resultDic);
    }
    else {
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *luanNum = [NSString stringWithFormat:@"%d",(c4<<24)+(c3<<16)+(c2<<8)+c1];
        [resultDic setObject:luanNum forKey:@"wheelCount"];
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        NSString *luanTime = [NSString stringWithFormat:@"%d",(c6<<8)+c5];
        [resultDic setObject:luanTime forKey:@"wheelTime"];
        
        int c7 = bytes[7]&0xFF;
        int c8 = bytes[8]&0xFF;
        NSString *taNum = [NSString stringWithFormat:@"%d",(c8<<8)+c7];
        [resultDic setObject:taNum forKey:@"cadenceCount"];
        
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        NSString *taTime = [NSString stringWithFormat:@"%d",(c10<<8)+c9];
        [resultDic setObject:taTime forKey:@"cadenceTime"];
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",c0] forKey:@"deviceType"];
        [resultDic setObject:nowTime forKey:@"createTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
    }
    
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

