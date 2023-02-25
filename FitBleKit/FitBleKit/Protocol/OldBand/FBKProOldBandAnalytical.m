/********************************************************************************
 * 文件名称：FBKProOldBandAnalytical.m
 * 内容摘要：老手环数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import "FBKProOldBandAnalytical.h"
#import "FBKDateFormat.h"

@implementation FBKProOldBandAnalytical
{
    int m_checkLeiJiNum;
    NSMutableArray      *m_stepArray;
    NSMutableDictionary *m_stepDic;
    NSMutableDictionary *m_stepAllDic;
    NSMutableArray      *m_sleepArray;
    NSMutableDictionary *m_sleepDic;
    NSMutableArray      *m_xinLvArray;
    NSMutableDictionary *m_xinLvDic;
    NSMutableArray      *m_speedArray;
    NSMutableDictionary *m_speedDic;
    NSMutableArray      *m_runArray;
    NSMutableArray      *m_RRArray;
    NSMutableDictionary *m_RRDic;
    NSMutableDictionary *m_stepLimitDic;
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
    
    m_checkLeiJiNum = 0;
    m_stepArray  = [[NSMutableArray alloc] init];
    m_stepDic    = [[NSMutableDictionary alloc] init];
    m_stepAllDic = [[NSMutableDictionary alloc] init];
    m_sleepArray = [[NSMutableArray alloc] init];
    m_sleepDic   = [[NSMutableDictionary alloc] init];
    m_xinLvArray = [[NSMutableArray alloc] init];
    m_xinLvDic   = [[NSMutableDictionary alloc] init];
    m_speedArray = [[NSMutableArray alloc] init];
    m_speedDic   = [[NSMutableDictionary alloc] init];
    m_runArray   = [[NSMutableArray alloc] init];
    m_RRArray = [[NSMutableArray alloc] init];
    m_RRDic   = [[NSMutableDictionary alloc] init];
    m_stepLimitDic = [[NSMutableDictionary alloc] init];
    
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
    NSArray *totleArray = [NSArray arrayWithObjects:m_stepAllDic, nil];
    NSArray *stepArray  = [self getStepResultData:m_stepArray];
    NSArray *sleepArray = [self getSleepResultData:m_sleepArray];
    NSArray *hrArray    = [self getXinLvResultData:m_xinLvArray];
    NSArray *rrArray    = [self getRRResultData:m_RRArray];
    m_speedArray = [[NSMutableArray alloc] initWithArray:[self cutSameMember:m_speedArray]];
    m_runArray = [[NSMutableArray alloc] initWithArray:[self cutSameMember:m_runArray]];
    
    NSMutableDictionary *handAllDic = [[NSMutableDictionary alloc] init];
    
    if (totleArray.count > 0 && m_stepAllDic.allKeys.count > 0) {
        [handAllDic setObject:totleArray forKey:@"stepsTotleData"];
    }

    if (stepArray.count > 0) {
        [handAllDic setObject:stepArray forKey:@"stepsData"];
    }
    
    if (sleepArray.count > 0) {
        [handAllDic setObject:sleepArray forKey:@"sleepData"];
    }
    
    if (hrArray.count > 0) {
        [handAllDic setObject:hrArray forKey:@"heartRateData"];
    }
    
    if (rrArray.count > 0) {
        [handAllDic setObject:rrArray forKey:@"RRIntervalData"];
    }
    
    if (m_speedArray.count > 0) {
        [handAllDic setObject:m_speedArray forKey:@"rideData"];
    }
    
    if (m_runArray.count > 0) {
        [handAllDic setObject:m_runArray forKey:@"runData"];
    }
    
    [self.delegate analyticalSucceed:handAllDic withResultNumber:6];
    
    m_checkLeiJiNum = 0;
    [m_stepArray  removeAllObjects];
    [m_stepDic  removeAllObjects];
    [m_stepAllDic  removeAllObjects];
    [m_sleepArray  removeAllObjects];
    [m_sleepDic  removeAllObjects];
    [m_xinLvArray  removeAllObjects];
    [m_xinLvDic  removeAllObjects];
    [m_speedArray  removeAllObjects];
    [m_speedDic  removeAllObjects];
    [m_runArray  removeAllObjects];
    [m_RRArray removeAllObjects];
    [m_RRDic removeAllObjects];
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙回复的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBlueData:(NSString *)hexString
{
    if (hexString.length < 4)
    {
        return;
    }
    
    int markNum = [[[hexString substringFromIndex:1] substringToIndex:1] intValue];
    
    if ([[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"a"] || [[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"A"])
    {
        markNum = 10;
    }
    else if ([[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"b"] || [[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"B"])
    {
        markNum = 11;
    }
    else if ([[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"c"] || [[[hexString substringFromIndex:1] substringToIndex:1] isEqualToString:@"C"])
    {
        markNum = 12;
    }
    
    int markLongNum = [[[hexString substringFromIndex:3] substringToIndex:1] intValue];
    NSString *writeStr = [hexString substringToIndex:2];
    NSString *writeNum = [self getKeyData:writeStr andMark:@"0"];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    int j=0;
    Byte bytes[20];
    
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch; //// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch; ///将转化后的数放入Byte数组里
        j++;
    }
    
    int byteLong = (int)hexString.length/2;
    int beginNum = 0;
    int endNum  = bytes[byteLong-1]&0xFF;
    for (int i = 0; i < byteLong-1; i++)
    {
        int test = bytes[i]&0xFF;
        beginNum = beginNum+test;
    }
    
    beginNum = beginNum%256;
    
    if (endNum != beginNum)
    {
        NSLog(@"*****************************检验和不一致*****************************");
        return;
    }
    
    if (markNum == 1)
    {
        int c7 = bytes[7]&0xFF;
        NSString *byte2 = [NSString stringWithFormat:@"%d",c7];
        [resultDic setObject:byte2 forKey:@"byte2"];
        
        int c8 = bytes[8]&0xFF;
        NSString *byte3 = [NSString stringWithFormat:@"%d",c8];
        [resultDic setObject:byte3 forKey:@"byte3"];
        
        int c9 = bytes[9]&0xFF;
        NSString *byte4 = [NSString stringWithFormat:@"%d",c9];
        [resultDic setObject:byte4 forKey:@"byte4"];
        
        int c10 = bytes[10]&0xFF;
        NSString *byte5 = [NSString stringWithFormat:@"%d",c10];
        [resultDic setObject:byte5 forKey:@"byte5"];
        
        int c11 = bytes[11]&0xFF;
        NSString *byte6 = [NSString stringWithFormat:@"%d",c11];
        [resultDic setObject:byte6 forKey:@"byte6"];
        
        int c12 = bytes[12]&0xFF;
        NSString *byte7 = [NSString stringWithFormat:@"%d",c12];
        [resultDic setObject:byte7 forKey:@"byte7"];
        
        int c13 = bytes[13]&0xFF;
        NSString *byte8 = [NSString stringWithFormat:@"%d",c13];
        [resultDic setObject:byte8 forKey:@"byte8"];
        
        int c14 = bytes[14]&0xFF;
        NSString *byte9 = [NSString stringWithFormat:@"%d",c14];
        [resultDic setObject:byte9 forKey:@"byte9"];
        
        int c15 = bytes[15]&0xFF;
        NSString *byte10 = [NSString stringWithFormat:@"%d",c15];
        [resultDic setObject:byte10 forKey:@"byte10"];
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 2)
    {
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *timeMinutes = [NSString stringWithFormat:@"%d",c4+(c3<<8)+(c2<<16)+(c1<<24)];
        NSDate *handTime = [NSDate dateWithTimeIntervalSince1970:[timeMinutes longLongValue]];
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 3)
    {
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
        NSString *timeMinutes = [NSString stringWithFormat:@"%d",c4+(c3<<8)+(c2<<16)+(c1<<24)-juTime];
        NSDate *handTime = [NSDate dateWithTimeIntervalSince1970:[timeMinutes longLongValue]];
        NSString *locTime = [myFormatter stringFromDate:handTime];
        [resultDic setObject:locTime forKey:@"locTime"];
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        int c7 = bytes[7]&0xFF;
        NSString *stepNum = [NSString stringWithFormat:@"%d",c7+(c6<<8)+(c5<<16)];
        [resultDic setObject:stepNum forKey:@"stepNum"];
        
        int c8 = bytes[8]&0xFF;
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        NSString *stepDistance = [NSString stringWithFormat:@"%.1f",(float)(c10+(c9<<8)+(c8<<16))/100000];
        [resultDic setObject:stepDistance forKey:@"stepDistance"];
        
        int c11 = bytes[11]&0xFF;
        int c12 = bytes[12]&0xFF;
        int c13 = bytes[13]&0xFF;
        NSString *stepKcal = [NSString stringWithFormat:@"%.1f",(float)(c13+(c12<<8)+(c11<<16))/10];
        [resultDic setObject:stepKcal forKey:@"stepKcal"];
        
        [m_stepAllDic removeAllObjects];
        [m_stepAllDic addEntriesFromDictionary:resultDic];
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 4)
    {
        if (markLongNum == 1)
        {
            if (m_stepDic.allKeys.count > 0)
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_stepDic];
                [m_stepArray addObject:dic1];
                [m_stepDic removeAllObjects];
            }
            
            [m_stepDic setObject:hexString forKey:@"step1"];
            m_checkLeiJiNum ++;
            
        }
        else if (markLongNum == 2)
        {
            [m_stepDic setObject:hexString forKey:@"step2"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 3)
        {
            int c2 = bytes[2]&0xFF;
            
            if (m_checkLeiJiNum != c2)
            {
                m_checkLeiJiNum = 0;
                [m_stepDic removeAllObjects];
            }
            else
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_stepDic];
                
                [m_stepArray addObject:dic1];
                [m_stepDic removeAllObjects];
                m_checkLeiJiNum = 0;
            }
            
            [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
        }
    }
    else if (markNum == 5)
    {
        if (markLongNum == 1)
        {
            if (m_sleepDic.allKeys.count > 0)
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_sleepDic];
                [m_sleepArray addObject:dic1];
                [m_sleepDic removeAllObjects];
            }
            
            [m_sleepDic setObject:hexString forKey:@"sleep1"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 2)
        {
            [m_sleepDic setObject:hexString forKey:@"sleep2"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 3)
        {
            int c2 = bytes[2]&0xFF;
            
            if (m_checkLeiJiNum != c2)
            {
                m_checkLeiJiNum = 0;
                [m_sleepDic removeAllObjects];
            }
            else
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_sleepDic];
                
                [m_sleepArray addObject:dic1];
                [m_sleepDic removeAllObjects];
                m_checkLeiJiNum = 0;
            }
            
            [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
        }
    }
    else if (markNum == 6)
    {
        [self.delegate analyticalSucceed:writeNum withResultNumber:0];
        [self receiveBlueDataError];
    }
    else if (markNum == 7)
    {
        int c1 = bytes[1]&0xFF;
        NSString *byte2 = [NSString stringWithFormat:@"%d",c1];
        [resultDic setObject:byte2 forKey:@"byte2"];
        
        int c2 = bytes[2]&0xFF;
        NSString *byte3 = [NSString stringWithFormat:@"%d",c2];
        [resultDic setObject:byte3 forKey:@"byte3"];
        
        int c3 = bytes[3]&0xFF;
        NSString *byte4 = [NSString stringWithFormat:@"%d",c3];
        [resultDic setObject:byte4 forKey:@"byte4"];
        
        int c4 = bytes[4]&0xFF;
        NSString *byte5 = [NSString stringWithFormat:@"%d",c4];
        [resultDic setObject:byte5 forKey:@"byte5"];
        
        int c5 = bytes[5]&0xFF;
        NSString *byte6 = [NSString stringWithFormat:@"%d",c5];
        [resultDic setObject:byte6 forKey:@"byte6"];
        
        int c6 = bytes[6]&0xFF;
        NSString *byte7 = [NSString stringWithFormat:@"%d",c6];
        [resultDic setObject:byte7 forKey:@"byte7"];
        
        int c7 = bytes[7]&0xFF;
        NSString *byte8 = [NSString stringWithFormat:@"%d",c7];
        [resultDic setObject:byte8 forKey:@"byte8"];
        
        int c8 = bytes[8]&0xFF;
        NSString *byte9 = [NSString stringWithFormat:@"%d",c8];
        [resultDic setObject:byte9 forKey:@"byte9"];
        
        int c9 = bytes[9]&0xFF;
        NSString *byte10 = [NSString stringWithFormat:@"%d",c9];
        [resultDic setObject:byte10 forKey:@"byte10"];
        
        int c10 = bytes[10]&0xFF;
        NSString *byte11 = [NSString stringWithFormat:@"%d",c10];
        [resultDic setObject:byte11 forKey:@"byte11"];
        
        int c11 = bytes[11]&0xFF;
        NSString *byte12 = [NSString stringWithFormat:@"%d",c11];
        [resultDic setObject:byte12 forKey:@"byte12"];
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 8)
    {
        if (markLongNum == 1)
        {
            if (m_xinLvDic.allKeys.count > 0)
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_xinLvDic];
                [m_xinLvArray addObject:dic1];
                [m_xinLvDic removeAllObjects];
            }
            
            [m_xinLvDic setObject:hexString forKey:@"xinLv1"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 2)
        {
            [m_xinLvDic setObject:hexString forKey:@"xinLv2"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 3)
        {
            [m_xinLvDic setObject:hexString forKey:@"xinLv3"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 4)
        {
            [m_xinLvDic setObject:hexString forKey:@"xinLv4"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 5)
        {
            int c2 = bytes[2]&0xFF;
            
            if (m_checkLeiJiNum != c2)
            {
                m_checkLeiJiNum = 0;
                [m_xinLvDic removeAllObjects];
                return;
            }
            else
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_xinLvDic];
                [m_xinLvArray addObject:dic1];
                [m_xinLvDic removeAllObjects];
                m_checkLeiJiNum = 0;
            }
            
            [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
        }
    }
    else if (markNum == 9)
    {
        if (markLongNum == 1)
        {
            if (m_speedDic.allKeys.count > 0)
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_speedDic];
                [m_speedArray addObject:dic1];
                [m_speedDic removeAllObjects];
            }
            
            NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
            [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            int c2 = bytes[2]&0xFF;
            int c3 = bytes[3]&0xFF;
            int c4 = bytes[4]&0xFF;
            int c5 = bytes[5]&0xFF;
            int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
            NSString *beginTimeMinutes = [NSString stringWithFormat:@"%d",c5+(c4<<8)+(c3<<16)+(c2<<24)-juTime];
            NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[beginTimeMinutes longLongValue]];
            NSString *beginTimeString = [myFormatter stringFromDate:beginTime];
            [m_speedDic setObject:beginTimeString forKey:@"startTime"];
            
            
            int c6 = bytes[6]&0xFF;
            int c7 = bytes[7]&0xFF;
            int c8 = bytes[8]&0xFF;
            int c9 = bytes[9]&0xFF;
            NSString *endTimeMinutes = [NSString stringWithFormat:@"%d",c9+(c8<<8)+(c7<<16)+(c6<<24)-juTime];
            NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[endTimeMinutes longLongValue]];
            NSString *endTimeString = [myFormatter stringFromDate:endTime];
            [m_speedDic setObject:endTimeString forKey:@"endTime"];
            
            
            float time = [endTime timeIntervalSinceDate:beginTime];
            [m_speedDic setObject:[NSString stringWithFormat:@"%.2f",time/60] forKey:@"timeConsuming"];
            
            
            int c10 = bytes[10]&0xFF;
            NSString *byte10 = [NSString stringWithFormat:@"%d",c10];
            [m_speedDic setObject:byte10 forKey:@"hightestPace"];
            
            int c11 = bytes[11]&0xFF;
            NSString *byte11 = [NSString stringWithFormat:@"%d",c11];
            [m_speedDic setObject:byte11 forKey:@"avgPace"];
            [m_speedDic setObject:@"0" forKey:@"lowestPace"];
            
            int c12 = bytes[12]&0xFF;
            int c13 = bytes[13]&0xFF;
            float byte12 = (c13<<8)+c12;
            [m_speedDic setObject:[NSString stringWithFormat:@"%.2f",byte12/10] forKey:@"highestSpeed"];
            
            int c14 = bytes[14]&0xFF;
            int c15 = bytes[15]&0xFF;
            float byte14 = (c15<<8)+c14;
            [m_speedDic setObject:[NSString stringWithFormat:@"%.2f",byte14/10] forKey:@"avgSpeed"];
            [m_speedDic setObject:@"0.00" forKey:@"lowestSpeed"];
            
            [m_speedDic setObject:@"" forKey:@"runMap"];
            [m_speedDic setObject:@"" forKey:@"paragraph"];
            
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 2)
        {
            NSString *whellDiameter = @"0";
            if (resultDic != nil)
            {
                whellDiameter = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"whellDiameter"]];
            }
            
            if ([whellDiameter isEqualToString:@"0"])
            {
                whellDiameter = @"2.096";
            }
            float cycLeng = [whellDiameter floatValue];
            
            int c2 = bytes[2]&0xFF;
            int c3 = bytes[3]&0xFF;
            int c4 = bytes[4]&0xFF;
            int c5 = bytes[5]&0xFF;
            float allCiNum = c5+(c4<<8)+(c3<<16)+(c2<<24);
            float allLength = cycLeng * allCiNum /1000;
            [m_speedDic setObject:[NSString stringWithFormat:@"%.2f",allLength] forKey:@"distance"];
            
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 3)
        {
            int c2 = bytes[2]&0xFF;
            
            if (m_checkLeiJiNum != c2)
            {
                m_checkLeiJiNum = 0;
                [m_speedDic removeAllObjects];
                return;
            }
            else
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_speedDic];
                [m_speedArray addObject:dic1];
                [m_speedDic removeAllObjects];
                m_checkLeiJiNum = 0;
            }
            
            [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
        }
    }
    else if (markNum == 10) {
        NSMutableDictionary *runDic = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        int c1 = bytes[1]&0xFF;
        NSString *isRun = [NSString stringWithFormat:@"%i",c1];
        [runDic setObject:isRun forKey:@"isRun"];
        
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int c5 = bytes[5]&0xFF;
        int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
        NSString *beginTimeMinutes = [NSString stringWithFormat:@"%d",c5+(c4<<8)+(c3<<16)+(c2<<24)-juTime];
        NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[beginTimeMinutes longLongValue]];
        NSString *beginTimeString = [myFormatter stringFromDate:beginTime];
        [runDic setObject:beginTimeString forKey:@"startTime"];
        
        int c6 = bytes[6]&0xFF;
        int c7 = bytes[7]&0xFF;
        int c8 = bytes[8]&0xFF;
        int c9 = bytes[9]&0xFF;
        NSString *endTimeMinutes = [NSString stringWithFormat:@"%d",c9+(c8<<8)+(c7<<16)+(c6<<24)-juTime];
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[endTimeMinutes longLongValue]];
        NSString *endTimeString = [myFormatter stringFromDate:endTime];
        [runDic setObject:endTimeString forKey:@"endTime"];
        
        [m_runArray addObject:runDic];
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 11) {
        int c1 = bytes[1]&0xFF;
        int c2 = bytes[2]&0xFF;
        NSString *limitSteps = [NSString stringWithFormat:@"%d",c2+(c1<<8)];
        [resultDic setObject:limitSteps forKey:@"limitSteps"];
        
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *limitMinutes = [NSString stringWithFormat:@"%d",c4+(c3<<8)];
        [resultDic setObject:limitMinutes forKey:@"limitMinutes"];
        
        int c5 = bytes[5]&0xFF;
        NSString *timeInterval = [NSString stringWithFormat:@"%d",c5];
        [resultDic setObject:timeInterval forKey:@"timeInterval"];
        
        int c6 = bytes[6]&0xFF;
        NSString *stepStandard = [NSString stringWithFormat:@"%d",c6];
        [resultDic setObject:stepStandard forKey:@"stepStandard"];
        
        [m_stepLimitDic removeAllObjects];
        [m_stepLimitDic addEntriesFromDictionary:resultDic];
        
//        NSLog(@"analytical --- %@---%@---%@---%@---%@",limitSteps,limitMinutes,timeInterval,stepStandard,hexString);
        
        [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
    }
    else if (markNum == 12) {
        if (markLongNum == 1)
        {
            if (m_RRDic.allKeys.count > 0)
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_xinLvDic];
                [m_RRArray addObject:dic1];
                [m_RRDic removeAllObjects];
            }
            
            [m_RRDic setObject:hexString forKey:@"xinLv1"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 2)
        {
            [m_RRDic setObject:hexString forKey:@"xinLv2"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 3)
        {
            [m_RRDic setObject:hexString forKey:@"xinLv3"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 4)
        {
            [m_RRDic setObject:hexString forKey:@"xinLv4"];
            m_checkLeiJiNum ++;
        }
        else if (markLongNum == 5)
        {
            int c2 = bytes[2]&0xFF;
            
            if (m_checkLeiJiNum != c2)
            {
                m_checkLeiJiNum = 0;
                [m_RRDic removeAllObjects];
                return;
            }
            else
            {
                NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:m_RRDic];
                [m_RRArray addObject:dic1];
                [m_RRDic removeAllObjects];
                m_checkLeiJiNum = 0;
            }
            
            [self.delegate analyticalSucceed:writeNum withResultNumber:markNum];
        }
    }
}


/********************************************************************************
 * 方法名称：getStepResultData
 * 功能描述：获取处理过的步行数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getStepResultData:(NSArray *)stepDataArr
{
    NSMutableArray *lastStepArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < stepDataArr.count; i++)
    {
        NSDictionary *stepDataDic = [stepDataArr objectAtIndex:i];
        NSString *step1 = [stepDataDic objectForKey:@"step1"];
        NSString *step2 = [stepDataDic objectForKey:@"step2"];
        
        NSString *resultStep = nil;
        NSString *stepAll1 = [[step1 substringFromIndex:4] substringToIndex:step1.length-6];
        
        if (step2 != nil)
        {
            NSString *stepAll2 = [[step2 substringFromIndex:4] substringToIndex:step2.length-6];
            resultStep = [NSString stringWithFormat:@"%@%@",stepAll1,stepAll2];
        }
        else
        {
            resultStep = [NSString stringWithFormat:@"%@",stepAll1];
        }
        
        NSArray *testArr = [self getLastData:resultStep withMark:@"step"];
        [lastStepArray addObjectsFromArray:testArr];
    }
    
    return [self cutSameMember:lastStepArray];
}


/********************************************************************************
 * 方法名称：getSleepResultData
 * 功能描述：获取处理过的睡眠数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getSleepResultData:(NSArray *)sleepDataArr
{
    NSMutableArray *lastSleepArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < sleepDataArr.count; i++)
    {
        NSDictionary *stepDataDic = [sleepDataArr objectAtIndex:i];
        NSString *sleep1 = [stepDataDic objectForKey:@"sleep1"];
        NSString *sleep2 = [stepDataDic objectForKey:@"sleep2"];
        
        NSString *resultSleep = nil;
        NSString *sleepAll1 = [[sleep1 substringFromIndex:4] substringToIndex:sleep1.length-6];
        
        if (sleep2 != nil)
        {
            NSString *sleepAll2 = [[sleep2 substringFromIndex:4] substringToIndex:sleep2.length-6];
            resultSleep = [NSString stringWithFormat:@"%@%@",sleepAll1,sleepAll2];
        }
        else
        {
            resultSleep = [NSString stringWithFormat:@"%@",sleepAll1];
        }
        
        NSArray *testArr = [self getLastData:resultSleep withMark:@"sleep"];
        [lastSleepArray addObjectsFromArray:testArr];
    }
    
    return  [self cutSameMember:lastSleepArray];
}


/********************************************************************************
 * 方法名称：getXinLvResultData
 * 功能描述：获取处理过的心率数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getXinLvResultData:(NSArray *)xinLvDataArr
{
    NSMutableArray *lastXinLvArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xinLvDataArr.count; i++)
    {
        NSDictionary *stepDataDic = [xinLvDataArr objectAtIndex:i];
        NSString *xinLv1 = [stepDataDic objectForKey:@"xinLv1"];
        NSString *xinLv2 = [stepDataDic objectForKey:@"xinLv2"];
        NSString *xinLv3 = [stepDataDic objectForKey:@"xinLv3"];
        NSString *xinLv4 = [stepDataDic objectForKey:@"xinLv4"];
        
        NSString *resultSleep = nil;
        NSString *xinLvAll1 = [[xinLv1 substringFromIndex:4] substringToIndex:xinLv1.length-6];
        resultSleep = [NSString stringWithFormat:@"%@",xinLvAll1];
        
        if (xinLv2 != nil)
        {
            NSString *xinLvAll2 = [[xinLv2 substringFromIndex:4] substringToIndex:xinLv2.length-6];
            resultSleep = [NSString stringWithFormat:@"%@%@",xinLvAll1,xinLvAll2];
            
            if (xinLv3 != nil)
            {
                NSString *xinLvAll3 = [[xinLv3 substringFromIndex:4] substringToIndex:xinLv3.length-6];
                resultSleep = [NSString stringWithFormat:@"%@%@%@",xinLvAll1,xinLvAll2,xinLvAll3];
                
                if (xinLv4 != nil)
                {
                    NSString *xinLvAll4 = [[xinLv4 substringFromIndex:4] substringToIndex:xinLv4.length-6];
                    resultSleep = [NSString stringWithFormat:@"%@%@%@%@",xinLvAll1,xinLvAll2,xinLvAll3,xinLvAll4];
                }
            }
        }
        
        NSArray *testArr = [self getLastData:resultSleep withMark:@"xinLv"];
        [lastXinLvArray addObjectsFromArray:testArr];
    }
    
    return [self cutSameMember:lastXinLvArray];
}
    
/********************************************************************************
 * 方法名称：getRRResultData
 * 功能描述：获取处理过的心率RR数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getRRResultData:(NSArray *)xinLvDataArr {
    NSMutableArray *lastXinLvArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < xinLvDataArr.count; i++)
    {
        NSDictionary *stepDataDic = [xinLvDataArr objectAtIndex:i];
        NSString *xinLv1 = [stepDataDic objectForKey:@"xinLv1"];
        NSString *xinLv2 = [stepDataDic objectForKey:@"xinLv2"];
        NSString *xinLv3 = [stepDataDic objectForKey:@"xinLv3"];
        NSString *xinLv4 = [stepDataDic objectForKey:@"xinLv4"];
        
        NSString *resultSleep = nil;
        NSString *xinLvAll1 = [[xinLv1 substringFromIndex:4] substringToIndex:xinLv1.length-6];
        resultSleep = [NSString stringWithFormat:@"%@",xinLvAll1];
        
        if (xinLv2 != nil)
        {
            NSString *xinLvAll2 = [[xinLv2 substringFromIndex:4] substringToIndex:xinLv2.length-6];
            resultSleep = [NSString stringWithFormat:@"%@%@",xinLvAll1,xinLvAll2];
            
            if (xinLv3 != nil)
            {
                NSString *xinLvAll3 = [[xinLv3 substringFromIndex:4] substringToIndex:xinLv3.length-6];
                resultSleep = [NSString stringWithFormat:@"%@%@%@",xinLvAll1,xinLvAll2,xinLvAll3];
                
                if (xinLv4 != nil)
                {
                    NSString *xinLvAll4 = [[xinLv4 substringFromIndex:4] substringToIndex:xinLv4.length-6];
                    resultSleep = [NSString stringWithFormat:@"%@%@%@%@",xinLvAll1,xinLvAll2,xinLvAll3,xinLvAll4];
                }
            }
        }
        
        NSArray *testArr = [self getLastData:resultSleep withMark:@"rr"];
        [lastXinLvArray addObjectsFromArray:testArr];
    }
    
    return [self cutSameMember:lastXinLvArray];
}


/********************************************************************************
 * 方法名称：getLastData
 * 功能描述：获取最后的手环数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getLastData:(NSString *)allString withMark:(NSString *)mark
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    int stringLeng = (int)allString.length/2;
    
    int j=0;
    Byte bytes[stringLeng];
    
    for(int i=0;i<[allString length];i++)
    {
        int int_ch; //// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [allString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [allString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        //        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch; ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    int c0 = bytes[0]&0xFF;
    int c1 = bytes[1]&0xFF;
    int c2 = bytes[2]&0xFF;
    int c3 = bytes[3]&0xFF;
    int juTime = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
    NSString *timeMinutes = [NSString stringWithFormat:@"%d",c3+(c2<<8)+(c1<<16)+(c0<<24)-juTime];
    NSDate *handTime = [NSDate dateWithTimeIntervalSince1970:[timeMinutes longLongValue]];
    
    if ([mark isEqualToString:@"step"])
    {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        
        for (int i = 4; i < stringLeng; i++)
        {
            float dataNum = bytes[i]&0xFF;
            NSString *dataNumStr = [NSString stringWithFormat:@"%.0f",dataNum];
            
            if (i%2 == 0)
            {
                [resultDic setObject:dataNumStr forKey:@"walkCounts"];
            }
            else
            {
                dataNumStr = [NSString stringWithFormat:@"%.1f",dataNum/10];
                [resultDic setObject:dataNumStr forKey:@"calorie"];
                [resultDic setObject:[NSString stringWithFormat:@"%.0f",dataNum] forKey:@"activeTime"];
                NSInteger interval = 60*(i/2 - 2);
                NSDate *myDate = [handTime dateByAddingTimeInterval: interval];
                NSString *myDateStr = [myFormatter stringFromDate:myDate];
                [resultDic setObject:myDateStr forKey:@"createTime"];
                NSString *tipTime = [NSString stringWithFormat:@"%@00:00",[myDateStr substringToIndex:14]];
                [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateStr]] forKey:@"timestamps"];
                
                [resultDic setObject:tipTime forKey:@"tipTime"];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:resultDic];
                [resultArr addObject:dic];
                [resultDic removeAllObjects];
            }
        }
    }
    else if ([mark isEqualToString:@"sleep"])
    {
        for (int i = 4; i < stringLeng; i++)
        {
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            
            int dataNum = bytes[i]&0xFF;
            NSString *moveNum = [NSString stringWithFormat:@"%d",dataNum];
            [resultDic setObject:moveNum forKey:@"moveCounts"];
            
            NSInteger interval = 5*60*(i - 4);
            NSDate *myDate = [handTime dateByAddingTimeInterval: interval];
            NSString *myDateStr = [myFormatter stringFromDate:myDate];
            [resultDic setObject:myDateStr forKey:@"createTime"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateStr]] forKey:@"timestamps"];
            
            [resultArr addObject:resultDic];
        }
    }
    else if ([mark isEqualToString:@"xinLv"])
    {
        for (int i = 4; i < stringLeng; i++)
        {
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            
            int dataNum = bytes[i]&0xFF;
            NSString *xinLvNum = [NSString stringWithFormat:@"%d",dataNum];
            [resultDic setObject:xinLvNum forKey:@"heartRateNum"];
            
            NSInteger interval = 2 * (i - 4);
            NSDate *myDate = [handTime dateByAddingTimeInterval: interval];
            NSString *myDateStr = [myFormatter stringFromDate:myDate];
            [resultDic setObject:myDateStr forKey:@"sportTime"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateStr]] forKey:@"timestamps"];
            
            [resultArr addObject:resultDic];
        }
    }
    else if ([mark isEqualToString:@"rr"])
    {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        NSDate *myDate = [handTime dateByAddingTimeInterval: 0];
        NSString *myDateStr = [myFormatter stringFromDate:myDate];
        [resultDic setObject:myDateStr forKey:@"intervalTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:myDateStr]] forKey:@"timestamps"];
        
        NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
        for (int i = 4; i < stringLeng; i++) {
            if (i%2 == 0) {
                int byteHi = bytes[i]&0xFF;
                int byteLow = bytes[i+1]&0xFF;
                NSString *rrNum = [NSString stringWithFormat:@"%d",byteLow+(byteHi<<8)];
                [intervalArray addObject:rrNum];
            }
        }
        
        [resultDic setObject:intervalArray forKey:@"RRInterval"];
        if (intervalArray.count > 0) {
            [resultArr addObject:resultDic];
        }
    }
    
    return resultArr;
}


/********************************************************************************
 * 方法名称：getKeyData
 * 功能描述：获取关键字
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)getKeyData:(NSString *)myStr andMark:(NSString *)mark
{
    int j=0;
    Byte bytes[20];
    for(int i=0;i<[myStr length];i++)
    {
        int int_ch;
        
        unichar hex_char1 = [myStr characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [myStr characterAtIndex:i];
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
    
    int res = 0;
    if ([mark isEqualToString:@"0"])
    {
        int h0 = bytes[0]&0xF0;
        res = h0>>4;
    }
    else if ([mark isEqualToString:@"1"])
    {
        int h0 = bytes[0]&0xFF;
        res = h0;
    }
    
    return [NSString stringWithFormat:@"%i",res];
}
    
/***************************************************************************
 * 方法名称：cutSameMember
 * 功能描述：去除数组中相同的元素
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (NSArray *)cutSameMember:(NSArray *)dateArray
{
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:dateArray];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:set.array];
    return resultArray;
}


@end
