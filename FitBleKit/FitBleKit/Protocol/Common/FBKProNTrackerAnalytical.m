/********************************************************************************
 * 文件名称：FBKProNewBandAnalytical.m
 * 内容摘要：新手环解析数据
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import "FBKProNTrackerAnalytical.h"
#import "FBKAnalyticalHubConfig.h"
#import "FBKSpliceBle.h"
#import "FBKDateFormat.h"

@implementation FBKProNTrackerAnalytical
{
    NSMutableArray *m_receiveQueueArray;
    NSString *m_saveHexString;
    FBKProNTrackerBigData *m_bigData;
    FBKAnalyticalHubConfig *m_hubConfig;
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
    
    m_receiveQueueArray = [[NSMutableArray alloc] init];
    m_saveHexString = [[NSString alloc] init];
    m_bigData = [[FBKProNTrackerBigData alloc] init];
    m_hubConfig = [[FBKAnalyticalHubConfig alloc] init];
    m_bigData.delegate = self;
    
    return self;
}


/********************************************************************************
 * 方法名称：receiveBlueDataError
 * 功能描述：获取到蓝牙回复的数据中断
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBlueDataError
{
    [m_bigData bleError];
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙回复的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBlueData:(NSString *)hexString
{
    int length = (int)hexString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[hexString length]; i++)
    {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    
    int lastNumber = bytes[length-1];
    int checkNumber = 0;
    for (int i = 0; i < length-1; i++)
    {
        int value = bytes[i];
        checkNumber = checkNumber + value;
    }
    
    if (lastNumber != checkNumber%256)
    {
        NSLog(@"****************校验和错误！！！");
        return;
    }
    
    if (hexString.length >= 8)
    {
        int byte1  = bytes[1]&0xFF;
        
        if (byte1 == 32 && hexString.length >= 10)
        {
            NSString *sortMark = [[hexString substringFromIndex:6] substringToIndex:4];
            [self.delegate analyticalSucceed:sortMark withResultNumber:FBKAnalyticalSendSuseed];
            return;
        }
        
        int isMore = [FBKSpliceBle getBitNumber:byte1 andStart:7 withStop:7];
        int isEnd  = [FBKSpliceBle getBitNumber:byte1 andStart:6 withStop:6];
        int bagNo = [FBKSpliceBle getBitNumber:byte1 andStart:0 withStop:3];
        NSString *userString = [[hexString substringFromIndex:6] substringToIndex:hexString.length-8];
        
        if (isMore==0)
        {
            // 应用层
            [self analyticalBlueData:userString];
        }
        else
        {
            if (isEnd==0 && bagNo==0)
            {
                [m_receiveQueueArray removeAllObjects];
                [m_receiveQueueArray addObject:userString];
            }
            else if (isEnd==0 && bagNo!=0)
            {
                [m_receiveQueueArray addObject:userString];
            }
            else
            {
                [m_receiveQueueArray addObject:userString];
                NSMutableString *resultString = [[NSMutableString alloc] init];
                
                for (int i = 0; i < m_receiveQueueArray.count; i++)
                {
                    [resultString appendString:[m_receiveQueueArray objectAtIndex:i]];
                }
                
                if (m_receiveQueueArray.count == bagNo+1)
                {
                    // 应用层
                    [self analyticalBlueData:resultString];
                }
                
                [m_receiveQueueArray removeAllObjects];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：analyticalBlueData
 * 功能描述：解析蓝牙数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalBlueData:(NSString *)hexString
{
    int length = (int)hexString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[hexString length]; i++)
    {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    
    int sortNum   = (int)((bytes[0]&0xFF)<<8) + (int)(bytes[1]&0xFF);
    int cmdId     = bytes[2]&0xFF;
    int keyMark   = bytes[4]&0xFF;
    int ackType   = bytes[5]&0xFF;
    int valueLong = bytes[6]&0xFF;
    int byteNum   = 7;
    
    [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",sortNum] withResultNumber:FBKAnalyticalAck];
    
    if ([m_saveHexString isEqualToString:hexString])
    {
        if (cmdId == 4)
        {
            return;
        }
    }
    m_saveHexString = hexString;
    
    for (int i = 0; i < 32; i++)
    {
        NSMutableArray *byteArray = [[NSMutableArray alloc] init];
        [byteArray addObject:[NSString stringWithFormat:@"%i",keyMark]];
        
        for (int j = byteNum; j < valueLong+byteNum; j++)
        {
            [byteArray addObject:[NSString stringWithFormat:@"%i",bytes[j]&0xFF]];
        }
        
        switch (cmdId)
        {
            case 1:
            {
                [self realtimeData:byteArray];
                break;
            }
                
            case 2:
            {
                [self findMyPhone:byteArray];
                break;
            }
                
            case 3:
            {
                [self standByFunctionOrBeforeSysTime:byteArray];
                break;
            }
                
            case 4:
            {
                [self.delegate analyticalSucceed:nil withResultNumber:FBKAnalyticalSyncing];
                m_bigData.bigDataDeviceType = self.analyticalDeviceType;
                [m_bigData analyticalBigData:byteArray];
                break;
            }
                
            case 5:
            {
                [self protocolVersion:byteArray];
                break;
            }
                
            case 6:
            {
                [self weightBlueData:byteArray];
                break;
            }
                
            case 7:
            {
                [self fitFileBlueData:byteArray];
                break;
            }
                
            case 8:
            {
                [self hubAnalyticalData:byteArray];
                break;
            }
                
            default:
            {
                break;
            }
        }
        
        if (valueLong+byteNum == length)
        {
            break;
        }
        
        keyMark   = bytes[byteNum+valueLong]&0xFF;
        ackType   = bytes[byteNum+valueLong+1]&0xFF;
        valueLong = bytes[byteNum+valueLong+2]&0xFF;
        byteNum   = byteNum+valueLong+3;
    }
}


/********************************************************************************
 * 方法名称：realtimeSteps
 * 功能描述：解析实时步数数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)realtimeData:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        
        if (keyMark == 1 && hexArray.count == 10)
        {
            NSMutableDictionary *realtimeDic = [[NSMutableDictionary alloc] init];
            int stepHi  = [[hexArray objectAtIndex:1] intValue];
            int stepMin = [[hexArray objectAtIndex:2] intValue];
            int stepLow = [[hexArray objectAtIndex:3] intValue];
            NSString *stepNum = [NSString stringWithFormat:@"%d",stepLow+(stepMin<<8)+(stepHi<<16)];
            [realtimeDic setObject:stepNum forKey:@"stepNum"];
            
            int disHi  = [[hexArray objectAtIndex:4] intValue];
            int disMin = [[hexArray objectAtIndex:5] intValue];
            int disLow = [[hexArray objectAtIndex:6] intValue];
            NSString *stepDistance = [NSString stringWithFormat:@"%.1f",(float)(disLow+(disMin<<8)+(disHi<<16))/100000];
            [realtimeDic setObject:stepDistance forKey:@"stepDistance"];
            
            int kcalHi  = [[hexArray objectAtIndex:7] intValue];
            int kcalMin = [[hexArray objectAtIndex:8] intValue];
            int kcalLow = [[hexArray objectAtIndex:9] intValue];
            NSString *stepKcal = [NSString stringWithFormat:@"%.1f",(float)(kcalLow+(kcalMin<<8)+(kcalHi<<16))/10];
            [realtimeDic setObject:stepKcal forKey:@"stepKcal"];
            
            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            [realtimeDic setObject:nowTime forKey:@"locTime"];
            [realtimeDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            
            [self.delegate analyticalSucceed:realtimeDic withResultNumber:FBKAnalyticalRealTimeSteps];
            
            #ifdef FBKLOGNTRACKERINFO
            NSLog(@"实时步数：%@",realtimeDic);
            #endif
        }
        else if (keyMark == 2 && hexArray.count >= 5)
        {
            NSMutableDictionary *realtimeDic = [[NSMutableDictionary alloc] init];
            int stepHi  = [[hexArray objectAtIndex:1] intValue];
            int stepMin = [[hexArray objectAtIndex:2] intValue];
            int stepLow = [[hexArray objectAtIndex:3] intValue];
            NSString *stepNum = [NSString stringWithFormat:@"%d",stepLow+(stepMin<<8)+(stepHi<<16)];
            [realtimeDic setObject:stepNum forKey:@"stepNum"];
            
            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            [realtimeDic setObject:nowTime forKey:@"locTime"];
            [realtimeDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            
            int stepFrequency = [[hexArray objectAtIndex:4] intValue];
            [realtimeDic setObject:[NSString stringWithFormat:@"%i",stepFrequency] forKey:@"stepFrequency"];
            
            if (hexArray.count == 8) {
                [realtimeDic setObject:@"0" forKey:@"stepKcal"];
                int calHi  = [[hexArray objectAtIndex:5] intValue];
                int calMin = [[hexArray objectAtIndex:6] intValue];
                int calLow = [[hexArray objectAtIndex:7] intValue];
                NSString *kcalNum = [NSString stringWithFormat:@"%d",calLow+(calMin<<8)+(calHi<<16)];
                [realtimeDic setObject:kcalNum forKey:@"stepKcal"];
            }
            
            
            [self.delegate analyticalSucceed:realtimeDic withResultNumber:FBKAnalyticalRTStepFrequency];
            
            #ifdef FBKLOGNTRACKERINFO
            NSLog(@"实时步频：%@",realtimeDic);
            #endif
        }
        else if (keyMark == 3 && (hexArray.count == 16 || hexArray.count == 22))
        {
            NSMutableDictionary *realtimeDic = [[NSMutableDictionary alloc] init];
            int fistNumHi  = [[hexArray objectAtIndex:1] intValue];
            int fistNumlow = [[hexArray objectAtIndex:2] intValue];
            NSString *fistNum = [NSString stringWithFormat:@"%d",fistNumlow+(fistNumHi<<8)];
            [realtimeDic setObject:fistNum forKey:@"fistNum"];
            
            int fistType = [[hexArray objectAtIndex:3] intValue];
            NSString *fistTypeString = [NSString stringWithFormat:@"%d",fistType];
            [realtimeDic setObject:fistTypeString forKey:@"fistType"];
            
            int insertNumber = 1;
            int fistOutHi  = [[hexArray objectAtIndex:3+insertNumber] intValue];
            int fistOutlow = [[hexArray objectAtIndex:4+insertNumber] intValue];
            NSString *fistOutTime = [NSString stringWithFormat:@"%d",fistOutlow+(fistOutHi<<8)];
            [realtimeDic setObject:fistOutTime forKey:@"fistOutTime"];
            
            int fistInHi  = [[hexArray objectAtIndex:5+insertNumber] intValue];
            int fistInlow = [[hexArray objectAtIndex:6+insertNumber] intValue];
            NSString *fistInTime = [NSString stringWithFormat:@"%d",fistInlow+(fistInHi<<8)];
            [realtimeDic setObject:fistInTime forKey:@"fistInTime"];
            
            int fistPowerHi  = [[hexArray objectAtIndex:7+insertNumber] intValue];
            int fistPowerLow = [[hexArray objectAtIndex:8+insertNumber] intValue];
            NSString *fistPower = [NSString stringWithFormat:@"%.2f",(double)(fistPowerLow+(fistPowerHi<<8))/100];
            [realtimeDic setObject:fistPower forKey:@"fistPower"];
            
            int fistSpeedHi  = [[hexArray objectAtIndex:9+insertNumber] intValue];
            int fistSpeedMin = [[hexArray objectAtIndex:10+insertNumber] intValue];
            int fistSpeedLow = [[hexArray objectAtIndex:11+insertNumber] intValue];
            NSString *fistSpeed = [NSString stringWithFormat:@"%.3f",(double)(fistSpeedLow+(fistSpeedMin<<8)+(fistSpeedHi<<16))/1000];
            [realtimeDic setObject:fistSpeed forKey:@"fistSpeed"];
            
            int fistDisHi  = [[hexArray objectAtIndex:12+insertNumber] intValue];
            int fistDisMin = [[hexArray objectAtIndex:13+insertNumber] intValue];
            int fistDisLow = [[hexArray objectAtIndex:14+insertNumber] intValue];
            NSString *fistDistance = [NSString stringWithFormat:@"%.3f",(double)(fistDisLow+(fistDisMin<<8)+(fistDisHi<<16))/1000];
            [realtimeDic setObject:fistDistance forKey:@"fistDistance"];
            
            if (hexArray.count == 22) {
                int utc1   = [[hexArray objectAtIndex:15+insertNumber] intValue];
                int utc2   = [[hexArray objectAtIndex:16+insertNumber] intValue];
                int utc3   = [[hexArray objectAtIndex:17+insertNumber] intValue];
                int utc4   = [[hexArray objectAtIndex:18+insertNumber] intValue];
                int utc5   = [[hexArray objectAtIndex:19+insertNumber] intValue];
                int utc6   = [[hexArray objectAtIndex:20+insertNumber] intValue];
                int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24);
                int millisecond = utc6 + (utc5<<8);
                int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
                
                NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
                [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                NSDate *beforeTime = [NSDate dateWithTimeIntervalSince1970:myUtc-GMTNUM];
                NSString *fistDate = [myFormatter stringFromDate:beforeTime];
                NSString *dateString = [NSString stringWithFormat:@"%@ %i",fistDate,millisecond];
                [realtimeDic setObject:dateString forKey:@"fistDate"];
            }
            
            [self.delegate analyticalSucceed:realtimeDic withResultNumber:FBKAnalyticalRTFistInfo];
        }
    }
}


/********************************************************************************
 * 方法名称：findMyPhone
 * 功能描述：查找手机
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)findMyPhone:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        
        if (keyMark == 1 && hexArray.count == 2)
        {
            int findKey  = [[hexArray objectAtIndex:1] intValue];
            
            if (findKey == 0)
            {
                [self.delegate analyticalSucceed:@"0" withResultNumber:FBKAnalyticalFindPhone];
            }
            else
            {
                [self.delegate analyticalSucceed:@"1" withResultNumber:FBKAnalyticalFindPhone];
            }
        }
        else if (keyMark == 2)
        {
            [self.delegate analyticalSucceed:nil withResultNumber:FBKAnalyticalTakePhoto];
            
        }
        else if (keyMark == 3 && hexArray.count == 2)
        {
            int musicState  = [[hexArray objectAtIndex:1] intValue];
            
            if (musicState == 0)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicStop] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 1)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicPlay] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 3)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicBefore] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 5)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicNext] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 9)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicMinVolume] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 17)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicAddVolume] withResultNumber:FBKAnalyticalMusicStatus];
            }
            else if (musicState == 33)
            {
                [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",MusicPause] withResultNumber:FBKAnalyticalMusicStatus];
            }
        }
        
    }
}


/********************************************************************************
 * 方法名称：standByFunction
 * 功能描述：硬件支持的功能或上次同步时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)standByFunctionOrBeforeSysTime:(NSArray *)hexArray {
    if (hexArray.count > 0) {
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        
        if (keyMark == 1 && hexArray.count == 7) {
            int byRealData  = [[hexArray objectAtIndex:1] intValue];
            int byNotice    = [[hexArray objectAtIndex:2] intValue];
            int byBigData   = [[hexArray objectAtIndex:3] intValue];
            int byBike      = [[hexArray objectAtIndex:4] intValue];
            int byHeartRate = [[hexArray objectAtIndex:5] intValue];
            int byAnt       = [[hexArray objectAtIndex:6] intValue];
            
            if ([FBKSpliceBle getBitNumber:byRealData andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持实时步数");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持Android电话提醒");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:1 withStop:1] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持Android来电信息显示");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:2 withStop:2] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持Android消息提醒");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:3 withStop:3] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持Android消息显示");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:4 withStop:4] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持闹钟提醒");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:5 withStop:5] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持闹钟消息内容显示");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:6 withStop:6] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持久坐提醒");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byNotice andStart:7 withStop:7] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持喝水提醒");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持运动细分数据的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:1 withStop:1] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持心率数据的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:2 withStop:2] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持速度与踏频的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:3 withStop:3] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持训练模式及训练时间的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:4 withStop:4] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持睡眠数据的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBigData andStart:5 withStop:5] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持每天运动总数据的存储");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byBike andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持单车参数设置");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byHeartRate andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持心率参数设置");
                #endif
            }
            
            if ([FBKSpliceBle getBitNumber:byAnt andStart:0 withStop:0] == 1) {
                #ifdef FBKLOGNTRACKERINFO
                NSLog(@"该设备支持ANT参数设置");
                #endif
            }
        }
        else if (keyMark == 2 && hexArray.count == 5) {
            int utc1   = [[hexArray objectAtIndex:1] intValue];
            int utc2   = [[hexArray objectAtIndex:2] intValue];
            int utc3   = [[hexArray objectAtIndex:3] intValue];
            int utc4   = [[hexArray objectAtIndex:4] intValue];
            int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24);
            int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
            
            NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
            [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSDate *beforeTime = [NSDate dateWithTimeIntervalSince1970:myUtc-GMTNUM];
            NSString *beforeDate = [myFormatter stringFromDate:beforeTime];
            [self.delegate analyticalSucceed:beforeDate withResultNumber:FBKAnalyticalLastSyncTime];
            
            #ifdef FBKLOGNTRACKERINFO
            NSLog(@"上次同步时间为：%@",beforeDate);
            #endif
        }
        else if (keyMark == 3 && hexArray.count >= 3) {
            int dataType = [[hexArray objectAtIndex:1] intValue];
            
            if (dataType == 1) {
            }
            else if (dataType == 2) {
                int valueLength = [[hexArray objectAtIndex:2] intValue];
                if (hexArray.count >= 3+valueLength) {
                    int offset = 2;
                    int rmssd1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int rmssd2 = [[hexArray objectAtIndex:offset+2] intValue];
                    int rmssd = (rmssd1<<8) + rmssd2;
                    offset = offset+2;
                    
                    int pnn1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int pnn2 = [[hexArray objectAtIndex:offset+2] intValue];
                    int pnn50 = (pnn1<<8) + pnn2;
                    offset = offset+2;
                    
                    int nnvgr1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int nnvgr2 = [[hexArray objectAtIndex:offset+2] intValue];
                    int nnvgr = (nnvgr1<<8) + nnvgr2;
                    offset = offset+2;
                    
                    int sdnn1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int sdnn2 = [[hexArray objectAtIndex:offset+2] intValue];
                    int sdnn = (sdnn1<<8) + sdnn2;
                    offset = offset+2;
                    
                    int hrv1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int hrv2 = [[hexArray objectAtIndex:offset+2] intValue];
                    int hrv = (hrv1<<8) + hrv2;
                    offset = offset+2;
                    
                    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",rmssd] forKey:@"rmssd"];
                    [resultMap setObject:[NSString stringWithFormat:@"%.2f",(double)pnn50/100] forKey:@"pnn50"];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",nnvgr] forKey:@"nnvgr"];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",sdnn] forKey:@"sdnn"];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",hrv] forKey:@"hrv"];
                    [self.delegate analyticalSucceed:resultMap withResultNumber:FBKAnalyticalHRVData];
                }
            }
        }
        else if (keyMark == 254) {
            int dataType = [[hexArray objectAtIndex:1] intValue];
            
            if (dataType == 1) {
                NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
                [resultMap setObject:@"0" forKey:@"surfaceTemperature"];
                [resultMap setObject:@"0" forKey:@"ambientTemperature"];
                [resultMap setObject:@"0" forKey:@"armpitTemperature"];
                [resultMap setObject:@"0" forKey:@"heartRate"];
                [resultMap setObject:@"0" forKey:@"status"];
                
                int offset = 1;
                if (hexArray.count >= 4) {
                    int tem1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int tem2 = [[hexArray objectAtIndex:offset+2] intValue];
                    offset = offset+2;
                    
                    int myTem = (tem1<<8) + tem2;
                    NSString *temString = [NSString stringWithFormat:@"%.2f",(double)myTem/100];
                    [resultMap setObject:temString forKey:@"surfaceTemperature"];
                }
                
                if (hexArray.count >= 6) {
                    int tem1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int tem2 = [[hexArray objectAtIndex:offset+2] intValue];
                    offset = offset+2;
                    
                    int myTem = (tem1<<8) + tem2;
                    NSString *temString = [NSString stringWithFormat:@"%.2f",(double)myTem/100];
                    [resultMap setObject:temString forKey:@"ambientTemperature"];
                }
                
                if (hexArray.count >= 8) {
                    int tem1 = [[hexArray objectAtIndex:offset+1] intValue];
                    int tem2 = [[hexArray objectAtIndex:offset+2] intValue];
                    offset = offset+2;
                    
                    int myTem = (tem1<<8) + tem2;
                    NSString *temString = [NSString stringWithFormat:@"%.2f",(double)myTem/100];
                    [resultMap setObject:temString forKey:@"armpitTemperature"];
                }
                
                if (hexArray.count >= 9) {
                    int heartRate = [[hexArray objectAtIndex:offset+1] intValue];
                    offset = offset+1;
                    
                    NSString *heartString = [NSString stringWithFormat:@"%i",heartRate];
                    [resultMap setObject:heartString forKey:@"heartRate"];
                }
                
                if (hexArray.count >= 10) {
                    int stauts = [[hexArray objectAtIndex:offset+1] intValue];
                    offset = offset+1;
                    
//                    0x00: 自动测试中 0x01: 自动测试超时 0x02: 手动测试中 0x03: 手动测试结束 0x04: 手动测试超时
                    NSString *stautString = [NSString stringWithFormat:@"%i",stauts];
                    [resultMap setObject:stautString forKey:@"status"];
                }
                
                // 体温 = 32.7288 + 0.0070*心率 + 0.1559*HW体表 - 0.0650*HW环境
                
                [self.delegate analyticalSucceed:resultMap withResultNumber:FBKAnalyticalRTTem];
            }
            else if (dataType == 2) {
                if (hexArray.count >= 4) {
                    int list1 = [[hexArray objectAtIndex:2] intValue];
                    int list2 = [[hexArray objectAtIndex:3] intValue];
                    
                    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",list1] forKey:@"spo2"];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",list2] forKey:@"isMoving"];
                    [resultMap setObject:@"0" forKey:@"status"];
                    
//                    0x00: 数据为自动测试值 0x01: 自动测试超时 0x02: 数据为手动测试值 0x03: 手动测试超时
                    if (hexArray.count >= 5) {

                        int stauts = [[hexArray objectAtIndex:4] intValue];
                        NSString *stautString = [NSString stringWithFormat:@"%i",stauts];
                        [resultMap setObject:stautString forKey:@"status"];
                    }
                    
                    [self.delegate analyticalSucceed:resultMap withResultNumber:FBKAnalyticalRTSPO2];
                }
            }
        }
    }
}


/********************************************************************************
 * 方法名称：protocolVersion
 * 功能描述：协议版本
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)protocolVersion:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        
        if (keyMark == 1 && hexArray.count == 2)
        {
            int version  = [[hexArray objectAtIndex:1] intValue];
            
            #ifdef FBKLOGNTRACKERINFO
            NSLog(@"该硬件的协议版本为：%i",version);
            #endif
            
            [self.delegate analyticalSucceed:[NSString stringWithFormat:@"%i",version] withResultNumber:FBKAnalyticalDeviceVersion];
        }
    }
}


/********************************************************************************
 * 方法名称：weightBlueData
 * 功能描述：体重信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)weightBlueData:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        
        if (keyMark == 1 && hexArray.count == 10)
        {
            NSMutableDictionary *weightDic = [[NSMutableDictionary alloc] init];
            int weightHi  = [[hexArray objectAtIndex:1] intValue];
            int weightLow = [[hexArray objectAtIndex:2] intValue];
            NSString *stepNum = [NSString stringWithFormat:@"%.2f",(float)(weightLow+(weightHi<<8))/100];
            [weightDic setObject:stepNum forKey:@"weight"];
            
            int units  = [[hexArray objectAtIndex:3] intValue];
            NSString *unitString = [NSString stringWithFormat:@"%d",units];
            [weightDic setObject:unitString forKey:@"units"];
            
            int ohmHi  = [[hexArray objectAtIndex:4] intValue];
            int ohmMin = [[hexArray objectAtIndex:5] intValue];
            NSString *ohmStr = [NSString stringWithFormat:@"%.1f",(float)(ohmMin+(ohmHi<<8))/10];
            [weightDic setObject:ohmStr forKey:@"ohm"];
            
            int ohmSeHi  = [[hexArray objectAtIndex:6] intValue];
            int ohmSeMid  = [[hexArray objectAtIndex:7] intValue];
            int ohmSeMin = [[hexArray objectAtIndex:8] intValue];
            NSString *ohmSeStr = [NSString stringWithFormat:@"%d",ohmSeMin+(ohmSeMid<<8)+(ohmSeHi<<16)];
            [weightDic setObject:ohmSeStr forKey:@"encryptOhm"];
            
            int deviceType  = [[hexArray objectAtIndex:9] intValue];
            NSString *typeString = [NSString stringWithFormat:@"%d",deviceType];
            [weightDic setObject:typeString forKey:@"deviceType"];
            
            NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
            [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSString *weightDate = [myFormatter stringFromDate:[NSDate date]];
            [weightDic setObject:weightDate forKey:@"weightTime"];
            [weightDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:weightDate]] forKey:@"timestamps"];
            
            [self.delegate analyticalSucceed:weightDic withResultNumber:FBKAnalyticalBigData];
            
        }
        else if (keyMark == 2)
        {
            [m_bigData analyticalWeightBigData:hexArray];
        }
        else if (keyMark == 3)
        {
            NSMutableDictionary *weightDic = [[NSMutableDictionary alloc] init];
            int weightHi  = [[hexArray objectAtIndex:1] intValue];
            int weightLow = [[hexArray objectAtIndex:2] intValue];
            NSString *stepNum = [NSString stringWithFormat:@"%.2f",(float)(weightLow+(weightHi<<8))/100];
            [weightDic setObject:stepNum forKey:@"weightNumber"];
            [weightDic setObject:@"256" forKey:@"weightMark"];
            
            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            [weightDic setObject:nowTime forKey:@"createTime"];
            [weightDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            [self.delegate analyticalSucceed:weightDic withResultNumber:FBKAnalyticalRTWeight];
        }
    }
}


/********************************************************************************
 * 方法名称：fitFileData
 * 功能描述：fit文件信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)fitFileBlueData:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        [m_bigData analyticalFitFileData:hexArray];
    }
}


/********************************************************************************
 * 方法名称：hubAnalyticalData
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubAnalyticalData:(NSArray *)hexArray
{
    if (hexArray > 0)
    {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        int keyMark = [[hexArray objectAtIndex:0] intValue];
        
        switch (keyMark)
        {
            case 1:
            {
                NSDictionary *dataDic = [m_hubConfig loginStatus:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubLoginStatus];
                break;
            }
                
            case 2:
            {
                NSDictionary *dataDic = [m_hubConfig loginPassword:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubLoginPw];
                break;
            }
                
            case 3:
            {
                NSDictionary *dataDic = [m_hubConfig wifiWorkMode:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubWifiWorkMode];
                break;
            }
                
            case 4:
            {
                NSDictionary *dataDic = [m_hubConfig wifiSTAInfo:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubWifiSTA];
                break;
            }
                
            case 5:
            {
                NSDictionary *dataDic = [m_hubConfig wifiSocketInfo:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubWifiSocket];
                break;
            }
                
            case 6:
            {
                NSDictionary *dataDic = [m_hubConfig netWorkMode:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubNetWorkMode];
                break;
            }
                
            case 7:
            {
                NSDictionary *dataDic = [m_hubConfig hubRemarkInfo:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubRemark];
                break;
            }
                
            case 8:
            {
                NSDictionary *dataDic = [m_hubConfig hubIpKey:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubIpKey];
                break;
            }
                
            case 9:
            {
                NSDictionary *dataDic = [m_hubConfig hubWifiList:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubWifiList];
                break;
            }
                
            case 10:
            {
                NSDictionary *dataDic = [m_hubConfig hubWifiStatus:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubWifiStatus];
                break;
            }
            
            case 11:
            {
                NSDictionary *dataDic = [m_hubConfig hub4GAPNStatus:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHub4GAPN];
                break;
            }
                
            case 12:
            {
                NSDictionary *dataDic = [m_hubConfig hubSystemStatus:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubSystemStatus];
                break;
            }
                
            case 13:
            {
                NSDictionary *dataDic = [m_hubConfig hubIPV4Info:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalHubIPV4];
                break;
            }
                
            case 14:
            {
                NSDictionary *dataDic = [m_hubConfig hubSetLoraResult:hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalSetLora];
                break;
            }
                
            case 15:
            {
                NSDictionary *dataDic = [m_hubConfig hubDiagnosisLoraResult:(NSArray *)hexArray];
                [resultDic addEntriesFromDictionary:dataDic];
                [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalDiagnosisLora];
                break;
            }
                
            default:
            {
                break;
            }
        }
    }
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：bigDataResult
 * 功能描述：大数据结果
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bigDataResult:(NSDictionary *)bidDataDic
{
    [self.delegate analyticalSucceed:bidDataDic withResultNumber:FBKAnalyticalBigData];
}


/********************************************************************************
 * 方法名称：fitNameList
 * 功能描述：fit名称列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)fitNameList:(NSArray *)listArray
{
    [self.delegate analyticalSucceed:listArray withResultNumber:FBKAnalyticalFitList];
}


/********************************************************************************
 * 方法名称：fitFileData
 * 功能描述：fit文件数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)fitFileData:(NSData *)fitData
{
    [self.delegate analyticalSucceed:fitData withResultNumber:FBKAnalyticalFitData];
}


@end

