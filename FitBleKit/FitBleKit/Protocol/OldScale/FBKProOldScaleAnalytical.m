/********************************************************************************
 * 文件名称：FBKProOldScaleAnalytical.m
 * 内容摘要：老秤数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProOldScaleAnalytical.h"
#import "FBKDateFormat.h"

@implementation FBKProOldScaleAnalytical
{
    NSMutableDictionary *weightDataDic;
    int m_historyCount;
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
    
    weightDataDic = [[NSMutableDictionary alloc] init];
    m_historyCount = 0;
    
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
    [weightDataDic removeAllObjects];
    m_historyCount = 0;
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
    int startNum = 0;
    int endNum  = bytes[byteLong-1]&0xFF;
    for (int i = 0; i < byteLong-1; i++)
    {
        int test = bytes[i]&0xFF;
        startNum = startNum+test;
    }
    
    startNum = startNum%256;
    
    if (endNum != startNum)
    {
        NSLog(@"*****************************checkNumber is wrong*****************************");
        return;
    }
    
    int bagNumber  = bytes[0]&0xFF;
    if (bagNumber != 253)
    {
        NSLog(@"*****************************bagNumber is wrong*****************************");
        return;
    }
    
    // 以下需要的参数
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    int zoneTime     = [FBKDateFormat getNowDateFromatAnDateMore:[NSDate date]];
    
    int markNumber = bytes[2]&0xFF;
    if (markNumber == 1)
    {
        NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
        
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int weight = (c3<<8) + c4;
        [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)weight/10] forKey:@"weightNumber"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleRealTime];
    }
    else if(markNumber == 2)
    {
        NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
        
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        int weight = (c3<<8) + c4;
        [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)weight/10] forKey:@"weightNumber"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleStable];
    }
    else if(markNumber == 3)
    {
        int bagTotle = (bytes[3]&0xFF)>>4;
        int bagMark  = bytes[3]&0x0F;
        
        if (bagMark == 1)
        {
            int userId  = bytes[4]&0xFF;
            int height  = bytes[5]&0xFF;
            int age     = bytes[6]&0xFF;
            int gender  = bytes[7]&0xFF;
            int weight  = ((bytes[8]&0xFF)<<8) + (bytes[9]&0xFF);
            int unit    = bytes[10]&0xFF;
            int fat     = ((bytes[11]&0xFF)<<8) + (bytes[12]&0xFF);
            int water   = ((bytes[13]&0xFF)<<8) + (bytes[14]&0xFF);
            int bone    = ((bytes[15]&0xFF)<<8) + (bytes[16]&0xFF);
            int muscle  = ((bytes[17]&0xFF)<<8) + (bytes[18]&0xFF);
            
            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            [resultDic setObject:nowTime forKey:@"bandTime"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)userId]    forKey:@"userId"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)height]    forKey:@"height"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)age]       forKey:@"age"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)gender]    forKey:@"gender"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)weight/10] forKey:@"weight"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)unit]      forKey:@"unit"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)fat/10]    forKey:@"fat"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)water/10]  forKey:@"water"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)bone/10]   forKey:@"bone"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)muscle/10] forKey:@"muscle"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber]         forKey:@"weightMark"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagTotle]           forKey:@"bagTotle"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagMark]            forKey:@"bagMark"];
            [weightDataDic addEntriesFromDictionary:resultDic];
        }
        else if (bagMark == bagTotle)
        {
            int calories = ((bytes[4]&0xFF)<<8) + (bytes[5]&0xFF);
            int BMI      = ((bytes[6]&0xFF)<<8) + (bytes[7]&0xFF);
            int visceral = ((bytes[8]&0xFF)<<8) + (bytes[9]&0xFF);
            
            [resultDic addEntriesFromDictionary:weightDataDic];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)calories] forKey:@"calories"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)BMI/10]   forKey:@"BMI"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)visceral] forKey:@"visceral"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber]        forKey:@"weightMark"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagTotle]          forKey:@"bagTotle"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagMark]           forKey:@"bagMark"];
            [weightDataDic removeAllObjects];
            
            [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleDetail];
        }
    }
    else if(markNumber == 4)
    {
        int versionNum = (bytes[1]&0xFF) - 7;
        int unit       = bytes[4]&0xFF;
        int weightType = bytes[5]&0xFF;
        
        NSMutableString *vesionStr = [[NSMutableString alloc] init];
        for (int i = 0; i < versionNum; i++)
        {
            int asciiCode = bytes[6+i]&0xFF;
            NSString *asciiCodeStr = [NSString stringWithFormat:@"%c",asciiCode];
            [vesionStr appendString:asciiCodeStr];
        }
        NSArray *versionArray = [vesionStr componentsSeparatedByString:@","];
        NSString *softVersion = @"v1.0.1";
        NSString *bandVersion = @"v1.0";
        if (versionArray.count == 2)
        {
            softVersion = [versionArray objectAtIndex:0];
            softVersion = [versionArray objectAtIndex:1];
        }
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",unit]       forKey:@"unit"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",weightType] forKey:@"weightType"];
        [resultDic setObject:softVersion forKey:@"softVersion"];
        [resultDic setObject:bandVersion forKey:@"bandVersion"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleVersion];
    }
    else if(markNumber == 5)
    {
        int bagTotle = (bytes[3]&0xFF)>>4;
        int bagMark  = bytes[3]&0x0F;
        
        NSMutableDictionary *userInfo1 = [[NSMutableDictionary alloc] init];
        [userInfo1 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[4]&0xFF)]  forKey:@"weight_ID"];
        [userInfo1 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[5]&0xFF)]  forKey:@"weight_height"];
        [userInfo1 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[6]&0xFF)]  forKey:@"weight_age"];
        [userInfo1 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[7]&0xFF)]  forKey:@"weight_gender"];
        [resultDic setObject:userInfo1 forKey:@"user1"];
        
        NSMutableDictionary *userInfo2 = [[NSMutableDictionary alloc] init];
        [userInfo2 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[8]&0xFF)]  forKey:@"weight_ID"];
        [userInfo2 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[9]&0xFF)]  forKey:@"weight_height"];
        [userInfo2 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[10]&0xFF)] forKey:@"weight_age"];
        [userInfo2 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[11]&0xFF)] forKey:@"weight_gender"];
        [resultDic setObject:userInfo2 forKey:@"user2"];
        
        NSMutableDictionary *userInfo3 = [[NSMutableDictionary alloc] init];
        [userInfo3 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[12]&0xFF)] forKey:@"weight_ID"];
        [userInfo3 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[13]&0xFF)] forKey:@"weight_height"];
        [userInfo3 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[14]&0xFF)] forKey:@"weight_age"];
        [userInfo3 setObject:[NSString stringWithFormat:@"%.0f",(float)(bytes[15]&0xFF)] forKey:@"weight_gender"];
        [resultDic setObject:userInfo3 forKey:@"user3"];
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",bagTotle] forKey:@"bagTotle"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",bagMark] forKey:@"bagMark"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        m_historyCount = 0;
        
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleUserInfo];
    }
    else if(markNumber == 6)
    {
        int time = ( ((bytes[3]&0xFF)<<24) + ((bytes[4]&0xFF)<<16) + ((bytes[5]&0xFF)<<8) + (bytes[6]&0xFF));
        
        NSDate *bandTime = [NSDate dateWithTimeIntervalSince1970:time-zoneTime];
        NSString *bandTimeString = [myFormatter stringFromDate:bandTime];
        [resultDic setObject:bandTimeString forKey:@"localTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleDeviceTime];
    }
    else if(markNumber == 7)
    {
        int bagTotle = (bytes[3]&0xFF)>>4;
        int bagMark  = bytes[3]&0x0F;
        
        if (bagMark == 1)
        {
            int time = ( ((bytes[4]&0xFF)<<24) + ((bytes[5]&0xFF)<<16) + ((bytes[6]&0xFF)<<8) + (bytes[7]&0xFF));
            int userId  = bytes[8]&0xFF;
            int height  = bytes[9]&0xFF;
            int age     = bytes[10]&0xFF;
            int gender  = bytes[11]&0xFF;
            int weight  = ((bytes[12]&0xFF)<<8) + (bytes[13]&0xFF);
            int unit    = bytes[14]&0xFF;
            int fat     = ((bytes[15]&0xFF)<<8) + (bytes[16]&0xFF);
            int water   = ((bytes[17]&0xFF)<<8) + (bytes[18]&0xFF);
            
            NSDate *bandTime = [NSDate dateWithTimeIntervalSince1970:time-zoneTime];
            NSString *bandTimeString = [myFormatter stringFromDate:bandTime];
            
            [resultDic setObject:bandTimeString forKey:@"bandTime"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:bandTimeString]] forKey:@"timestamps"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber]         forKey:@"weightMark"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)userId]    forKey:@"userId"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)height]    forKey:@"height"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)age]       forKey:@"age"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)gender]    forKey:@"gender"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)weight/10] forKey:@"weight"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)unit]      forKey:@"unit"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)fat/10]    forKey:@"fat"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)water/10]  forKey:@"water"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber]         forKey:@"weightMark"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagTotle]           forKey:@"bagTotle"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagMark]            forKey:@"bagMark"];
            [weightDataDic addEntriesFromDictionary:resultDic];
            
        }
        else if (bagMark == bagTotle)
        {
            int bone     = ((bytes[4]&0xFF)<<8) + (bytes[5]&0xFF);
            int muscle   = ((bytes[6]&0xFF)<<8) + (bytes[7]&0xFF);
            int calories = ((bytes[8]&0xFF)<<8) + (bytes[9]&0xFF);
            int BMI      = ((bytes[10]&0xFF)<<8) + (bytes[11]&0xFF);
            int visceral = ((bytes[12]&0xFF)<<8) + (bytes[13]&0xFF);
            
            [resultDic addEntriesFromDictionary:weightDataDic];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)bone/10]     forKey:@"bone"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)muscle/10]   forKey:@"muscle"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)calories] forKey:@"calories"];
            [resultDic setObject:[NSString stringWithFormat:@"%.1f",(float)BMI/10]      forKey:@"BMI"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",(float)visceral] forKey:@"visceral"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber]        forKey:@"weightMark"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagTotle]          forKey:@"bagTotle"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",bagMark]           forKey:@"bagMark"];
            [weightDataDic removeAllObjects];
            
            m_historyCount++;
            
            [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleRecord];
        }
    }
    else if(markNumber == 100)
    {
        int commandNum = bytes[3]&0xFF;
        
        [resultDic setObject:[NSString stringWithFormat:@"%i",markNumber] forKey:@"weightMark"];
        [resultDic setObject:[NSString stringWithFormat:@"%i",commandNum] forKey:@"commandNum"];
        
        [self.delegate analyticalSucceed:resultDic withResultNumber:FBKAnalyOScaleAck];
    }
}


@end
