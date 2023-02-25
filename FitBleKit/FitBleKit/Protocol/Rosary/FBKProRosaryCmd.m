/********************************************************************************
 * 文件名称：FBKProRosaryCmd.m
 * 内容摘要：念珠蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import "FBKProRosaryCmd.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProRosaryCmd

/***************************************************************************
 * 方法名称：changeDeviceMode
 * 功能描述：切换念珠模式
 * 输入参数：mode - 开始（1）／结束（2）
 * 返回数据：
 ***************************************************************************/
- (void)changeDeviceMode:(NSString *)mode
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"5"   forKey:@"byte1"];
    [writeDic setObject:@"1"   forKey:@"byte2"];
    [writeDic setObject:mode   forKey:@"byte3"];
    [writeDic setObject:@"0"   forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：SearchOrSetNotice
 * 功能描述：查询、设置来电提醒
 * 输入参数：setType - 查询（1）／设置（2）   noticeType - 灯亮（0）／震动（1）/灯亮+震动（2）
 * 返回数据：
 ***************************************************************************/
- (void)SearchOrSetNotice:(NSString *)setType andNoticeType:(NSString *)noticeType
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"6"    forKey:@"byte1"];
    [writeDic setObject:@"2"    forKey:@"byte2"];
    [writeDic setObject:setType forKey:@"byte3"];
    [writeDic setObject:noticeType forKey:@"byte4"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：searchPower
 * 功能描述：查询电量命令
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)searchPower
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"4"   forKey:@"byte1"];
    [writeDic setObject:@"3"   forKey:@"byte2"];
    [writeDic setObject:@"0"   forKey:@"byte3"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：searchBeadNumber
 * 功能描述：设置、查询念珠一圈颗数
 * 输入参数：setType - 查询（1）／设置（2）   beadNumber-念珠一圈颗数
 * 返回数据：
 ***************************************************************************/
- (void)searchBeadNumber:(NSString *)setType andBeadNumber:(NSString *)beadNumber
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"6"    forKey:@"byte1"];
    [writeDic setObject:@"4"    forKey:@"byte2"];
    [writeDic setObject:setType forKey:@"byte3"];
    [writeDic setObject:beadNumber forKey:@"byte4"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：getRealTimeSteps
 * 功能描述：获取实时步数
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)getRealTimeSteps
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"4"    forKey:@"byte1"];
    [writeDic setObject:@"5"    forKey:@"byte2"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：getbeadNumbers
 * 功能描述：获取念珠计数
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)getBeadNumbers
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"4"    forKey:@"byte1"];
    [writeDic setObject:@"6"    forKey:@"byte2"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：getErrorBeadNumbers
 * 功能描述：获取非正常退出念珠模式时念珠计数
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)getErrorBeadNumbers
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"4"    forKey:@"byte1"];
    [writeDic setObject:@"7"    forKey:@"byte2"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：setDeviceTime
 * 功能描述：设置设备时间命令
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)setDeviceTime
{
    NSTimeInterval juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
    int myUtc = [[NSDate date] timeIntervalSince1970]+juTime;
    int time4 = myUtc / (256*256*256);
    int time3 = (myUtc % (256*256*256))/65536;
    int time2 = (myUtc % 65536)/256;
    int time1 = myUtc % 256;
    
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"8"    forKey:@"byte1"];
    [writeDic setObject:@"8"    forKey:@"byte2"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",time4] forKey:@"byte3"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",time3] forKey:@"byte4"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",time2] forKey:@"byte5"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",time1] forKey:@"byte6"];
    [writeDic setObject:@"0"    forKey:@"byte7"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：setNoticeSetting
 * 功能描述：设置闪灯或震动提示
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)setNoticeSetting:(NSDictionary *)setDictionary
{
    int noticeType   = [[setDictionary objectForKey:@"noticeType"] intValue];
    int noticeRows   = [[setDictionary objectForKey:@"noticeRows"] intValue];
    int timeNumbers  = [[setDictionary objectForKey:@"timeNumbers"] intValue];
    int intervalTime = [[setDictionary objectForKey:@"intervalTime"] intValue];
    int noticeTime   = [[setDictionary objectForKey:@"noticeTime"] intValue];
    int restTime     = [[setDictionary objectForKey:@"restTime"] intValue];
    
    if (intervalTime > 255*255)
    {
        intervalTime = 255*255;
    }
    
    if (noticeTime > 255*255)
    {
        noticeTime = 255*255;
    }
    
    if (restTime > 255*255)
    {
        restTime = 255*255;
    }
    
    int intervalTimeUp   = intervalTime/256;
    int intervalTimeDown = intervalTime%256;
    int noticeTimeUp     = noticeTime/256;
    int noticeTimeDown   = noticeTime%256;
    int restTimeUp       = restTime/256;
    int restTimeDown     = restTime%256;
    
    
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"13"    forKey:@"byte1"];
    [writeDic setObject:@"9"    forKey:@"byte2"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",noticeType] forKey:@"byte3"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",noticeRows] forKey:@"byte4"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",intervalTimeUp] forKey:@"byte5"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",intervalTimeDown] forKey:@"byte6"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",timeNumbers] forKey:@"byte7"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",noticeTimeUp] forKey:@"byte8"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",noticeTimeDown] forKey:@"byte9"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",restTimeUp] forKey:@"byte10"];
    [writeDic setObject:[NSString stringWithFormat:@"%i",restTimeDown] forKey:@"byte11"];
    [writeDic setObject:@"0"    forKey:@"byte12"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：setBookId
 * 功能描述：设置当前经书ID
 * 输入参数：bookId - 经书ID
 * 返回数据：
 ***************************************************************************/
- (void)setBookId:(NSString *)bookId
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"5"   forKey:@"byte1"];
    [writeDic setObject:@"10"   forKey:@"byte2"];
    [writeDic setObject:bookId   forKey:@"byte3"];
    [writeDic setObject:@"0"   forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：bluetoothPairing
 * 功能描述：打开/关闭蓝牙配对功能
 * 输入参数：PairState - 配对状态
 * 返回数据：
 ***************************************************************************/
- (void)bluetoothPairing:(NSString *)pairState
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"5"   forKey:@"byte1"];
    [writeDic setObject:@"11"   forKey:@"byte2"];
    [writeDic setObject:pairState   forKey:@"byte3"];
    [writeDic setObject:@"0"   forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：getBeadHistory
 * 功能描述：获取念珠历史数据
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)getBeadHistory
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"4"   forKey:@"byte1"];
    [writeDic setObject:@"12"   forKey:@"byte2"];
    [writeDic setObject:@"0"   forKey:@"byte3"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：getBeadMode
 * 功能描述：获取念珠模式
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)getBeadMode
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254" forKey:@"byte0"];
    [writeDic setObject:@"4"   forKey:@"byte1"];
    [writeDic setObject:@"13"   forKey:@"byte2"];
    [writeDic setObject:@"0"   forKey:@"byte3"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：callbackCMD
 * 功能描述：应答命令
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)callbackCMD:(NSString *)backCMD
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"5"    forKey:@"byte1"];
    [writeDic setObject:@"100"  forKey:@"byte2"];
    [writeDic setObject:backCMD forKey:@"byte3"];
    [writeDic setObject:@"0"    forKey:@"byte4"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


/***************************************************************************
 * 方法名称：callbackHis
 * 功能描述：上传念经记录应答
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (void)callbackHis:(NSString *)backCMD andBagId:(NSString *)bagId
{
    NSMutableDictionary *writeDic = [[NSMutableDictionary alloc] init];
    [writeDic setObject:@"254"  forKey:@"byte0"];
    [writeDic setObject:@"6"    forKey:@"byte1"];
    [writeDic setObject:@"100"  forKey:@"byte2"];
    [writeDic setObject:backCMD forKey:@"byte3"];
    [writeDic setObject:bagId forKey:@"byte4"];
    [writeDic setObject:@"0"    forKey:@"byte5"];
    
    NSString *writeInString = [FBKSpliceBle getHexData:writeDic haveCheckNum:YES];
    NSData *writeData = [FBKSpliceBle getWriteData:writeInString];
    [self.delegate sendBleCmdData:writeData];
}


@end
