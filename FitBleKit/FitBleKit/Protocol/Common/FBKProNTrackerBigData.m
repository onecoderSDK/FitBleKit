/********************************************************************************
 * 文件名称：FBKProNTrackerBigData.m
 * 内容摘要：新手环解析大数据
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import "FBKProNTrackerBigData.h"
#import "FBKDateFormat.h"

#define   FBKBIGDATA_STEPSMIN    1   // 1分钟运动细分数据
#define   FBKBIGDATA_HR10MIN     2   // 10分钟心率数据
#define   FBKBIGDATA_BIKE        3   // 速度与踏频
#define   FBKBIGDATA_TRAIN       4   // 训练模式及训练时间段
#define   FBKBIGDATA_SLEEP       5   // 睡眠数据
#define   FBKBIGDATA_EVERYDAY    6   // 每天总数据
#define   FBKBIGDATA_HR5S        7   // 5秒心率数据
#define   FBKBIGDATA_HR2S        8   // 2秒心率数据
#define   FBKBIGDATA_STEPS15MIN  9   // 15分钟运动细分数据
#define   FBKBIGDATA_KETTLEBELL  10  // 壶铃数据
#define   FBKBIGDATA_BOXING      11  // 拳击数据
#define   FBKBIGDATA_HISEND      255 // 历史数据结束

@implementation FBKProNTrackerBigData
{
    NSMutableArray *m_steps1MinArray;  // 1分钟运动细分数据
    NSMutableArray *m_steps15MinArray; // 15分钟运动细分数据
    NSMutableArray *m_sleepArray;      // 睡眠数据
    NSMutableArray *m_HR10MinArray;    // 10分钟心率数据
    NSMutableArray *m_HR5SArray;       // 5秒心率数据
    NSMutableArray *m_HR2SArray;       // 2秒心率数据
    NSMutableArray *m_speedCycArray;   // 速度与踏频
    NSMutableArray *m_trainArray;      // 训练模式及训练时间段
    NSMutableArray *m_totalArray;      // 每天总数据
    NSMutableArray *m_weightArray;     // 体重数据
    NSMutableArray *m_fitNameArray;    // fit文件名称列表
    NSMutableData  *m_fitData;         // fit文件数据
    NSMutableArray *m_kettleBellArray; // 壶铃数据
    NSMutableArray *m_boxingArray;     // 拳击数据
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
    
    m_steps1MinArray  = [[NSMutableArray alloc] init];
    m_steps15MinArray = [[NSMutableArray alloc] init];
    m_sleepArray      = [[NSMutableArray alloc] init];
    m_HR10MinArray    = [[NSMutableArray alloc] init];
    m_HR5SArray       = [[NSMutableArray alloc] init];
    m_HR2SArray       = [[NSMutableArray alloc] init];
    m_speedCycArray   = [[NSMutableArray alloc] init];
    m_trainArray      = [[NSMutableArray alloc] init];
    m_totalArray      = [[NSMutableArray alloc] init];
    m_weightArray     = [[NSMutableArray alloc] init];
    m_fitNameArray    = [[NSMutableArray alloc] init];
    m_fitData         = [[NSMutableData  alloc] init];
    m_kettleBellArray = [[NSMutableArray alloc] init];
    m_boxingArray     = [[NSMutableArray alloc] init];
    
    return self;
}


#pragma mark - **************************** 码表方法 *****************************
/********************************************************************************
 * 方法名称：analyticalFitFileData
 * 功能描述：解析fit文件
 * 输入参数：hexArray - 元数据
 * 返回数据：
 ********************************************************************************/
- (void)analyticalFitFileData:(NSArray *)hexArray
{
    int keyMark  = [[hexArray objectAtIndex:0] intValue];
    int valueLength = (int)hexArray.count;
    switch (keyMark)
    {
        #pragma mark - **************************** 文件列表 *****************************
        case 1:
        {
            int offSet = 0;
            
            while(offSet < valueLength-1)
            {
                if (valueLength - offSet >= 5)
                {
                    int fileNameLength   = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    long int file1 = [[hexArray objectAtIndex:offSet+1] intValue];
                    long int file2 = [[hexArray objectAtIndex:offSet+2] intValue];
                    long int file3 = [[hexArray objectAtIndex:offSet+3] intValue];
                    long int file4 = [[hexArray objectAtIndex:offSet+4] intValue];
                    long int file  = file4 + (file3<<8) + (file2<<16) + (file1<<24);
                    offSet = offSet + 4;
                    
                    NSMutableString *fileName = [[NSMutableString alloc] init];
                    for (int i = 0; i < fileNameLength; i++)
                    {
                        int value = [[hexArray objectAtIndex:offSet+1+i] intValue];
                        [fileName appendString:[NSString stringWithFormat:@"%c",value]];
                    }
                    offSet = offSet + fileNameLength;
                    
                    // 获取当前天的时间
                    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                    [resultDic setObject:[NSString stringWithFormat:@"%i",fileNameLength] forKey:@"nameLength"];
                    [resultDic setObject:[NSString stringWithFormat:@"%li",file] forKey:@"fileByte"];
                    [resultDic setObject:fileName   forKey:@"fileName"];
                    [m_fitNameArray addObject:resultDic];
                    
                    [self.delegate fitNameList:m_fitNameArray];
                }
            }
            
            break;
        }
            
        #pragma mark - **************************** 文件内容 *****************************
        case 2:
        {
            int offSet = 0;
            
            if (valueLength - offSet > 0)
            {
                int fileNameLength   = [[hexArray objectAtIndex:offSet+1] intValue];
                offSet = offSet + 1;
                
                for (int i = 0; i < fileNameLength; i++)
                {
                    int value = [[hexArray objectAtIndex:offSet+1+i] intValue];
                    NSData *myData = [NSData dataWithBytes:&value length:1];
                    [m_fitData appendData:myData];
                }
                offSet = offSet + fileNameLength;
            }
            
            break;
        }
            
        #pragma mark - **************************** 文件结束 *****************************
        case 255:
        {
            if (m_fitNameArray.count > 0)
            {
                [self.delegate fitNameList:m_fitNameArray];
            }
            
            if (m_fitData.length > 0)
            {
                [self.delegate fitFileData:m_fitData];
            }
            
            [self clearSysData];
            
            break;
        }
            
        default:
        {
            break;
        }
    }
}


#pragma mark - **************************** 体重方法 *****************************
/********************************************************************************
 * 方法名称：AnalyticalWeightData
 * 功能描述：解析体重大数据
 * 输入参数：hexArray - 元数据
 * 返回数据：
 ********************************************************************************/
- (void)analyticalWeightBigData:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
        int valueLength = (int)hexArray.count;
        
        int offSet = 0;
        
        while(offSet < valueLength-1)
        {
            if (valueLength - offSet >= 13)
            {
                NSMutableDictionary *weightDic = [[NSMutableDictionary alloc] init];
                int length  = [[hexArray objectAtIndex:offSet+1] intValue];
                [weightDic setObject:[NSString stringWithFormat:@"%i",length] forKey:@"length"];
                offSet = offSet + 1;
                
                int sutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                int sutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                int sutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                int sutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                long int mySutc  = sutc4 + (sutc3<<8) + (sutc2<<16) + (long)(sutc1<<24);
                NSDate *weightTime = [NSDate dateWithTimeIntervalSince1970:mySutc-GMTNUM];
                NSString *weightDate = [myFormatter stringFromDate:weightTime];
                [weightDic setObject:weightDate forKey:@"weightTime"];
                [weightDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:weightDate]] forKey:@"timestamps"];
                offSet = offSet + 4;
                
                int weightHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                int weightLow = [[hexArray objectAtIndex:offSet+2] intValue];
                NSString *stepNum = [NSString stringWithFormat:@"%.2f",(float)(weightLow+(weightHi<<8))/100];
                [weightDic setObject:stepNum forKey:@"weight"];
                offSet = offSet + 2;
                
                int ohmHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                int ohmMin = [[hexArray objectAtIndex:offSet+2] intValue];
                NSString *ohmStr = [NSString stringWithFormat:@"%.1f",(float)(ohmMin+(ohmHi<<8))/10];
                [weightDic setObject:ohmStr forKey:@"ohm"];
                offSet = offSet + 2;
                
                int ohmSeHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                int ohmSeMid  = [[hexArray objectAtIndex:offSet+2] intValue];
                int ohmSeMin = [[hexArray objectAtIndex:offSet+3] intValue];
                NSString *ohmSeStr = [NSString stringWithFormat:@"%d",ohmSeMin+(ohmSeMid<<8)+(ohmSeHi<<16)];
                [weightDic setObject:ohmSeStr forKey:@"encryptOhm"];
                offSet = offSet + 3;
                
                int deviceType  = [[hexArray objectAtIndex:offSet+1] intValue];
                NSString *typeString = [NSString stringWithFormat:@"%d",deviceType];
                [weightDic setObject:typeString forKey:@"deviceType"];
                offSet = offSet + 1;
                
                [self.delegate bigDataResult:weightDic];
            }
        }
    }
}


#pragma mark - **************************** 手环方法 *****************************
/********************************************************************************
 * 方法名称：AnalyticalBigData
 * 功能描述：解析大数据
 * 输入参数：hexArray - 元数据
 * 返回数据：
 ********************************************************************************/
- (void)analyticalBigData:(NSArray *)hexArray
{
    if (hexArray.count > 0)
    {
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
        int keyMark  = [[hexArray objectAtIndex:0] intValue];
        int valueLength = (int)hexArray.count;
        
        switch (keyMark)
        {
            #pragma mark - **************************** 步行1分钟数据 *****************************
            case FBKBIGDATA_STEPSMIN:
            {
                if (self.bigDataDeviceType == BleDeviceKettleBell)
                {
                    int offSet = 0;
                    
                    while(offSet < valueLength-1)
                    {
                        if (valueLength - offSet >= 24)
                        {
                            int sutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                            int sutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                            int sutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                            int sutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                            int mySutc  = sutc4 + (sutc3<<8) + (sutc2<<16) + (sutc1<<24);
                            NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:mySutc-GMTNUM];
                            NSString *startDate = [myFormatter stringFromDate:startTime];
                            offSet = offSet + 4;
                            
                            int eutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                            int eutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                            int eutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                            int eutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                            int myEutc  = eutc4 + (eutc3<<8) + (eutc2<<16) + (eutc1<<24);
                            NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myEutc-GMTNUM];
                            NSString *endDate = [myFormatter stringFromDate:endTime];
                            offSet = offSet + 4;
                            
                            int rest1   = [[hexArray objectAtIndex:offSet+1] intValue];
                            int rest2   = [[hexArray objectAtIndex:offSet+2] intValue];
                            int rest3   = [[hexArray objectAtIndex:offSet+3] intValue];
                            int restTime  = rest3 + (rest2<<8) + (rest1<<16);
                            offSet = offSet + 3;
                            
                            int weightGrade = [[hexArray objectAtIndex:offSet+1] intValue];
                            int userNumber  = [[hexArray objectAtIndex:offSet+2] intValue];
                            int weightUnit  = [[hexArray objectAtIndex:offSet+3] intValue];
                            offSet = offSet + 3;
                            
                            int other1 = [[hexArray objectAtIndex:offSet+1] intValue];
                            int other2 = [[hexArray objectAtIndex:offSet+2] intValue];
                            int otherType = other2 + (other1<<8);
                            offSet = offSet + 2;
                            
                            int swing1 = [[hexArray objectAtIndex:offSet+1] intValue];
                            int swing2 = [[hexArray objectAtIndex:offSet+2] intValue];
                            int atlasSwing = swing2 + (swing1<<8);
                            offSet = offSet + 2;
                            
                            int pullOver1 = [[hexArray objectAtIndex:offSet+1] intValue];
                            int pullOver2 = [[hexArray objectAtIndex:offSet+2] intValue];
                            int pullOver  = pullOver2 + (pullOver1<<8);
                            offSet = offSet + 2;
                            
                            int highPull1 = [[hexArray objectAtIndex:offSet+1] intValue];
                            int highPull2 = [[hexArray objectAtIndex:offSet+2] intValue];
                            int highPull  = highPull2 + (highPull1<<8);
                            offSet = offSet + 2;
                            
                            int extension1 = [[hexArray objectAtIndex:offSet+1] intValue];
                            int extension2 = [[hexArray objectAtIndex:offSet+2] intValue];
                            int extension  = extension2 + (extension1<<8);
                            offSet = offSet + 2;
                            
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic setObject:startDate forKey:@"startTime"];
                            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:startDate]] forKey:@"startTimestamps"];
                            [resultDic setObject:endDate   forKey:@"endTime"];
                            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:endDate]] forKey:@"endTimestamps"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",restTime] forKey:@"restTime"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",weightGrade] forKey:@"weightGrade"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",userNumber] forKey:@"userNumber"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",weightUnit] forKey:@"weightUnit"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",otherType] forKey:@"otherType"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",atlasSwing] forKey:@"atlasSwing"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",pullOver] forKey:@"pullOver"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",highPull] forKey:@"highPull"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",extension] forKey:@"extension"];
                            [m_kettleBellArray addObject:resultDic];
                        }
                    }
                }
                else
                {
                    int offSet = 0;
                    
                    while(offSet < valueLength-1)
                    {
                        int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                        offSet = offSet + 4;
                        
                        for(int i = 0; i < dataLength/2; i++)
                        {
                            NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                            NSString *myDateString = [myFormatter stringFromDate:dateTime];
                            NSString *tipTime = [NSString stringWithFormat:@"%@00:00",[myDateString substringToIndex:14]];
                            int oneMinStep = [[hexArray objectAtIndex:offSet+1] intValue];
                            int oneMinKcal = [[hexArray objectAtIndex:offSet+2] intValue];
                            offSet = offSet + 2;
                            
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic setObject:myDateString forKey:@"createTime"];
                            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                            [resultDic setObject:tipTime forKey:@"tipTime"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",oneMinStep] forKey:@"walkCounts"];
                            [resultDic setObject:[NSString stringWithFormat:@"%i",oneMinKcal/10] forKey:@"calorie"];
                            [m_steps1MinArray addObject:resultDic];
                            
                            myUtc = myUtc + 60;
                            
                            #ifdef FBKLOGNTRACKERINFO
                            NSLog(@"Steps one minute time is %@ - %i - %i",myDateString,oneMinStep,oneMinKcal);
                            #endif
                        }
                    }
                }

                break;
            }
                
            #pragma mark - **************************** 心率10分钟数据 *****************************
            case FBKBIGDATA_HR10MIN:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                    offSet = offSet + 4;
                    
                    for(int i = 0; i < dataLength; i++)
                    {
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        int heartRateNum = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"sportTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",heartRateNum] forKey:@"heartRateNum"];
                        [m_HR10MinArray addObject:resultDic];
                        
                        myUtc = myUtc + 600;
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"heart rate 10 minutes data is %@ - %i",myDateString,heartRateNum);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 踏频数据 *****************************
            case FBKBIGDATA_BIKE:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    if (valueLength - offSet >= 22)
                    {
                        int sutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int sutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int sutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int sutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int mySutc  = sutc4 + (sutc3<<8) + (sutc2<<16) + (sutc1<<24);
                        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:mySutc-GMTNUM];
                        NSString *startDate = [myFormatter stringFromDate:startTime];
                        offSet = offSet + 4;
                        
                        int eutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int eutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int eutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int eutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int myEutc  = eutc4 + (eutc3<<8) + (eutc2<<16) + (eutc1<<24);
                        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myEutc-GMTNUM];
                        NSString *endDate = [myFormatter stringFromDate:endTime];
                        offSet = offSet + 4;
                        
                        int maxCadence = [[hexArray objectAtIndex:offSet+1] intValue];
                        int avgCadence = [[hexArray objectAtIndex:offSet+2] intValue];
                        offSet = offSet + 2;
                        
                        int maxSpeedHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int maxSpeedLow = [[hexArray objectAtIndex:offSet+2] intValue];
                        int maxSpeed    = maxSpeedLow + (maxSpeedHi<<8);
                        offSet = offSet + 2;
                        
                        int avgSpeedHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int avgSpeedLow = [[hexArray objectAtIndex:offSet+2] intValue];
                        int avgSpeed    = avgSpeedLow + (avgSpeedHi<<8);
                        offSet = offSet + 2;
                        
                        int wheel1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int wheel2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int wheel3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int wheel4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int wheelNum = wheel4 + (wheel3<<8) + (wheel2<<16) + (wheel1<<24);
                        offSet = offSet + 4;
                        
                        int cadence1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int cadence2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int cadence3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int cadence4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int cadenceNum = cadence4 + (cadence3<<8) + (cadence2<<16) + (cadence1<<24);
                        offSet = offSet + 4;
                        
                        // 获取当前天的时间
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:startDate forKey:@"startTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:startDate]] forKey:@"startTimestamps"];
                        [resultDic setObject:endDate   forKey:@"endTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:endDate]] forKey:@"endTimestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",maxCadence] forKey:@"hightestPace"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",avgCadence] forKey:@"avgPace"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)maxSpeed/10] forKey:@"highestSpeed"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)avgSpeed/10] forKey:@"avgSpeed"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",wheelNum] forKey:@"wheelNum"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",cadenceNum] forKey:@"cadenceNum"];
                        [m_speedCycArray addObject:resultDic];
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"bike date is %@",resultDic);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 训练数据 *****************************
            case FBKBIGDATA_TRAIN:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    if (valueLength - offSet >= 9)
                    {
                        int trainType   = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        int sutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int sutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int sutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int sutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int mySutc  = sutc4 + (sutc3<<8) + (sutc2<<16) + (sutc1<<24);
                        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:mySutc-GMTNUM];
                        NSString *startDate = [myFormatter stringFromDate:startTime];
                        offSet = offSet + 4;
                        
                        int eutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int eutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int eutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int eutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int myEutc  = eutc4 + (eutc3<<8) + (eutc2<<16) + (eutc1<<24);
                        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myEutc-GMTNUM];
                        NSString *endDate = [myFormatter stringFromDate:endTime];
                        offSet = offSet + 4;
                        
                        // 获取当前天的时间
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",trainType] forKey:@"isRun"];
                        [resultDic setObject:startDate forKey:@"startTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:startDate]] forKey:@"startTimestamps"];
                        [resultDic setObject:endDate   forKey:@"endTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:endDate]] forKey:@"endTimestamps"];
                        [m_trainArray addObject:resultDic];
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"train date is %@ - %@ - %i",startDate,endDate,trainType);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 睡眠数据 *****************************
            case FBKBIGDATA_SLEEP:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                    offSet = offSet + 4;
                    
                    for(int i = 0; i < dataLength; i++)
                    {
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        int moveCounts = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"createTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",moveCounts] forKey:@"moveCounts"];
                        [m_sleepArray addObject:resultDic];
                        
                        myUtc = myUtc + 300;
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"sleep five minute date is %@ - %i",myDateString,moveCounts);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 每天数据 *****************************
            case FBKBIGDATA_EVERYDAY:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    if (valueLength - offSet >= 12)
                    {
                        int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24);
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc-GMTNUM];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        offSet = offSet + 4;
                        
                        int step1 = [[hexArray objectAtIndex:offSet+1] intValue];
                        int step2 = [[hexArray objectAtIndex:offSet+2] intValue];
                        int step3 = [[hexArray objectAtIndex:offSet+3] intValue];
                        int step4 = [[hexArray objectAtIndex:offSet+4] intValue];
                        int stepNum = step4 + (step3<<8) + (step2<<16) + (step1<<24);
                        offSet = offSet + 4;
                        
                        int kcal1 = [[hexArray objectAtIndex:offSet+1] intValue];
                        int kcal2 = [[hexArray objectAtIndex:offSet+2] intValue];
                        int kcal3 = [[hexArray objectAtIndex:offSet+3] intValue];
                        int kcal4 = [[hexArray objectAtIndex:offSet+4] intValue];
                        int stepKcal = kcal4 + (kcal3<<8) + (kcal2<<16) + (kcal1<<24);
                        offSet = offSet + 4;
                        
                        // 获取当前天的时间
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"locTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",stepNum] forKey:@"stepNum"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",stepKcal/10] forKey:@"stepKcal"];
                        [m_totalArray addObject:resultDic];
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"one day total info is %@ - %i - %i",myDateString,stepNum,stepKcal/10);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 心率5秒数据 *****************************
            case FBKBIGDATA_HR5S:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                    offSet = offSet + 4;
                    
                    for(int i = 0; i < dataLength; i++)
                    {
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        int heartRateNum = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"sportTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",heartRateNum] forKey:@"heartRateNum"];
                        [m_HR5SArray addObject:resultDic];
                        
                        myUtc = myUtc + 5;
                    }
                }
                
                break;
            }
                
                
            #pragma mark - **************************** 心率2秒数据 *****************************
            case FBKBIGDATA_HR2S:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                    offSet = offSet + 4;
                    
                    for(int i = 0; i < dataLength; i++)
                    {
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        int heartRateNum = [[hexArray objectAtIndex:offSet+1] intValue];
                        offSet = offSet + 1;
                        
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"sportTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",heartRateNum] forKey:@"heartRateNum"];
                        [m_HR2SArray addObject:resultDic];
                        
                        myUtc = myUtc + 2;
                    }
                }
                
                break;
            }
                
                
            #pragma mark - **************************** 步行15分钟数据 *****************************
            case FBKBIGDATA_STEPS15MIN:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int dataLength = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24) - GMTNUM;
                    offSet = offSet + 4;
                    
                    int timeCount = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    for(int i = 0; i < dataLength/2; i++)
                    {
                        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:myUtc];
                        NSString *myDateString = [myFormatter stringFromDate:dateTime];
                        int hiStep  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int lowStep = [[hexArray objectAtIndex:offSet+2] intValue];
                        int mySteps = lowStep + (hiStep<<8);
                        offSet = offSet + 2;
                        
                        int spendCount = 15;
                        if (i == dataLength/2-1)
                        {
                            spendCount = timeCount;
                        }
                        
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic setObject:myDateString forKey:@"createTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",spendCount] forKey:@"spendTime"];
                        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateString]] forKey:@"timestamps"];
                        [resultDic setObject:[NSString stringWithFormat:@"%i",mySteps] forKey:@"walkCounts"];
                        [m_steps15MinArray addObject:resultDic];
                        
                        myUtc = myUtc + 900;
                        
                        #ifdef FBKLOGNTRACKERINFO
                        NSLog(@"Steps 15 minute time is %@ - %i",myDateString,mySteps);
                        #endif
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 壶铃数据 *****************************
            case FBKBIGDATA_KETTLEBELL:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int weightGrade = [[hexArray objectAtIndex:offSet+1] intValue];
                    int userNumber  = [[hexArray objectAtIndex:offSet+2] intValue];
                    int sportNumber = [[hexArray objectAtIndex:offSet+3] intValue];
                    offSet = offSet + 3;
                    
                    int sutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int sutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int sutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int sutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int mySutc  = sutc4 + (sutc3<<8) + (sutc2<<16) + (sutc1<<24);
                    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:mySutc-GMTNUM];
                    NSString *startDate = [myFormatter stringFromDate:startTime];
                    offSet = offSet + 4;
                    
                    int eutc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                    int eutc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                    int eutc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                    int eutc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                    int myEutc  = eutc4 + (eutc3<<8) + (eutc2<<16) + (eutc1<<24);
                    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myEutc-GMTNUM];
                    NSString *endDate = [myFormatter stringFromDate:endTime];
                    offSet = offSet + 4;
                    
                    NSMutableArray *sportArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < sportNumber; i++)
                    {
                        int typeMark   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int sportTime1 = [[hexArray objectAtIndex:offSet+2] intValue];
                        int sportTime2 = [[hexArray objectAtIndex:offSet+3] intValue];
                        int sportTime  = sportTime2 + (sportTime1<<8);
                        offSet = offSet + 3;
                        
                        NSMutableDictionary *sportDic = [[NSMutableDictionary alloc] init];
                        [sportDic setObject:[NSString stringWithFormat:@"%i",typeMark] forKey:@"sportType"];
                        [sportDic setObject:[NSString stringWithFormat:@"%i",sportTime] forKey:@"sportTime"];
                        [sportArray addObject:sportDic];
                    }
                    
                    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                    [resultDic setObject:[NSString stringWithFormat:@"%i",userNumber] forKey:@"userNumber"];
                    [resultDic setObject:[NSString stringWithFormat:@"%i",weightGrade] forKey:@"weightGrade"];
                    [resultDic setObject:[NSString stringWithFormat:@"%i",sportNumber] forKey:@"sportNumber"];
                    [resultDic setObject:startDate forKey:@"startTime"];
                    [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:startDate]] forKey:@"startTimestamps"];
                    [resultDic setObject:endDate   forKey:@"endTime"];
                    [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:endDate]] forKey:@"endTimestamps"];
                    [resultDic setObject:sportArray forKey:@"sportList"];
                    [m_kettleBellArray addObject:resultDic];
                }
                
                break;
            }
                
                
            #pragma mark - **************************** 拳击数据 *****************************
            case FBKBIGDATA_BOXING:
            {
                int offSet = 0;
                
                while(offSet < valueLength-1)
                {
                    int boxingNumber = [[hexArray objectAtIndex:offSet+1] intValue];
                    offSet = offSet + 1;
                    
                    for (int i = 0; i < boxingNumber; i++) {
                        NSMutableDictionary *fistDic = [[NSMutableDictionary alloc] init];
                        
                        int fistType = [[hexArray objectAtIndex:offSet+1] intValue];
                        NSString *fistTypeString = [NSString stringWithFormat:@"%d",fistType];
                        [fistDic setObject:fistTypeString forKey:@"fistType"];
                        offSet = offSet + 1;
                        
                        int fistOutHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int fistOutlow = [[hexArray objectAtIndex:offSet+2] intValue];
                        NSString *fistOutTime = [NSString stringWithFormat:@"%d",fistOutlow+(fistOutHi<<8)];
                        [fistDic setObject:fistOutTime forKey:@"fistOutTime"];
                        offSet = offSet + 2;
                        
                        int fistInHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int fistInlow = [[hexArray objectAtIndex:offSet+2] intValue];
                        NSString *fistInTime = [NSString stringWithFormat:@"%d",fistInlow+(fistInHi<<8)];
                        [fistDic setObject:fistInTime forKey:@"fistInTime"];
                        offSet = offSet + 2;
                        
                        int fistPowerHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int fistPowerLow = [[hexArray objectAtIndex:offSet+2] intValue];
                        NSString *fistPower = [NSString stringWithFormat:@"%.2f",(double)(fistPowerLow+(fistPowerHi<<8))/100];
                        [fistDic setObject:fistPower forKey:@"fistPower"];
                        offSet = offSet + 2;
                        
                        int fistSpeedHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int fistSpeedMin = [[hexArray objectAtIndex:offSet+2] intValue];
                        int fistSpeedLow = [[hexArray objectAtIndex:offSet+3] intValue];
                        NSString *fistSpeed = [NSString stringWithFormat:@"%.3f",(double)(fistSpeedLow+(fistSpeedMin<<8)+(fistSpeedHi<<16))/1000];
                        [fistDic setObject:fistSpeed forKey:@"fistSpeed"];
                        offSet = offSet + 3;
                        
                        int fistDisHi  = [[hexArray objectAtIndex:offSet+1] intValue];
                        int fistDisMin = [[hexArray objectAtIndex:offSet+2] intValue];
                        int fistDisLow = [[hexArray objectAtIndex:offSet+3] intValue];
                        NSString *fistDistance = [NSString stringWithFormat:@"%.3f",(double)(fistDisLow+(fistDisMin<<8)+(fistDisHi<<16))/1000];
                        [fistDic setObject:fistDistance forKey:@"fistDistance"];
                        offSet = offSet + 3;
                        
                        int utc1   = [[hexArray objectAtIndex:offSet+1] intValue];
                        int utc2   = [[hexArray objectAtIndex:offSet+2] intValue];
                        int utc3   = [[hexArray objectAtIndex:offSet+3] intValue];
                        int utc4   = [[hexArray objectAtIndex:offSet+4] intValue];
                        int utc5   = [[hexArray objectAtIndex:offSet+5] intValue];
                        int utc6   = [[hexArray objectAtIndex:offSet+6] intValue];
                        int myUtc  = utc4 + (utc3<<8) + (utc2<<16) + (utc1<<24);
                        int millisecond = utc6 + (utc5<<8);
                        int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
                        
                        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
                        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                        NSDate *beforeTime = [NSDate dateWithTimeIntervalSince1970:myUtc-GMTNUM];
                        NSString *fistDate = [myFormatter stringFromDate:beforeTime];
                        NSString *dateString = [NSString stringWithFormat:@"%@ %i",fistDate,millisecond];
                        [fistDic setObject:dateString forKey:@"fistDate"];
                        offSet = offSet + 6;
                        
                        [m_boxingArray addObject:fistDic];
                    }
                }
                
                break;
            }
                
            #pragma mark - **************************** 数据结束 *****************************
            case FBKBIGDATA_HISEND:
            {
                [self bleError];
                break;
            }
                
            default:
            {
                break;
            }
        }
    }
}


/********************************************************************************
 * 方法名称：bleError
 * 功能描述：数据中断
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleError
{
    NSMutableDictionary *detailDataDic = [[NSMutableDictionary alloc] init];
    
    if (m_totalArray.count > 0)
    {
        NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:m_totalArray];
        [detailDataDic setObject:totalArray forKey:@"stepsTotleData"];
    }
    
    if (m_steps1MinArray.count > 0)
    {
        NSMutableArray *steps1MinArray = [[NSMutableArray alloc] initWithArray:m_steps1MinArray];
        [detailDataDic setObject:steps1MinArray forKey:@"stepsData"];
    }
    
    if (m_steps15MinArray.count > 0)
    {
        NSMutableArray *steps15MinArray = [[NSMutableArray alloc] initWithArray:m_steps15MinArray];
        [detailDataDic setObject:steps15MinArray forKey:@"steps15Data"];
    }
    
    if (m_sleepArray.count > 0)
    {
        NSMutableArray *sleepArray = [[NSMutableArray alloc] initWithArray:m_sleepArray];
        [detailDataDic setObject:sleepArray forKey:@"sleepData"];
    }
    
    if (m_HR10MinArray.count > 0)
    {
        NSMutableArray *HR10MinArray = [[NSMutableArray alloc] initWithArray:m_HR10MinArray];
        [detailDataDic setObject:HR10MinArray forKey:@"heartRateData"];
    }
    
    if (m_HR5SArray.count > 0)
    {
        NSMutableArray *HR5SArray = [[NSMutableArray alloc] initWithArray:m_HR5SArray];
        [detailDataDic setObject:HR5SArray forKey:@"heartRate5SData"];
    }
    
    if (m_HR2SArray.count > 0)
    {
        NSMutableArray *HR2SArray = [[NSMutableArray alloc] initWithArray:m_HR2SArray];
        [detailDataDic setObject:HR2SArray forKey:@"heartRate2SData"];
    }
    
    if (m_speedCycArray.count > 0)
    {
        NSMutableArray *speedCycArray = [[NSMutableArray alloc] initWithArray:m_speedCycArray];
        [detailDataDic setObject:speedCycArray forKey:@"rideData"];
    }
    
    if (m_trainArray.count > 0)
    {
        NSMutableArray *trainArray = [[NSMutableArray alloc] initWithArray:m_trainArray];
        [detailDataDic setObject:trainArray forKey:@"runData"];
    }
    
    if (m_kettleBellArray.count > 0)
    {
        NSMutableArray *kettleBellArray = [[NSMutableArray alloc] initWithArray:m_kettleBellArray];
        [detailDataDic setObject:kettleBellArray forKey:@"kettleBellData"];
    }
    
    if (m_boxingArray.count > 0)
    {
        NSMutableArray *boxingArray = [[NSMutableArray alloc] initWithArray:m_boxingArray];
        [detailDataDic setObject:boxingArray forKey:@"boxingData"];
    }
    
    [self.delegate bigDataResult:detailDataDic];
    [self clearSysData];
}


/********************************************************************************
 * 方法名称：clearSysData
 * 功能描述：清除大数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)clearSysData
{
    m_fitData = [[NSMutableData alloc] init];
    [m_totalArray      removeAllObjects];
    [m_steps1MinArray  removeAllObjects];
    [m_steps15MinArray removeAllObjects];
    [m_sleepArray      removeAllObjects];
    [m_HR10MinArray    removeAllObjects];
    [m_HR5SArray       removeAllObjects];
    [m_HR2SArray       removeAllObjects];
    [m_speedCycArray   removeAllObjects];
    [m_trainArray      removeAllObjects];
    [m_fitNameArray    removeAllObjects];
    [m_kettleBellArray removeAllObjects];
    [m_boxingArray     removeAllObjects];
}


@end

