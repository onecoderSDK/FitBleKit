/********************************************************************************
 * 文件名称：FBKProNTrackerCmd.m
 * 内容摘要：新手环蓝牙协议命令拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#define   FBKDEVICEVERSION    1 // 版本号

#import "FBKProNTrackerCmd.h"
#import "FBKSpliceBle.h"
#import "FBKDateFormat.h"

@implementation FBKProNTrackerCmd
{
    NSMutableArray *m_cmdQueueArray;
    NSString *m_buferString;
    NSTimer *timeOutTimer;
    int m_alarmSwitchState;
    int m_headerNumber;
    NSString *m_againString;
    int m_againNumber;
}

@synthesize m_softVersion;

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
    
    m_cmdQueueArray = [[NSMutableArray alloc] init];
    m_buferString = [[NSString alloc] init];
    m_alarmSwitchState = 0;
    m_headerNumber = 1;
    m_softVersion = FBKDEVICEVERSION;
    m_againString = [[NSString alloc] init];
    m_againNumber = 0;
    
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
    if (timeOutTimer != nil) {
        [timeOutTimer invalidate];
        timeOutTimer = nil;
    }
}


#pragma mark - **************************** 内部方法 *****************************
/********************************************************************************
 * 方法名称：alramSwitch
 * 功能描述：获取闹钟开关的状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)alramSwitch:(int)alarmSeq withState:(BOOL)state
{
    if(alarmSeq > 7)
    {
        return;
    }
    if(!state)
    {
        m_alarmSwitchState &= ~(1<<alarmSeq);
    }
    else
    {
        m_alarmSwitchState |= 1<<alarmSeq;
    }
}


/********************************************************************************
 * 方法名称：insertQueueData
 * 功能描述：将数据插入到队列中
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)insertQueueData:(NSString *)cmdString
{
    BOOL isInsertIn = NO;
    NSString *cmdId = [cmdString substringToIndex:2];
    
    for (int i = 0; i < m_cmdQueueArray.count; i++)
    {
        NSString *bufString = [m_cmdQueueArray objectAtIndex:i];
        NSString *bufCmdId = [[bufString substringFromIndex:4] substringToIndex:2];
        
        if ([cmdId isEqualToString:bufCmdId])
        {
            if (cmdString.length + bufString.length - 4 <= 200)
            {
                NSString *myCmdString = [[cmdString substringFromIndex:4] substringToIndex:cmdString.length-4];
                NSString *insertString = [NSString stringWithFormat:@"%@%@",bufString,myCmdString];
                [m_cmdQueueArray replaceObjectAtIndex:i withObject:insertString];
                isInsertIn = YES;
                break;
            }
        }
    }
    
    if (!isInsertIn)
    {
        int sortHi  = m_headerNumber / 256;
        int sortLow = m_headerNumber % 256;
        NSString *insertString = [NSString stringWithFormat:@"%@%@%@",[FBKSpliceBle decimalToHex:sortHi],[FBKSpliceBle decimalToHex:sortLow],cmdString];
        [m_cmdQueueArray addObject:insertString];
        
        m_headerNumber++;
        
        if (m_headerNumber >= 256*256)
        {
            m_headerNumber = 1;
        }
    }
}

/********************************************************************************
 * 方法名称：startTimer
 * 功能描述：开启计时
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startTimer
{
    [timeOutTimer invalidate];
    timeOutTimer = nil;
    timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                    target:self
                                                  selector:@selector(sendAgain)
                                                  userInfo:nil
                                                   repeats:YES];
}


/********************************************************************************
 * 方法名称：sendAgain
 * 功能描述：超时重发
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendAgain
{
    [timeOutTimer invalidate];
    timeOutTimer = nil;
    [self sendBandCmd:m_buferString];
}


/********************************************************************************
 * 方法名称：sendCmdSuseed
 * 功能描述：发送命令成功
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendCmdSuseed:(NSString *)sortMark
{
    if (m_buferString.length > 4)
    {
        if ([sortMark isEqualToString:[m_buferString substringToIndex:4]])
        {
            [timeOutTimer invalidate];
            timeOutTimer = nil;
            m_buferString = @"";
            [self setBuferString];
        }
    }
    else
    {
        [timeOutTimer invalidate];
        timeOutTimer = nil;
        m_buferString = @"";
        [self setBuferString];
    }
}


/********************************************************************************
 * 方法名称：setBuferString
 * 功能描述：将应用层数据放入传输层
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBuferString
{
    if (m_buferString.length == 0 && m_cmdQueueArray.count > 0)
    {
        m_buferString = [[NSString alloc] initWithString:[m_cmdQueueArray objectAtIndex:0]];
        [m_cmdQueueArray removeObjectAtIndex:0];
        [self sendBandCmd:m_buferString];
    }
}


/********************************************************************************
 * 方法名称：getBandCmd
 * 功能描述：将bufer的字符转化为命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendBandCmd:(NSString *)cmdString
{
    if ([m_againString isEqualToString:cmdString])
    {
        if (m_againNumber == 10)
        {
            [timeOutTimer invalidate];
            timeOutTimer = nil;
            m_buferString = @"";
            [self setBuferString];
            return;
        }
        
        m_againNumber++;
    }
    
    m_againString = cmdString;
    
    
    NSMutableArray *blueCmdArray = [[NSMutableArray alloc] init];
    
    if (cmdString.length <= 32)
    {
        int length = (int)cmdString.length/2 + 4;
        NSString *lengthHex = [FBKSpliceBle decimalToHex:length];
        
        NSMutableString *myCmdString = [[NSMutableString alloc] init];
        [myCmdString appendString:@"ff"];
        [myCmdString appendString:@"00"];
        [myCmdString appendString:lengthHex];
        [myCmdString appendString:cmdString];
        
        NSString *resultString = [FBKSpliceBle getCheckNumber:myCmdString];
        [blueCmdArray addObject:resultString];
    }
    else
    {
        int cmdNum = (int)cmdString.length / 32;
        
        if ((int)cmdString.length % 32 != 0)
        {
            cmdNum = cmdNum + 1;
        }
        
        for ( int i = 0; i < cmdNum; i++)
        {
            if (i == cmdNum-1)
            {
                NSString *listString = [[cmdString substringFromIndex:i*32] substringToIndex:cmdString.length - i*32];
                int mark = 128 + 64 + i;
                NSString *markHex = [FBKSpliceBle decimalToHex:mark];
                int length = (int)listString.length/2 + 4;
                NSString *lengthHex = [FBKSpliceBle decimalToHex:length];
                
                NSMutableString *myCmdString = [[NSMutableString alloc] init];
                [myCmdString appendString:@"ff"];
                [myCmdString appendString:markHex];
                [myCmdString appendString:lengthHex];
                [myCmdString appendString:listString];
                
                NSString *resultString = [FBKSpliceBle getCheckNumber:myCmdString];
                [blueCmdArray addObject:resultString];
            }
            else
            {
                NSString *listString = [[cmdString substringFromIndex:i*32] substringToIndex:32];
                int mark = 128 + i;
                NSString *markHex = [FBKSpliceBle decimalToHex:mark];
                int length = (int)listString.length/2 + 4;
                NSString *lengthHex = [FBKSpliceBle decimalToHex:length];
                
                NSMutableString *myCmdString = [[NSMutableString alloc] init];
                [myCmdString appendString:@"ff"];
                [myCmdString appendString:markHex];
                [myCmdString appendString:lengthHex];
                [myCmdString appendString:listString];
                
                NSString *resultString = [FBKSpliceBle getCheckNumber:myCmdString];
                [blueCmdArray addObject:resultString];
            }
        }
    }
    
    for (int i = 0; i < blueCmdArray.count; i++)
    {
        NSString *writeCmd = [blueCmdArray objectAtIndex:i];
        NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:writeCmd]];
        [self.delegate sendBleCmdData:writeData];
    }
    
    [self startTimer];
}


#pragma mark - **************************** 接口设置  *****************************
/********************************************************************************
 * 方法名称：setUTC
 * 功能描述：设置手环时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUTC
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 8;
    int ackType     = 1;
    int valueLong   = 4;
    
    NSString *timeNum = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
    int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
    long int myUtc = [FBKDateFormat getTimestamp:timeNum] + juTime;
    long int time4 = myUtc / (256*256*256);
    long int time3 = (myUtc % (256*256*256))/65536;
    long int time2 = (myUtc % 65536)/256;
    long int time1 = myUtc % 256;
    
    NSMutableDictionary *utcDic = [[NSMutableDictionary alloc] init];
    [utcDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [utcDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [utcDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [utcDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [utcDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [utcDic setObject:[NSString stringWithFormat:@"%li",time4] forKey:@"byte5"];
    [utcDic setObject:[NSString stringWithFormat:@"%li",time3] forKey:@"byte6"];
    [utcDic setObject:[NSString stringWithFormat:@"%li",time2] forKey:@"byte7"];
    [utcDic setObject:[NSString stringWithFormat:@"%li",time1] forKey:@"byte8"];
    
    NSString *utcString = [FBKSpliceBle getHexData:utcDic haveCheckNum:NO];
    [self insertQueueData:utcString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setUserInfoCmd
 * 功能描述：设置个人基本信息
 * 输入参数：userInfo-个人信息
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfoCmd:(FBKDeviceUserInfo *)userInfo
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 9;
    int ackType   = 1;
    int valueLong = 9;
    int weightHi  = ((int)([userInfo.weight floatValue]*10)) / 256;
    int weightLow = ((int)([userInfo.weight floatValue]*10)) % 256;
    int stepLen   = (int)([userInfo.height floatValue] * 0.414);
    int goalHi    = [userInfo.walkGoal intValue] / (256*256);
    int goalHMid  = [userInfo.walkGoal intValue] % (256*256) / 256;
    int goalLow   = [userInfo.walkGoal intValue] % 256;
    
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",weightHi] forKey:@"byte5"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",weightLow] forKey:@"byte6"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",userInfo.age] forKey:@"byte7"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",userInfo.height] forKey:@"byte8"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",stepLen] forKey:@"byte9"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",userInfo.gender] forKey:@"byte10"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",goalHi] forKey:@"byte11"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",goalHMid] forKey:@"byte12"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",goalLow] forKey:@"byte13"];
    
    NSString *userInfoString = [FBKSpliceBle getHexData:userInfoDic haveCheckNum:NO];
    [self insertQueueData:userInfoString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setSleepInfoCmd
 * 功能描述：设置个人睡眠信息
 * 输入参数：sleepInfo-个人睡眠信息
 * 返回数据：
 ********************************************************************************/
- (void)setSleepInfoCmd:(FBKDeviceSleepInfo *)sleepInfo
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 10;
    int ackType   = 1;
    int valueLong = 9;
    NSString *normalStart = @"21:30";
    NSString *normalEnd   = @"08:00";
    NSString *weekdaylEnd = @"09:00";
    normalStart   = [NSString stringWithFormat:@"%@",sleepInfo.normalStart];
    normalEnd     = [NSString stringWithFormat:@"%@",sleepInfo.normalEnd];
    weekdaylEnd   = [NSString stringWithFormat:@"%@",sleepInfo.weekdaylEnd];
    
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
    
    NSMutableDictionary *sleepInfoDic = [[NSMutableDictionary alloc] init];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",startHour] forKey:@"byte6"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",startMin] forKey:@"byte7"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",normalEndHour] forKey:@"byte8"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",normalEndMin] forKey:@"byte9"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",weekEndHour] forKey:@"byte10"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%@",weekEndMin] forKey:@"byte11"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",10] forKey:@"byte12"];
    [sleepInfoDic setObject:[NSString stringWithFormat:@"%i",40] forKey:@"byte13"];
    
    NSString *sleepInfoString = [FBKSpliceBle getHexData:sleepInfoDic haveCheckNum:NO];
    [self insertQueueData:sleepInfoString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setWaterInfoCmd
 * 功能描述：设置个人喝水信息
 * 输入参数：waterInfo-喝水信息
 * 返回数据：
 ********************************************************************************/
- (void)setWaterInfoCmd:(FBKDeviceIntervalInfo *)waterInfo withSitSwitch:(NSString *)sitSwitch
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 7;
    int ackType     = 1;
    int valueLong   = 9;
    int intervalNum = [waterInfo.intervalTime intValue];
    int amStartHour = 8;
    int amStartMin  = 0;
    int amEndHour   = 12;
    int amEndMin    = 0;
    int pmStartHour = 14;
    int pmStartMin  = 0;
    int pmEndHour   = 18;
    int pmEndMin    = 0;
    
    NSString *am = [NSString stringWithFormat:@"%@",waterInfo.amTime];
    if (am.length == 11)
    {
        NSString *amStart = [[am substringFromIndex:0] substringToIndex:5];
        amStartHour = [[FBKDateFormat getDateChar:amStart withDateType:@"HH:mm" withCharNum:6] intValue];
        amStartMin = [[FBKDateFormat getDateChar:amStart withDateType:@"HH:mm" withCharNum:7] intValue];
        
        NSString *amEnd = [[am substringFromIndex:6] substringToIndex:5];
        amEndHour = [[FBKDateFormat getDateChar:amEnd withDateType:@"HH:mm" withCharNum:6] intValue];
        amEndMin = [[FBKDateFormat getDateChar:amEnd withDateType:@"HH:mm" withCharNum:7] intValue];
    }
    
    NSString *pm = [NSString stringWithFormat:@"%@",waterInfo.pmTime];
    if (pm.length == 11)
    {
        NSString *pmStart = [[pm substringFromIndex:0] substringToIndex:5];
        pmStartHour = [[FBKDateFormat getDateChar:pmStart withDateType:@"HH:mm" withCharNum:6] intValue];
        pmStartMin = [[FBKDateFormat getDateChar:pmStart withDateType:@"HH:mm" withCharNum:7] intValue];
        
        NSString *pmEnd = [[pm substringFromIndex:6] substringToIndex:5];
        pmEndHour = [[FBKDateFormat getDateChar:pmEnd withDateType:@"HH:mm" withCharNum:6] intValue];
        pmEndMin = [[FBKDateFormat getDateChar:pmEnd withDateType:@"HH:mm" withCharNum:7] intValue];
    }
    
    NSMutableDictionary *waterInfoDic = [[NSMutableDictionary alloc] init];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",amStartHour] forKey:@"byte5"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",amStartMin] forKey:@"byte6"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",amEndHour] forKey:@"byte7"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",amEndMin] forKey:@"byte8"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",pmStartHour] forKey:@"byte9"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",pmStartMin] forKey:@"byte10"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",pmEndHour] forKey:@"byte11"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",pmEndMin] forKey:@"byte12"];
    [waterInfoDic setObject:[NSString stringWithFormat:@"%i",intervalNum] forKey:@"byte13"];
    NSString *waterInfoString = [FBKSpliceBle getHexData:waterInfoDic haveCheckNum:NO];
    [self insertQueueData:waterInfoString];
    [self setBuferString];
    
    int cmdIds       = 1;
    int versions     = m_softVersion*16+0*8;
    int keyMarks     = 3;
    int ackTypes     = 1;
    int valueLongs   = 1;
    int waterOpenState = ([waterInfo.switchStatus intValue]*1 == 1) ? 1 : 0;
    int sitOpenState   = ([sitSwitch intValue]*2 == 2) ? 2 : 0;
    
    NSMutableDictionary *openStateDic = [[NSMutableDictionary alloc] init];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",cmdIds] forKey:@"byte0"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",versions] forKey:@"byte1"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",keyMarks] forKey:@"byte2"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",ackTypes] forKey:@"byte3"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",valueLongs] forKey:@"byte4"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",waterOpenState + sitOpenState] forKey:@"byte5"];
    NSString *openStateString = [FBKSpliceBle getHexData:openStateDic haveCheckNum:NO];
    [self insertQueueData:openStateString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setSitInfoCmd
 * 功能描述：设置个人久坐信息
 * 输入参数：sitInfo-久坐信息
 * 返回数据：
 ********************************************************************************/
- (void)setSitInfoCmd:(FBKDeviceIntervalInfo *)sitInfo withWaterSwitch:(NSString *)waterSwitch
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 6;
    int ackType     = 1;
    int valueLong   = 9;
    int intervalNum = [sitInfo.intervalTime intValue];
    int amStartHour = 8;
    int amStartMin  = 0;
    int amEndHour   = 12;
    int amEndMin    = 0;
    int pmStartHour = 14;
    int pmStartMin  = 0;
    int pmEndHour   = 18;
    int pmEndMin    = 0;
    
    NSString *am = [NSString stringWithFormat:@"%@",sitInfo.amTime];
    if (am.length == 11)
    {
        NSString *amStart = [[am substringFromIndex:0] substringToIndex:5];
        amStartHour = [[FBKDateFormat getDateChar:amStart withDateType:@"HH:mm" withCharNum:6] intValue];
        amStartMin = [[FBKDateFormat getDateChar:amStart withDateType:@"HH:mm" withCharNum:7] intValue];
        
        NSString *amEnd = [[am substringFromIndex:6] substringToIndex:5];
        amEndHour = [[FBKDateFormat getDateChar:amEnd withDateType:@"HH:mm" withCharNum:6] intValue];
        amEndMin = [[FBKDateFormat getDateChar:amEnd withDateType:@"HH:mm" withCharNum:7] intValue];
    }
    
    NSString *pm = [NSString stringWithFormat:@"%@",sitInfo.pmTime];
    if (pm.length == 11)
    {
        NSString *pmStart = [[pm substringFromIndex:0] substringToIndex:5];
        pmStartHour = [[FBKDateFormat getDateChar:pmStart withDateType:@"HH:mm" withCharNum:6] intValue];
        pmStartMin = [[FBKDateFormat getDateChar:pmStart withDateType:@"HH:mm" withCharNum:7] intValue];
        
        NSString *pmEnd = [[pm substringFromIndex:6] substringToIndex:5];
        pmEndHour = [[FBKDateFormat getDateChar:pmEnd withDateType:@"HH:mm" withCharNum:6] intValue];
        pmEndMin = [[FBKDateFormat getDateChar:pmEnd withDateType:@"HH:mm" withCharNum:7] intValue];
    }
    
    NSMutableDictionary *sitInfoDic = [[NSMutableDictionary alloc] init];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",amStartHour] forKey:@"byte5"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",amStartMin] forKey:@"byte6"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",amEndHour] forKey:@"byte7"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",amEndMin] forKey:@"byte8"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",pmStartHour] forKey:@"byte9"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",pmStartMin] forKey:@"byte10"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",pmEndHour] forKey:@"byte11"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",pmEndMin] forKey:@"byte12"];
    [sitInfoDic setObject:[NSString stringWithFormat:@"%i",intervalNum] forKey:@"byte13"];
    NSString *sitInfoString = [FBKSpliceBle getHexData:sitInfoDic haveCheckNum:NO];
    [self insertQueueData:sitInfoString];
    [self setBuferString];
    
    int cmdIds       = 1;
    int versions     = m_softVersion*16+0*8;
    int keyMarks     = 3;
    int ackTypes     = 1;
    int valueLongs   = 1;
    int waterOpenState = ([waterSwitch intValue]*1 == 1) ? 1 : 0;
    int sitOpenState   = ([sitInfo.switchStatus intValue]*2 == 2) ? 2 : 0;
    
    NSMutableDictionary *openStateDic = [[NSMutableDictionary alloc] init];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",cmdIds] forKey:@"byte0"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",versions] forKey:@"byte1"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",keyMarks] forKey:@"byte2"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",ackTypes] forKey:@"byte3"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",valueLongs] forKey:@"byte4"];
    [openStateDic setObject:[NSString stringWithFormat:@"%i",waterOpenState + sitOpenState] forKey:@"byte5"];
    NSString *openStateString = [FBKSpliceBle getHexData:openStateDic haveCheckNum:NO];
    [self insertQueueData:openStateString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setNoticeInfoCmd
 * 功能描述：设置个人通知信息
 * 输入参数：noticeInfo-通知信息
 * 返回数据：
 ********************************************************************************/
- (void)setNoticeInfoCmd:(FBKDeviceNoticeInfo *)noticeInfo
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 1;
    int ackType     = 1;
    int valueLong   = 2;
    int missedCallNum = ([noticeInfo.missedCall intValue]*1 == 1) ? 1 : 0;
    int mailNum       = ([noticeInfo.mail intValue]*2 == 2) ? 2 : 0;
    int messageNum    = ([noticeInfo.shortMessage intValue]*4 == 4) ? 4 : 0;
    int weChatNum     = ([noticeInfo.weChat intValue]*8 == 8) ? 8 : 0;
    int qqNum         = ([noticeInfo.qq intValue]*16 == 16) ? 16 : 0;
    int skypeNum      = ([noticeInfo.skype intValue]*32 == 32) ? 32 : 0;
    int whatsAPPNum   = ([noticeInfo.whatsAPP intValue]*64 == 64) ? 64 : 0;
    int faceBookNum   = ([noticeInfo.faceBook intValue]*128 == 128) ? 128 : 0;
    int othersNum     = ([noticeInfo.others intValue]*1 == 1) ? 1 : 0;
    int noticetotal   = missedCallNum + mailNum + messageNum + weChatNum + qqNum + skypeNum + whatsAPPNum + faceBookNum;
    
    NSMutableDictionary *noticeInfoDic = [[NSMutableDictionary alloc] init];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",noticetotal] forKey:@"byte5"];
    [noticeInfoDic setObject:[NSString stringWithFormat:@"%i",othersNum] forKey:@"byte6"];
    
    NSString *noticeInfoString = [FBKSpliceBle getHexData:noticeInfoDic haveCheckNum:NO];
    [self insertQueueData:noticeInfoString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setAlarmInfoCmd
 * 功能描述：设置个人闹钟信息
 * 输入参数：alarmInfoArray-闹钟信息
 * 返回数据：
 ********************************************************************************/
- (void)setAlarmInfoCmd:(NSArray *)alarmInfoArray
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 5;
    int ackType     = 1;
    int valueLong   = 0;
    
    for (int i = 0 ; i < alarmInfoArray.count; i++)
    {
        FBKDeviceAlarmInfo *alarmInfo = [alarmInfoArray objectAtIndex:i];
        int alarmId     = [[NSString stringWithFormat:@"%@",alarmInfo.alarmId] intValue];
        int alarmFormat = 0;
        int openState = [alarmInfo.switchStatus intValue];
        NSString *timeNum = [NSString stringWithFormat:@"%@",alarmInfo.alarmTime];
        NSString *alarmName = [NSString stringWithFormat:@"%@",alarmInfo.alarmName];
        alarmName = [FBKSpliceBle utf8ToUnicode:alarmName];
        alarmName = [alarmName stringByReplacingOccurrencesOfString:@"\\u" withString:@""];
        
        if (openState == 1)
        {
            [self alramSwitch:alarmId withState:YES];
        }
        else
        {
            [self alramSwitch:alarmId withState:NO];
        }
        
        
        NSArray *weekArray = alarmInfo.repeatTime;
        
        if ([weekArray isKindOfClass:[NSArray class]])
        {
            if (weekArray.count == 1)
            {
                int mark = [[weekArray objectAtIndex:0] intValue];
                if (mark == 0 || mark >= 8)
                {
                    alarmFormat = 1;
                }
            }
        }
        
        int alarmHr = 8;
        int alarmMin = 0;
        int alarmWeek = 0;
        
        if (alarmFormat == 0)
        {
            valueLong = 4 + (int)alarmName.length/2;
            int idCode = alarmId*2 + alarmFormat;
            alarmHr = [[FBKDateFormat getDateChar:timeNum withDateType:@"HH:mm" withCharNum:6] intValue];
            alarmMin = [[FBKDateFormat getDateChar:timeNum withDateType:@"HH:mm" withCharNum:7] intValue];
            
            alarmWeek = 0;
            
            if ([weekArray isKindOfClass:[NSArray class]])
            {
                for (int i = 0; i < weekArray.count; i++)
                {
                    int weekMark = [[weekArray objectAtIndex:i] intValue];
                    
                    if(weekMark == 7)
                    {
                        alarmWeek |= 0x01;
                    }
                    else
                    {
                        alarmWeek |= (1<<weekMark);
                    }
                }
            }
            
            NSMutableDictionary *alarmInfoDic = [[NSMutableDictionary alloc] init];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",idCode] forKey:@"byte5"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",alarmHr] forKey:@"byte6"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",alarmMin] forKey:@"byte7"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",alarmWeek] forKey:@"byte8"];
            NSString *alarmInfoString = [FBKSpliceBle getHexData:alarmInfoDic haveCheckNum:NO];
            alarmInfoString = [NSString stringWithFormat:@"%@%@",alarmInfoString,alarmName];
            [self insertQueueData:alarmInfoString];
            [self setBuferString];
        }
        else
        {
            valueLong = 5 + (int)alarmName.length/2;
            int idCode = alarmId*2 + alarmFormat;
            timeNum = [NSString stringWithFormat:@"%@:00",timeNum];
            int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
            int myUtc = [FBKDateFormat getTimestamp:timeNum]+juTime;
            int time4 = myUtc / (256*256*256);
            int time3 = (myUtc % (256*256*256))/65536;
            int time2 = (myUtc % 65536)/256;
            int time1 = myUtc % 256;
            
            NSMutableDictionary *alarmInfoDic = [[NSMutableDictionary alloc] init];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",idCode] forKey:@"byte5"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",time4] forKey:@"byte6"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",time3] forKey:@"byte7"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",time2] forKey:@"byte8"];
            [alarmInfoDic setObject:[NSString stringWithFormat:@"%i",time1] forKey:@"byte9"];
            NSString *alarmInfoString = [FBKSpliceBle getHexData:alarmInfoDic haveCheckNum:NO];
            alarmInfoString = [NSString stringWithFormat:@"%@%@",alarmInfoString,alarmName];
            [self insertQueueData:alarmInfoString];
            [self setBuferString];
        }
    }
    
    [self setAlarmSwitchCmd:m_alarmSwitchState];
}


/********************************************************************************
 * 方法名称：setAlarmSwitchCmd
 * 功能描述：设置个人闹钟开关
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setAlarmSwitchCmd:(int)switchNumber
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 2;
    int ackType     = 1;
    int valueLong   = 1;
    
    NSMutableDictionary *switchDic = [[NSMutableDictionary alloc] init];
    [switchDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [switchDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [switchDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [switchDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [switchDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [switchDic setObject:[NSString stringWithFormat:@"%i",switchNumber] forKey:@"byte5"];
    
    NSString *switchString = [FBKSpliceBle getHexData:switchDic haveCheckNum:NO];
    [self insertQueueData:switchString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setBikeInfoCmd
 * 功能描述：设置单车参数
 * 输入参数：whellDiameter-单车参数
 * 返回数据：
 ********************************************************************************/
- (void)setBikeInfoCmd:(NSString *)whellDiameter
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 11;
    int ackType   = 1;
    int valueLong = 2;
    
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
    
    NSMutableDictionary *bikeDic = [[NSMutableDictionary alloc] init];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",whell1] forKey:@"byte5"];
    [bikeDic setObject:[NSString stringWithFormat:@"%i",whell2] forKey:@"byte6"];
    NSString *bikeString = [FBKSpliceBle getHexData:bikeDic haveCheckNum:NO];
    [self insertQueueData:bikeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setHeartRateMaxCmd
 * 功能描述：设置心率最大值
 * 输入参数：maxRate-心率最大值
 * 返回数据：
 ********************************************************************************/
- (void)setHeartRateMaxCmd:(NSString *)maxRate
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 13;
    int ackType   = 1;
    int valueLong = 1;
    
    NSMutableDictionary *rateDic = [[NSMutableDictionary alloc] init];
    [rateDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [rateDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [rateDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [rateDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [rateDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [rateDic setObject:[NSString stringWithFormat:@"%@",maxRate] forKey:@"byte5"];
    NSString *rateString = [FBKSpliceBle getHexData:rateDic haveCheckNum:NO];
    [self insertQueueData:rateString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setANTInfoCmd
 * 功能描述：设置ANT等级命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setANTInfoCmd:(NSString *)ANTLevel
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 12;
    int ackType   = 1;
    int valueLong = 1;
    
    NSMutableDictionary *ANTDic = [[NSMutableDictionary alloc] init];
    [ANTDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [ANTDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [ANTDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [ANTDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [ANTDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [ANTDic setObject:[NSString stringWithFormat:@"%@",ANTLevel] forKey:@"byte5"];
    NSString *ANTString = [FBKSpliceBle getHexData:ANTDic haveCheckNum:NO];
    [self insertQueueData:ANTString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：openRealTimeStepsCmd
 * 功能描述：实时数据
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openRealTimeStepsCmd:(NSString *)status
{
    int cmdId       = 1;
    int version     = m_softVersion*16+0*8;
    int keyMark     = 4;
    int ackType     = 1;
    int valueLong   = 1;
    int openState = 0;
    
    if ([status intValue])
    {
        openState = 1;
    }
    
    NSMutableDictionary *realtimeDic = [[NSMutableDictionary alloc] init];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [realtimeDic setObject:[NSString stringWithFormat:@"%i",openState] forKey:@"byte5"];
    
    NSString *realtimeString = [FBKSpliceBle getHexData:realtimeDic haveCheckNum:NO];
    [self insertQueueData:realtimeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：openTakePhotoCmd
 * 功能描述：拍照
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openTakePhotoCmd:(NSString *)status
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 15;
    int ackType   = 1;
    int valueLong = 1;
    
    NSString *mode = @"0";
    if ([status intValue])
    {
        mode = @"1";
    }
    
    NSMutableDictionary *photoModeDic = [[NSMutableDictionary alloc] init];
    [photoModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [photoModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [photoModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [photoModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [photoModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [photoModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    NSString *photoModeString = [FBKSpliceBle getHexData:photoModeDic haveCheckNum:NO];
    [self insertQueueData:photoModeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：openHeartRateModeCmd
 * 功能描述：心率模式
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openHeartRateModeCmd:(NSString *)status
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 14;
    int ackType   = 1;
    int valueLong = 1;
    
    NSString *mode = @"0";
    if ([status intValue])
    {
        mode = @"1";
    }
    
    NSMutableDictionary *rateModeDic = [[NSMutableDictionary alloc] init];
    [rateModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [rateModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [rateModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [rateModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [rateModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [rateModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    NSString *rateModeString = [FBKSpliceBle getHexData:rateModeDic haveCheckNum:NO];
    [self insertQueueData:rateModeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：enterANCSModeCmd
 * 功能描述：设置进入配对模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)openANCSModeCmd:(NSString *)status
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 16;
    int ackType   = 1;
    int valueLong = 1;
    
    NSString *mode = @"0";
    if ([status intValue])
    {
        mode = @"1";
    }
    
    NSMutableDictionary *ANCSModeDic = [[NSMutableDictionary alloc] init];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    NSString *ANCSModeString = [FBKSpliceBle getHexData:ANCSModeDic haveCheckNum:NO];
    [self insertQueueData:ANCSModeString];
    [self setBuferString];
}

/********************************************************************************
 * 方法名称：openTenHR
 * 功能描述：openTenHR
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)openTenHR:(NSString *)status
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 19;
    int ackType   = 1;
    int valueLong = 1;
    
    NSString *mode = @"0";
    if ([status intValue])
    {
        mode = @"1";
    }
    
    NSMutableDictionary *ANCSModeDic = [[NSMutableDictionary alloc] init];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    NSString *ANCSModeString = [FBKSpliceBle getHexData:ANCSModeDic haveCheckNum:NO];
    [self insertQueueData:ANCSModeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：enterHRVModeCmd
 * 功能描述：设置进入HRV模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterHRVModeCmd:(NSString *)status
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 20;
    int ackType   = 1;
    int valueLong = 1;
    
    NSString *mode = @"0";
    if ([status intValue])
    {
        mode = @"1";
    }
    
    NSMutableDictionary *ANCSModeDic = [[NSMutableDictionary alloc] init];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [ANCSModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    NSString *ANCSModeString = [FBKSpliceBle getHexData:ANCSModeDic haveCheckNum:NO];
    [self insertQueueData:ANCSModeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：enterSPO2ModeCmd
 * 功能描述：设置进入SPO2模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterSPO2ModeCmd:(NSString *)status {
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 254;
    int ackType   = 1;
    int valueLong = 2;
    int modeKey = 1;
    
    NSString *mode = @"0";
    if ([status intValue]) {
        mode = @"1";
    }
    
    NSMutableDictionary *spoModeDic = [[NSMutableDictionary alloc] init];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%i",modeKey] forKey:@"byte5"];
    [spoModeDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte6"];
    NSString *spoModeString = [FBKSpliceBle getHexData:spoModeDic haveCheckNum:NO];
    [self insertQueueData:spoModeString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：enterTemperatureModeCmd
 * 功能描述：设置进入测温模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterTemperatureModeCmd:(NSString *)status {
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 254;
    int ackType   = 1;
    int valueLong = 2;
    int modeKey = 2;
    
    NSString *mode = @"0";
    if ([status intValue]) {
        mode = @"1";
    }
    
    NSMutableDictionary *temMap = [[NSMutableDictionary alloc] init];
    [temMap setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [temMap setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [temMap setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [temMap setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [temMap setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [temMap setObject:[NSString stringWithFormat:@"%i",modeKey] forKey:@"byte5"];
    [temMap setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte6"];
    NSString *temString = [FBKSpliceBle getHexData:temMap haveCheckNum:NO];
    [self insertQueueData:temString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setHrvTimeCmd
 * 功能描述：设置HRV时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setHrvTimeCmd:(NSString *)seconds {
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 254;
    int ackType   = 1;
    int valueLong = 3;
    int modeKey = 3;
    int timeNumber = [seconds intValue];
    
    NSMutableDictionary *temMap = [[NSMutableDictionary alloc] init];
    [temMap setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [temMap setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [temMap setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [temMap setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [temMap setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [temMap setObject:[NSString stringWithFormat:@"%i",modeKey] forKey:@"byte5"];
    [temMap setObject:[NSString stringWithFormat:@"%i",timeNumber/256] forKey:@"byte6"];
    [temMap setObject:[NSString stringWithFormat:@"%i",timeNumber%256] forKey:@"byte7"];
    NSString *temString = [FBKSpliceBle getHexData:temMap haveCheckNum:NO];
    [self insertQueueData:temString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setHeartRateColor
 * 功能描述：设置心率区间颜色
 * 输入参数：hrColor-颜色信息
 * 返回数据：
 ********************************************************************************/
- (void)setHeartRateColor:(FBKDeviceHRColor *)hrColor
{
    int cmdId     = 1;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 21;
    int ackType   = 1;
    int valueLong = 3;
    
    int colorOne = [hrColor.ColorOne intValue];
    int colorTwo = [hrColor.ColorTwo intValue];
    int colorThree = [hrColor.ColorThree intValue];
    int colorFour = [hrColor.ColorFour intValue];
    int colorFive = [hrColor.ColorFive intValue];
    
    int color1 = colorOne*16+colorTwo;
    int color2 = colorThree*16+colorFour;
    int color3 = colorFive*16+0;
    
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",color1] forKey:@"byte5"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",color2] forKey:@"byte6"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%i",color3] forKey:@"byte7"];
    
    NSString *userInfoString = [FBKSpliceBle getHexData:userInfoDic haveCheckNum:NO];
    [self insertQueueData:userInfoString];
    [self setBuferString];
}


#pragma mark - **************************** 接口获取  *****************************
/********************************************************************************
 * 方法名称：getDeviceSupportCmd
 * 功能描述：获取设备支持信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceSupportCmd
{
    int cmdId     = 3;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 1;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *supportDic = [[NSMutableDictionary alloc] init];
    [supportDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [supportDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [supportDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [supportDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [supportDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *supportString = [FBKSpliceBle getHexData:supportDic haveCheckNum:NO];
    [self insertQueueData:supportString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getBeforeUtcCmd
 * 功能描述：获取上次同步的UTC
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBeforeUtcCmd
{
    int cmdId     = 3;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 2;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *beforeUtcDic = [[NSMutableDictionary alloc] init];
    [beforeUtcDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [beforeUtcDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [beforeUtcDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [beforeUtcDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [beforeUtcDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *beforeUtcString = [FBKSpliceBle getHexData:beforeUtcDic haveCheckNum:NO];
    [self insertQueueData:beforeUtcString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getTotalHistoryCmd
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getTotalRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 0;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *totalHisDic = [[NSMutableDictionary alloc] init];
    [totalHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [totalHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [totalHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [totalHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [totalHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *totalHisString = [FBKSpliceBle getHexData:totalHisDic haveCheckNum:NO];
    [self insertQueueData:totalHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getStepHistoryCmd
 * 功能描述：获取运动历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getStepRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 1;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *stepHisDic = [[NSMutableDictionary alloc] init];
    [stepHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [stepHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [stepHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [stepHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [stepHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *stepHisString = [FBKSpliceBle getHexData:stepHisDic haveCheckNum:NO];
    [self insertQueueData:stepHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getHeartRateHistoryCmd
 * 功能描述：获取心率历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHeartRateRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 2;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *heartRateHisDic = [[NSMutableDictionary alloc] init];
    [heartRateHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [heartRateHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [heartRateHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [heartRateHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [heartRateHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *heartRateHisString = [FBKSpliceBle getHexData:heartRateHisDic haveCheckNum:NO];
    [self insertQueueData:heartRateHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getBikeHistoryCmd
 * 功能描述：获取踏频历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBikeRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 3;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *bikeHisDic = [[NSMutableDictionary alloc] init];
    [bikeHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [bikeHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [bikeHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [bikeHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [bikeHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *bikeHisString = [FBKSpliceBle getHexData:bikeHisDic haveCheckNum:NO];
    [self insertQueueData:bikeHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getTrainHistoryCmd
 * 功能描述：获取训练历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getTrainRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 4;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *trainHisDic = [[NSMutableDictionary alloc] init];
    [trainHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [trainHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [trainHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [trainHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [trainHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *trainHisString = [FBKSpliceBle getHexData:trainHisDic haveCheckNum:NO];
    [self insertQueueData:trainHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getSleepHistoryCmd
 * 功能描述：获取睡眠历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getSleepRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 5;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *sleepHisDic = [[NSMutableDictionary alloc] init];
    [sleepHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [sleepHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [sleepHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [sleepHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [sleepHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *sleepHisString = [FBKSpliceBle getHexData:sleepHisDic haveCheckNum:NO];
    [self insertQueueData:sleepHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getEverydayHistoryCmd
 * 功能描述：获取每天步数总和历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getEverydayRecordCmd
{
    int cmdId     = 4;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 6;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *everydayHisDic = [[NSMutableDictionary alloc] init];
    [everydayHisDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [everydayHisDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [everydayHisDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [everydayHisDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [everydayHisDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *everydayHisString = [FBKSpliceBle getHexData:everydayHisDic haveCheckNum:NO];
    [self insertQueueData:everydayHisString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setWeightInfoCmd
 * 功能描述：秤命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setWeightInfoCmd:(NSString *)mode andUnit:(NSString *)unitNum
{
    int cmdId     = 5;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 1;
    int ackType   = 1;
    int valueLong = 2;
    
    NSMutableDictionary *weightInfoDic = [[NSMutableDictionary alloc] init];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%@",mode] forKey:@"byte5"];
    [weightInfoDic setObject:[NSString stringWithFormat:@"%@",unitNum] forKey:@"byte6"];
    NSString *weightInfoString = [FBKSpliceBle getHexData:weightInfoDic haveCheckNum:NO];
    [self insertQueueData:weightInfoString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getFitNameList
 * 功能描述：获取fit文件名列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getFitNameList
{
    int cmdId     = 6;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 1;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *fitNameDic = [[NSMutableDictionary alloc] init];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    NSString *fitNameString = [FBKSpliceBle getHexData:fitNameDic haveCheckNum:NO];
    [self insertQueueData:fitNameString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getFitFile
 * 功能描述：获取fit文件
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getFitFile:(NSString *)fitFileName
{
    int cmdId     = 6;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 2;
    int ackType   = 2;
    int valueLong = (int)fitFileName.length+1;
    
    NSMutableDictionary *fitNameDic = [[NSMutableDictionary alloc] init];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [fitNameDic setObject:[NSString stringWithFormat:@"%i",(int)fitFileName.length] forKey:@"byte5"];
    
    for (int i = 0; i < (int)fitFileName.length; i++)
    {
        int ascllNum = (int)[fitFileName characterAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"byte%i",6+i];
        [fitNameDic setObject:[NSString stringWithFormat:@"%i",ascllNum] forKey:key];
    }
    
    NSString *fitNameString = [FBKSpliceBle getHexData:fitNameDic haveCheckNum:NO];
    [self insertQueueData:fitNameString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：deleteFitFile
 * 功能描述：删除fit文件
 * 输入参数：type: 1-删除fit文件  2-删除fit文件对应的历史  3-删除前面两项
 * 返回数据：
 ********************************************************************************/
- (void)deleteFitFile:(NSString *)fitFileName andDeleteType:(int)type
{
    int cmdId     = 6;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 3;
    int ackType   = 1;
    int valueLong = (int)fitFileName.length+2;
    
    NSMutableDictionary *fitDic = [[NSMutableDictionary alloc] init];
    [fitDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",type] forKey:@"byte5"];
    [fitDic setObject:[NSString stringWithFormat:@"%i",(int)fitFileName.length] forKey:@"byte6"];
    
    for (int i = 0; i < (int)fitFileName.length; i++)
    {
        int ascllNum = (int)[fitFileName characterAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"byte%i",7+i];
        [fitDic setObject:[NSString stringWithFormat:@"%i",ascllNum] forKey:key];
    }
    
    NSString *fitString = [FBKSpliceBle getHexData:fitDic haveCheckNum:NO];
    [self insertQueueData:fitString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：setFitTimeZone
 * 功能描述：设置码表时区
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setFitTimeZone:(int)timeZone
{
    int cmdId     = 6;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 4;
    int ackType   = 1;
    int valueLong = 3;
    
    NSString *zoneString = @"E";
    if (timeZone < 0)
    {
        zoneString = @"W";
    }
    
    int myZone = abs(timeZone);
    int ascllNum = (int)[zoneString characterAtIndex:0];
    int zoneHi  = myZone / 256;
    int zoneLow = myZone % 256;
    
    NSMutableDictionary *fitZoneDic = [[NSMutableDictionary alloc] init];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",ascllNum] forKey:@"byte5"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",zoneHi] forKey:@"byte6"];
    [fitZoneDic setObject:[NSString stringWithFormat:@"%i",zoneLow] forKey:@"byte7"];
    NSString *fitZoneString = [FBKSpliceBle getHexData:fitZoneDic haveCheckNum:NO];
    [self insertQueueData:fitZoneString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：getAckCmd
 * 功能描述：回复命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getAckCmd:(NSString *)sortNumber
{
    int sortHi  = [sortNumber intValue] / 256;
    int sortLow = [sortNumber intValue] % 256;
    
    NSMutableDictionary *ackDic = [[NSMutableDictionary alloc] init];
    [ackDic setObject:[NSString stringWithFormat:@"%i",255] forKey:@"byte0"];
    [ackDic setObject:[NSString stringWithFormat:@"%i",32] forKey:@"byte1"];
    [ackDic setObject:[NSString stringWithFormat:@"%i",6] forKey:@"byte2"];
    [ackDic setObject:[NSString stringWithFormat:@"%i",sortHi] forKey:@"byte3"];
    [ackDic setObject:[NSString stringWithFormat:@"%i",sortLow] forKey:@"byte4"];
    [ackDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    NSString *ackString = [FBKSpliceBle getHexData:ackDic haveCheckNum:YES];
    [self sendBandAckCmd:ackString];
}


/********************************************************************************
 * 方法名称：sendBandAckCmd
 * 功能描述：发送回复命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendBandAckCmd:(NSString *)cmdString
{
    NSString *writeCmd = cmdString;
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:writeCmd]];
    [self.delegate sendBleCmdData:writeData];
}


#pragma mark - **************************** HUB命令  *****************************
/********************************************************************************
 * 方法名称：hubLogin
 * 功能描述：HUB登录
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubLogin:(NSString *)hubPassword
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 1;
    int ackType   = 1;
    int valueLong = (int)hubPassword.length;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    for (int i = 0; i < hubPassword.length; i++)
    {
        int asciiCode = [hubPassword characterAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"byte%i",i+5];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubPassword
 * 功能描述：获取/设置登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubPassword:(NSDictionary *)hubPwDic isGetInfo:(BOOL)isGetMode
{
    NSString *hubPwMark = [NSString stringWithFormat:@"%@",[hubPwDic objectForKey:@"hubPwMark"]];
    NSString *hubPassword = [NSString stringWithFormat:@"%@",[hubPwDic objectForKey:@"hubPassword"]];
    
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 2;
    int ackType   = 1;
    int valueLong = 0;
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else
    {
        ackType   = 1;
        valueLong = (int)hubPassword.length+2;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        [hubCmdDic setObject:hubPwMark forKey:@"byte6"];
        
        for (int i = 0; i < hubPassword.length; i++)
        {
            int asciiCode = [hubPassword characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",i+7];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubWifiMode
 * 功能描述：获取/设置WiFi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiMode:(int)wifiMode isGetInfo:(BOOL)isGetMode
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 3;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else
    {
        ackType   = 1;
        valueLong = 2;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",wifiMode] forKey:@"byte6"];
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubWifiSTA
 * 功能描述：获取/设置 WiFi STA
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiSTA:(NSDictionary *)hubStaDic staMode:(int)modeNumber
{
    NSString *hubSsid = [NSString stringWithFormat:@"%@",[hubStaDic objectForKey:@"hubSsid"]];
    NSString *hubPassword = [NSString stringWithFormat:@"%@",[hubStaDic objectForKey:@"hubPassword"]];
    NSString *hubEncryption = [NSString stringWithFormat:@"%@",[hubStaDic objectForKey:@"hubEncryption"]];
    NSString *hubAlgorithm = [NSString stringWithFormat:@"%@",[hubStaDic objectForKey:@"hubAlgorithm"]];
    int ssidLength = (int)hubSsid.length;
    int passwordLength = (int)hubPassword.length;
    
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 4;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (modeNumber == 0)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",modeNumber] forKey:@"byte5"];
    }
    else
    {
        ackType   = 1;
        valueLong = 5 + ssidLength + passwordLength;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",modeNumber] forKey:@"byte5"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ssidLength] forKey:@"byte6"];
        
        int offSet = 7;
        for (int i = 0; i < ssidLength; i++)
        {
            int asciiCode = [hubSsid characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
            offSet++;
        }
        
        [hubCmdDic setObject:hubEncryption forKey:[NSString stringWithFormat:@"byte%i",offSet]];
        offSet++;
        
        [hubCmdDic setObject:hubAlgorithm forKey:[NSString stringWithFormat:@"byte%i",offSet]];
        offSet++;
        
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",passwordLength] forKey:[NSString stringWithFormat:@"byte%i",offSet]];
        offSet++;
        
        for (int i = 0; i < passwordLength; i++)
        {
            int asciiCode = [hubPassword characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
            offSet++;
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubSocketInfo
 * 功能描述：获取/设置Socket信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubSocketInfo:(NSDictionary *)hubSocketDic isGetInfo:(BOOL)isGetMode
{
    NSString *hubSocketNo = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"hubSocketNo"]];
    NSString *hubSocketProtocol = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"hubSocketProtocol"]];
    NSString *hubSocketCs = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"hubSocketCs"]];
    NSString *hubSocketIp = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"hubSocketIp"]];
    NSString *hubSocketPort = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"hubSocketPort"]];
    int ipLength = (int)hubSocketIp.length;
    int portLength = (int)hubSocketPort.length;
    
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 5;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 2;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
        [hubCmdDic setObject:hubSocketNo forKey:@"byte6"];
    }
    else
    {
        ackType   = 1;
        valueLong = 6 + ipLength + portLength;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        [hubCmdDic setObject:hubSocketNo forKey:@"byte6"];
        [hubCmdDic setObject:hubSocketProtocol forKey:@"byte7"];
        [hubCmdDic setObject:hubSocketCs forKey:@"byte8"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ipLength] forKey:@"byte9"];
        
        int offSet = 10;
        for (int i = 0; i < ipLength; i++)
        {
            int asciiCode = [hubSocketIp characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
            offSet++;
        }
        
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",portLength] forKey:[NSString stringWithFormat:@"byte%i",offSet]];
        offSet++;
        
        for (int i = 0; i < portLength; i++)
        {
            int asciiCode = [hubSocketPort characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
            offSet++;
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubNetworkMode
 * 功能描述：获取/设置HUB内外网模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubNetworkMode:(int)networkMode isGetInfo:(BOOL)isGetMode
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 6;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else
    {
        ackType   = 1;
        valueLong = 2;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",networkMode] forKey:@"byte6"];
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubRemark
 * 功能描述：获取/设置HUB备注
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubRemark:(NSString *)markString isGetInfo:(BOOL)isGetMode
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 7;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else
    {
        ackType   = 2;
        valueLong = 1 + (int)markString.length;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        
        for (int i = 0; i < markString.length; i++)
        {
            int asciiCode = [markString characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",i+6];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubGetIpKey
 * 功能描述：获取HUB IP key
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubGetIpKey
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 8;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubScanWifi
 * 功能描述：HUB扫描WiFi
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubScanWifi
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 9;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubRestart
 * 功能描述：HUB复位重启
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubRestart
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 10;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubReset
 * 功能描述：HUB回复出厂设置
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubReset
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 11;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hubGetWifiStatus
 * 功能描述：获取WiFi状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubGetWifiStatus
{
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 12;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/********************************************************************************
 * 方法名称：hub4GAPN
 * 功能描述：获取、配置4G APN信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hub4GAPN:(NSString *)APNString isGetInfo:(BOOL)isGetMode {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 13;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode)
    {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else
    {
        ackType   = 1;
        valueLong = 1 + (int)APNString.length;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
        
        for (int i = 0; i < APNString.length; i++) {
            int asciiCode = [APNString characterAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"byte%i",i+6];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubSetDataType
 * 功能描述：设置数据上下行模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubSetDataType:(int)dataType {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 14;
    int ackType   = 1;
    int valueLong = 2;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",dataType] forKey:@"byte6"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubSetScanSwitch
 * 功能描述：设置扫描开关
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubSetScanSwitch:(int)scanSwitch {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 15;
    int ackType   = 1;
    int valueLong = 2;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",scanSwitch] forKey:@"byte6"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-*****************************************************************************
 * 方法名称：hubScanInfo
 * 功能描述：设置蓝牙扫描参数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubScanInfo:(NSDictionary *)hubSocketDic
{
    NSString *scanName = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"scanName"]];
    NSString *scanUuid = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"scanUuid"]];
    NSString *scanRssi = [NSString stringWithFormat:@"%@",[hubSocketDic objectForKey:@"scanRssi"]];
    int nameLength = (int)scanName.length;
    
    if (scanUuid.length%2 != 0) {
        return;
    }
    
    NSData *uuidData = [FBKSpliceBle getWriteData:scanUuid];
    const uint8_t *bytes = [uuidData bytes];
    int uuidLength = (int) uuidData.length;
    
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 16;
    int ackType   = 1;
    int valueLong = 4 + nameLength + uuidLength;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",nameLength] forKey:@"byte6"];
    
    int offSet = 7;
    for (int i = 0; i < nameLength; i++) {
        int asciiCode = [scanName characterAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
        offSet++;
    }
    
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",uuidLength] forKey:[NSString stringWithFormat:@"byte%i",offSet]];
    offSet++;

    for (int i = 0; i < uuidLength; i++) {
        int asciiCode = bytes[i]&0xFF;;
        NSString *key = [NSString stringWithFormat:@"byte%i",offSet];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",asciiCode] forKey:key];
        offSet++;
    }
    
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",[scanRssi intValue]] forKey:[NSString stringWithFormat:@"byte%i",offSet]];
    offSet++;
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubSystenStatus
 * 功能描述：获取系统状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubSystenStatus {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 17;
    int ackType   = 2;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubIPV4Info
 * 功能描述：获取/配置IPV4数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubIPV4Info:(NSDictionary *)hubIPV4Dic isGetInfo:(BOOL)isGetMode {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 18;
    int ackType   = 1;
    int valueLong = 0;
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    
    if (isGetMode) {
        ackType   = 2;
        valueLong = 1;
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    }
    else {
        ackType   = 1;
        NSString *ipType = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"ipType"]];
        NSString *dnsType = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"dnsType"]];
        NSString *ipString = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"ip"]];
        NSString *maskString = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"mask"]];
        NSString *gatewayString = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"gateway"]];
        NSString *dnsString = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"dns"]];
        NSString *spareDnsString = [NSString stringWithFormat:@"%@",[hubIPV4Dic objectForKey:@"spareDns"]];
        [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
        
        if ([ipType intValue] == 0) {
            if ([dnsType intValue] == 0) {
                valueLong = 1 + 2;
                [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
                [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
                [hubCmdDic setObject:ipType forKey:@"byte6"];
                [hubCmdDic setObject:dnsType forKey:@"byte7"];
            }
            else {
                valueLong = 1 + 10;
                [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
                [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
                [hubCmdDic setObject:ipType forKey:@"byte6"];
                [hubCmdDic setObject:dnsType forKey:@"byte7"];
                
                int offSet = 8;
                NSArray *dnsArray = [dnsString componentsSeparatedByString:@"."];
                if (dnsArray.count == 4) {
                    for (int i = 0; i < dnsArray.count; i++) {
                        NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                        [hubCmdDic setObject:[dnsArray objectAtIndex:i] forKey:keyString];
                        offSet++;
                    }
                }
                
                NSArray *spareDnsArray = [spareDnsString componentsSeparatedByString:@"."];
                if (spareDnsArray.count == 4) {
                    for (int i = 0; i < spareDnsArray.count; i++) {
                        NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                        [hubCmdDic setObject:[spareDnsArray objectAtIndex:i] forKey:keyString];
                        offSet++;
                    }
                }
            }
        }
        else {
            valueLong = 1 + 22;
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
            [hubCmdDic setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte5"];
            [hubCmdDic setObject:ipType forKey:@"byte6"];
            [hubCmdDic setObject:dnsType forKey:@"byte7"];
            
            int offSet = 8;
            NSArray *ipArray = [ipString componentsSeparatedByString:@"."];
            if (ipArray.count == 4) {
                for (int i = 0; i < ipArray.count; i++) {
                    NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                    [hubCmdDic setObject:[ipArray objectAtIndex:i] forKey:keyString];
                    offSet++;
                }
            }
            
            NSArray *maskArray = [maskString componentsSeparatedByString:@"."];
            if (maskArray.count == 4) {
                for (int i = 0; i < maskArray.count; i++) {
                    NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                    [hubCmdDic setObject:[maskArray objectAtIndex:i] forKey:keyString];
                    offSet++;
                }
            }
            
            NSArray *gatewayArray = [gatewayString componentsSeparatedByString:@"."];
            if (gatewayArray.count == 4) {
                for (int i = 0; i < gatewayArray.count; i++) {
                    NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                    [hubCmdDic setObject:[gatewayArray objectAtIndex:i] forKey:keyString];
                    offSet++;
                }
            }
            
            NSArray *dnsArray = [dnsString componentsSeparatedByString:@"."];
            if (dnsArray.count == 4) {
                for (int i = 0; i < dnsArray.count; i++) {
                    NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                    [hubCmdDic setObject:[dnsArray objectAtIndex:i] forKey:keyString];
                    offSet++;
                }
            }
            
            NSArray *spareDnsArray = [spareDnsString componentsSeparatedByString:@"."];
            if (spareDnsArray.count == 4) {
                for (int i = 0; i < spareDnsArray.count; i++) {
                    NSString *keyString = [NSString stringWithFormat:@"byte%i",offSet];
                    [hubCmdDic setObject:[spareDnsArray objectAtIndex:i] forKey:keyString];
                    offSet++;
                }
            }
        }
    }
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubSetLoraNo
 * 功能描述：设置Lora通道
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubSetLoraNo:(NSDictionary *)loraInfoMap {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 19;
    int ackType   = 2;
    int valueLong = 5;
    
    NSString *totalChannel = [NSString stringWithFormat:@"%@",[loraInfoMap objectForKey:@"totalChannel"]];
    NSString *nowChannel = [NSString stringWithFormat:@"%@",[loraInfoMap objectForKey:@"nowChannel"]];
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",[totalChannel intValue]] forKey:@"byte5"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",[nowChannel intValue]] forKey:@"byte6"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte7"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte8"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte9"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


/*-******************************************************************************
 * 方法名称：hubDiagnosisLoraNo
 * 功能描述：诊断Lora通道
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubDiagnosisLoraNo:(NSDictionary *)loraInfoMap {
    int cmdId     = 7;
    int version   = m_softVersion*16+0*8;
    int keyMark   = 20;
    int ackType   = 2;
    int valueLong = 3;
     
    NSString *channel = [NSString stringWithFormat:@"%@",[loraInfoMap objectForKey:@"channel"]];
    NSString *seconds = [NSString stringWithFormat:@"%@",[loraInfoMap objectForKey:@"seconds"]];
    
    NSMutableDictionary *hubCmdDic = [[NSMutableDictionary alloc] init];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",cmdId] forKey:@"byte0"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",version] forKey:@"byte1"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",keyMark] forKey:@"byte2"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",ackType] forKey:@"byte3"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",valueLong] forKey:@"byte4"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",[channel intValue]] forKey:@"byte5"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",[seconds intValue]] forKey:@"byte6"];
    [hubCmdDic setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte7"];
    
    NSString *hubCmdString = [FBKSpliceBle getHexData:hubCmdDic haveCheckNum:NO];
    [self insertQueueData:hubCmdString];
    [self setBuferString];
}


@end
