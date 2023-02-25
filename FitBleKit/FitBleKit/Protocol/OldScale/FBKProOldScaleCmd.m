/********************************************************************************
 * 文件名称：FBKProOldScaleCmd.m
 * 内容摘要：老秤命令拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProOldScaleCmd.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProOldScaleCmd

/********************************************************************************
 * 方法名称：setWeightTimeData
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setWeightTimeData
{
    NSDate *nowDate  = [NSDate date];
    int zoneTime     = [FBKDateFormat getNowDateFromatAnDateMore:nowDate];
    int myUtc        = [nowDate timeIntervalSince1970] + zoneTime;
    int timeOne      = (unsigned char)(myUtc>>24);
    int timeTwo      = (unsigned char)(myUtc>>16);
    int timeThree    = (unsigned char)(myUtc>>8);
    int timeFour     = (unsigned char)(myUtc);
    
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"8" forKey:@"byte1"];
    [writeDic setObject:@"1" forKey:@"byte2"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",timeOne]   forKey:@"byte3"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",timeTwo]   forKey:@"byte4"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",timeThree] forKey:@"byte5"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",timeFour]  forKey:@"byte6"];
    [writeDic setObject:@"0" forKey:@"byte7"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：setUserInfo
 * 功能描述：设置用户信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfo:(FBKDeviceScaleInfo *)sacleInfo
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"17"  forKey:@"byte1"];
    [writeDic setObject:@"2"   forKey:@"byte2"];
    [writeDic setObject:@"17"  forKey:@"byte3"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",255]     forKey:@"byte4"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleHeight] forKey:@"byte5"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleAge]    forKey:@"byte6"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleGender] forKey:@"byte7"];
    [writeDic setObject:@"0"   forKey:@"byte8"];
    [writeDic setObject:@"0"   forKey:@"byte9"];
    [writeDic setObject:@"0"   forKey:@"byte10"];
    [writeDic setObject:@"0"   forKey:@"byte11"];
    [writeDic setObject:@"0"   forKey:@"byte12"];
    [writeDic setObject:@"0"   forKey:@"byte13"];
    [writeDic setObject:@"0"   forKey:@"byte14"];
    [writeDic setObject:@"0"   forKey:@"byte15"];
    [writeDic setObject:@"0"   forKey:@"byte16"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：setDeviceUnit
 * 功能描述：设置设备单位
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setDeviceUnit:(NSString *)unit
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"5"   forKey:@"byte1"];
    [writeDic setObject:@"3"   forKey:@"byte2"];
    [writeDic setObject:unit  forKey:@"byte3"];
    [writeDic setObject:@"0"   forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：getDeviceBaseInfo
 * 功能描述：获取设备基本信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceBaseInfo
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"4"   forKey:@"byte1"];
    [writeDic setObject:@"4"   forKey:@"byte2"];
    [writeDic setObject:@"0"   forKey:@"byte3"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}

/********************************************************************************
 * 方法名称：editUserNumberData
 * 功能描述：添加、删除、指定用户信息命令
 * 输入参数：0-添加  1-删除  2-指定
 * 返回数据：
 ********************************************************************************/
- (void)editUserNumberData:(FBKDeviceScaleInfo *)sacleInfo andEditState:(NSString *)state
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"9"   forKey:@"byte1"];
    [writeDic setObject:@"5"   forKey:@"byte2"];
    [writeDic setObject:state  forKey:@"byte3"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleUserId]     forKey:@"byte4"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleHeight] forKey:@"byte5"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleAge]    forKey:@"byte6"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",sacleInfo.scaleGender] forKey:@"byte7"];
    [writeDic setObject:@"0" forKey:@"byte8"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：ackCmd
 * 功能描述：应答命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)ackCmd:(NSString *)ackNumber
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"5"   forKey:@"byte1"];
    [writeDic setObject:@"100" forKey:@"byte2"];
    [writeDic setObject:ackNumber forKey:@"byte3"];
    [writeDic setObject:@"0"   forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


@end
