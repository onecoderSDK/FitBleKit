/********************************************************************************
 * 文件名称：FBKProOldBandCmd.m
 * 内容摘要：老手环命令拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import "FBKProOldBandCmd.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProOldBandCmd

/********************************************************************************
 * 方法名称：ackCmd
 * 功能描述：回复的万能信息
 * 输入参数：writeNum - 关键词
 * 返回数据：
 ********************************************************************************/
- (void)ackCmd:(NSString *)writeNum
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"224" forKey:@"byte0"];
    [writeDic setObject:[NSString stringWithFormat:@"%@",writeNum] forKey:@"byte1"];
    [writeDic setObject:@"0" forKey:@"byte2"];
    [writeDic setObject:@"0" forKey:@"byte3"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：setUserInfo
 * 功能描述：写入手环的个人信息
 * 输入参数：writeNum - 关键词
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfo:(NSString *)writeNum andNowInfo:(FBKDeviceUserInfo *)userInfo
{
    int sex = 1;
    int height = 175;
    int weight1 = 2;
    int weight2 = 188;
    int buJu = 60;
    int age = 18;
    int mubu1 = 00;
    int mubu2 = 17;
    int mubu3 = 70;
    int weight = 700;
    int mubu = 6000;
    
    sex = [[NSString stringWithFormat:@"%@",userInfo.gender] intValue];
    if (sex == 1)
    {
        sex = 1;
    }
    else
    {
        sex = 0;;
    }
    
    height = [[NSString stringWithFormat:@"%@",userInfo.height] intValue];
    if (height < 0)
    {
        height = 175;
    }
    else if (height > 255)
    {
        height = 175;
    }
    
    weight = [[NSString stringWithFormat:@"%.0f",[userInfo.weight floatValue]*10] intValue];
    if (weight <= 0)
    {
        weight = 700;
    }
    else if (weight > 3000)
    {
        weight = 700;
    }
    weight1 = weight/256;
    weight2 = weight%256;
    
    buJu = (int)((float)height*0.414);
    
    
    age = [[NSString stringWithFormat:@"%@",userInfo.age] intValue];
    
    if (age <= 0)
    {
        age = 18;
    }
    
    mubu = [[NSString stringWithFormat:@"%@",userInfo.walkGoal] intValue];
    if (mubu < 0)
    {
        mubu = 6000;
    }
    else if (mubu > 10000000)
    {
        mubu = 6000;
    }
    
    mubu1 = mubu/65536;
    mubu2 = (mubu%65536)/256;
    mubu3 = mubu%256;
    
    NSMutableDictionary *locSetDic = [[NSMutableDictionary alloc] init];
    [locSetDic setObject:@"225" forKey:@"byte0"];
    [locSetDic setObject:[NSString stringWithFormat:@"%@",writeNum] forKey:@"byte1"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",weight1] forKey:@"byte2"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",weight2] forKey:@"byte3"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",age] forKey:@"byte4"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",height] forKey:@"byte5"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",buJu] forKey:@"byte6"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",sex] forKey:@"byte7"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",mubu1] forKey:@"byte8"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",mubu2] forKey:@"byte9"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",mubu3] forKey:@"byte10"];
    [locSetDic setObject:@"0" forKey:@"byte11"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:locSetDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：getTimeHand
 * 功能描述：获取写入手环的时间
 * 输入参数：writeNum - 关键词   nowDic - 最新的信息
 * 返回数据：
 ********************************************************************************/
- (void)getTimeHand:(NSString *)writeNum
{
    NSTimeInterval juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
    long long int myUtc = [[NSDate date] timeIntervalSince1970] + juTime;
    long long time4 = myUtc / (256*256*256);
    long long time3 = (myUtc % (256*256*256))/65536;
    long long time2 = (myUtc % 65536)/256;
    long long time1 = myUtc % 256;
    
    NSMutableDictionary *locSetDic = [[NSMutableDictionary alloc] init];
    [locSetDic setObject:@"226" forKey:@"byte0"];
    [locSetDic setObject:[NSString stringWithFormat:@"%@",writeNum] forKey:@"byte1"];
    [locSetDic setObject:[NSString stringWithFormat:@"%lli",time4] forKey:@"byte2"];
    [locSetDic setObject:[NSString stringWithFormat:@"%lli",time3] forKey:@"byte3"];
    [locSetDic setObject:[NSString stringWithFormat:@"%lli",time2] forKey:@"byte4"];
    [locSetDic setObject:[NSString stringWithFormat:@"%lli",time1] forKey:@"byte5"];
    [locSetDic setObject:@"0" forKey:@"byte6"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:locSetDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}

/********************************************************************************
 * 方法名称：setPramInfo
 * 功能描述：写入手环的设置信息
 * 输入参数：writeNum - 关键词   sleepInfo - 最新的信息
 * 返回数据：
 ********************************************************************************/
- (void)setPramInfo:(NSString *)writeNum andNowInfo:(FBKDeviceSleepInfo *)sleepInfo andBikeInfo:(NSString *)bikeWhell
{
    
    NSString *whellDiameter = @"0";
    NSString *normalStart = @"21:30";
    NSString *normalEnd = @"08:00";
    NSString *weekdaylEnd = @"09:00";
    
    whellDiameter = [NSString stringWithFormat:@"%@",bikeWhell];
    normalStart = [NSString stringWithFormat:@"%@",sleepInfo.normalStart];
    normalEnd = [NSString stringWithFormat:@"%@",sleepInfo.normalEnd];
    weekdaylEnd = [NSString stringWithFormat:@"%@",sleepInfo.weekdaylEnd];
    
    if ([whellDiameter isEqualToString:@"0"])
    {
        whellDiameter = @"2.096";
    }
    
    int whellNum = (int)([whellDiameter floatValue]*1000);
    
    if (whellNum <= 0)
    {
        whellNum = 2096;
    }
    
    if (whellNum > 50000)
    {
        whellNum = 2096;
    }
    
    int whell1 = whellNum / 256;
    int whell2 = whellNum % 256;
    
    if (normalStart.length != 5)
    {
        normalStart = @"21:30";
    }
    
    if (normalEnd.length != 5)
    {
        normalEnd = @"08:00";
    }
    
    if (weekdaylEnd.length != 5)
    {
        weekdaylEnd = @"09:00";
    }
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *startHour = @"";
    NSString *startMin = @"";
    NSString *normalEndHour = @"";
    NSString *normalEndMin = @"";
    NSString *weekEndHour = @"";
    NSString *weekEndMin = @"";
    
    startHour = [FBKDateFormat getDateChar:normalStart withDateType:@"HH:mm" withCharNum:6];
    startMin = [FBKDateFormat getDateChar:normalStart withDateType:@"HH:mm" withCharNum:7];
    normalEndHour = [FBKDateFormat getDateChar:normalEnd withDateType:@"HH:mm" withCharNum:6];
    normalEndMin = [FBKDateFormat getDateChar:normalEnd withDateType:@"HH:mm" withCharNum:7];
    weekEndHour = [FBKDateFormat getDateChar:weekdaylEnd withDateType:@"HH:mm" withCharNum:6];
    weekEndMin = [FBKDateFormat getDateChar:weekdaylEnd withDateType:@"HH:mm" withCharNum:7];
    
    
    NSMutableDictionary *locSetDic = [[NSMutableDictionary alloc] init];
    [locSetDic setObject:@"228" forKey:@"byte0"];
    [locSetDic setObject:[NSString stringWithFormat:@"%@",writeNum] forKey:@"byte1"];
    [locSetDic setObject:@"1" forKey:@"byte2"];
    [locSetDic setObject:startHour forKey:@"byte3"];
    [locSetDic setObject:startMin forKey:@"byte4"];
    [locSetDic setObject:normalEndHour forKey:@"byte5"];
    [locSetDic setObject:normalEndMin forKey:@"byte6"];
    [locSetDic setObject:weekEndHour forKey:@"byte7"];
    [locSetDic setObject:weekEndMin forKey:@"byte8"];
    [locSetDic setObject:@"10" forKey:@"byte9"];
    [locSetDic setObject:@"60" forKey:@"byte10"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",whell1] forKey:@"byte11"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",whell2] forKey:@"byte12"];
    [locSetDic setObject:@"0" forKey:@"byte13"];
    [locSetDic setObject:@"0" forKey:@"byte14"];
    [locSetDic setObject:@"0" forKey:@"byte15"];
    [locSetDic setObject:@"0" forKey:@"byte16"];
    [locSetDic setObject:@"0" forKey:@"byte17"];
    [locSetDic setObject:@"0" forKey:@"byte18"];
    [locSetDic setObject:@"0" forKey:@"byte19"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:locSetDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/********************************************************************************
 * 方法名称：getLimitData
 * 功能描述：获取写入手环的限制信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getLimitData:(NSString *)writeNum andNowInfo:(FBKDeviceLimit *)limitInfo {
    int limitSteps = [limitInfo.limitSteps intValue];
    int limitMinutes = [limitInfo.limitMinutes intValue];
    int timeInterval = [limitInfo.timeInterval intValue];
    int stepStandard = [limitInfo.stepStandard intValue];
    
    
    NSMutableDictionary *locSetDic = [[NSMutableDictionary alloc] init];
    [locSetDic setObject:@"229" forKey:@"byte0"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",limitSteps/256] forKey:@"byte1"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",limitSteps%256] forKey:@"byte2"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",limitMinutes/256] forKey:@"byte3"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",limitMinutes%256] forKey:@"byte4"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",timeInterval] forKey:@"byte5"];
    [locSetDic setObject:[NSString stringWithFormat:@"%i",stepStandard] forKey:@"byte6"];
    [locSetDic setObject:@"0" forKey:@"byte7"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:locSetDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


@end
