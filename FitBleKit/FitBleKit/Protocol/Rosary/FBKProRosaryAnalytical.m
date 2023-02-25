/********************************************************************************
 * 文件名称：FBKProRosaryAnalytical.m
 * 内容摘要：念珠蓝牙数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import "FBKProRosaryAnalytical.h"
#import "FBKDateFormat.h"

@implementation FBKProRosaryAnalytical
{
    NSMutableArray *m_historyArray;
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
    
    m_historyArray = [[NSMutableArray alloc] init];
    
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
    [m_historyArray removeAllObjects];
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙回复的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBlueData:(NSString *)hexString
{
    if (hexString.length < 8)
    {
        return;
    }
    
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
        //        NSLog(@"int_ch=%d",int_ch);
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
    
    int headNumber = bytes[0]&0xFF;
    if (headNumber != 253)
    {
        return;
    }
    
    int cmdNum = bytes[2]&0xFF;
    if (cmdNum == 1)
    {
        int beadLength = bytes[1]&0xFF;
        
        if (beadLength == 7)
        {
            int c3 = bytes[3]&0xFF;
            int c4 = bytes[4]&0xFF;
            int c5 = bytes[5]&0xFF;
            NSString *beadNumber = [NSString stringWithFormat:@"%d",c5+(c4<<8)+(c3<<16)];
            [resultDic setObject:beadNumber forKey:@"tipNumber"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
            [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryRTNumber];
        }
        else if (beadLength == 8)
        {
            long int c3 = bytes[3]&0xFF;
            int c4 = bytes[4]&0xFF;
            int c5 = bytes[5]&0xFF;
            int c6 = bytes[6]&0xFF;
            long int c63 = c3<<24;
            NSString *beadNumber = [NSString stringWithFormat:@"%ld",c6+(c5<<8)+(c4<<16)+c63];
            [resultDic setObject:beadNumber forKey:@"tipNumber"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
            [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryRTNumber];
        }
    }
    else if (cmdNum == 2)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"power"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryPower];
    }
    else if (cmdNum == 3)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"remindMode"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryRemindMode];
    }
    else if (cmdNum == 4)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"beadNumber"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryBeadNumber];
    }
    else if (cmdNum == 5)
    {
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        NSString *stepNum = [NSString stringWithFormat:@"%d",c6+(c5<<8)+(c4<<16)+(c3<<24)];
        
        int c7 = bytes[7]&0xFF;
        int c8 = bytes[8]&0xFF;
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        NSString *stepKcal = [NSString stringWithFormat:@"%d",(c10+(c9<<8)+(c8<<16)+(c7<<24))/10];
        
        int c11 = bytes[11]&0xFF;
        int c12 = bytes[12]&0xFF;
        int c13 = bytes[13]&0xFF;
        int c14 = bytes[14]&0xFF;
        NSString *stepDistance = [NSString stringWithFormat:@"%d",(c14+(c13<<8)+(c12<<16)+(c11<<24))/100000];
        
        [resultDic setObject:stepNum forKey:@"stepNum"];
        [resultDic setObject:stepKcal forKey:@"stepKcal"];
        [resultDic setObject:stepDistance forKey:@"stepDistance"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosarySteps];
    }
    else if (cmdNum == 6)
    {
        if (m_historyArray == nil)
        {
            m_historyArray = [[NSMutableArray alloc] init];
        }
        
        int GMTNUM = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *totalBag = [NSString stringWithFormat:@"%d",c3];
        NSString *bagNumber = [NSString stringWithFormat:@"%d",c4];
        
        if (c4 == 1)
        {
            [m_historyArray removeAllObjects];
        }
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        int c7 = bytes[7]&0xFF;
        int c8 = bytes[8]&0xFF;
        int startUtc  = c8 + (c7<<8) + (c6<<16) + (c5<<24) - GMTNUM;
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:startUtc];
        NSString *startDateString = [myFormatter stringFromDate:startTime];
        
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        int c11 = bytes[11]&0xFF;
        int c12 = bytes[12]&0xFF;
        int endUtc  = c12 + (c11<<8) + (c10<<16) + (c9<<24) - GMTNUM;
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:endUtc];
        NSString *endDateString = [myFormatter stringFromDate:endTime];
        
        int c13 = bytes[13]&0xFF;
        int c14 = bytes[14]&0xFF;
        int c15 = bytes[15]&0xFF;
        NSString *beadNumber = [NSString stringWithFormat:@"%d",c15+(c14<<8)+(c13<<16)];
        
        int c16 = bytes[16]&0xFF;
        NSString *bookId = [NSString stringWithFormat:@"%d",c16];
        
        [resultDic setObject:totalBag forKey:@"totalBag"];
        [resultDic setObject:bagNumber forKey:@"bagNumber"];
        [resultDic setObject:startDateString forKey:@"startTime"];
        [resultDic setObject:endDateString forKey:@"endTime"];
        [resultDic setObject:beadNumber forKey:@"beadNumber"];
        [resultDic setObject:bookId forKey:@"bookId"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [m_historyArray addObject:resultDic];
        
        if ((c3==c4) && ((int)m_historyArray.count==c3))
        {
            NSMutableDictionary *historyDic = [[NSMutableDictionary alloc] init];
            [historyDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
            [historyDic setObject:totalBag forKey:@"totalBag"];
            [historyDic setObject:m_historyArray forKey:@"historyData"];
            
            [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryRecord];
            return;
        }
        else
        {
            return;
        }
    }
    else if (cmdNum == 7)
    {
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int c5 = bytes[5]&0xFF;
        NSString *beadNumber = [NSString stringWithFormat:@"%d",c5+(c4<<8)+(c3<<16)];
        [resultDic setObject:beadNumber forKey:@"beadNumber"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryNumber];
    }
    else if (cmdNum == 8)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"bluePair"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryANCS];
    }
    else if (cmdNum == 9)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"historyState"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryRecordStatus];
    }
    else if (cmdNum == 10)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"beadState"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryStatus];
    }
    else if (cmdNum == 99)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"errorCode"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryError];
    }
    else if (cmdNum == 100)
    {
        int c3 = bytes[3]&0xFF;
        [resultDic setObject:[NSString stringWithFormat:@"%i",c3] forKey:@"backCode"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",cmdNum] forKey:@"cmdId"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyticalRosaryAck];
    }
}


@end
