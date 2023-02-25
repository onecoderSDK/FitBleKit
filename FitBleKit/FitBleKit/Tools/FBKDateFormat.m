/********************************************************************************
 * 文件名称：FBKDateFormat.m
 * 内容摘要：时间处理
 * 版本编号：1.0.1
 * 创建日期：2017年11月09日
 ********************************************************************************/

#import "FBKDateFormat.h"

@implementation FBKDateFormat

/********************************************************************************
 * 方法名称：getDate
 * 功能描述：将指定日期字符串化
 * 输入参数：date - 某个时间   type - 转化的格式
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getDateString:(NSDate *)date withType:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *resultString = [dateFormatter stringFromDate:date];
    return resultString;
}


/********************************************************************************
 * 方法名称：get1970Nums
 * 功能描述：将指定的时间转化为时间戳
 * 输入参数：dateString - 指定的时间字符串
 * 返回数据：
 ********************************************************************************/
+ (double)getTimestamp:(NSString *)dateString
{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [myFormatter dateFromString:dateString];
    double resultNumber = [nowDate timeIntervalSince1970];
    return resultNumber;
}


/********************************************************************************
 * 方法名称：getMyTime
 * 功能描述：获取指定日期前一天／后一天的日期
 * 输入参数：dateString - 指定日期格式yyyy-MM-dd   isYestoday - 是否是前一天
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getDateTime:(NSString *)dateString isYestoday:(BOOL)isYestoday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormatter dateFromString:dateString];
    
    if (isYestoday)
    {
        NSDate *myDate = [now dateByAddingTimeInterval: 0-60*60*24];
        NSString *resultString = [dateFormatter stringFromDate:myDate];
        return resultString;
    }
    else
    {
        NSDate *myDate = [now dateByAddingTimeInterval: 60*60*24];
        NSString *resultString = [dateFormatter stringFromDate:myDate];
        return resultString;
    }
    
    return nil;
}


/********************************************************************************
 * 方法名称：compareDate
 * 功能描述：时间比较大小
 * 输入参数：dateString- 某个时间 otherDateString - 另一个时间
 * 返回数据：YES：相等或dateString大
 ********************************************************************************/
+ (BOOL)compareDate:(NSString *)dateString withDate:(NSString *)otherDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now1 = [dateFormatter dateFromString:dateString];
    NSDate *now2 = [dateFormatter dateFromString:otherDateString];
    
    if ([now1 isEqualToDate:now2])
    {
        return YES;
    }
    
    NSDate *date = [now1 earlierDate:now2];
    
    if ([date isEqualToDate:now1])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


/********************************************************************************
 * 方法名称：getDateWeekString
 * 功能描述：根据数据的到周几
 * 输入参数：weekNum - 周特征值
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getDateWeekString:(int)weekNum
{
    return nil;
}


/********************************************************************************
 * 方法名称：getWeekNum
 * 功能描述：获取指定日期的单属性（年月日时分秒）
 * 输入参数：dateString - 某个时间   type - 时间格式   myType - 获取的属性
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getDateChar:(NSString *)dateString withDateType:(NSString *)type withCharNum:(int)myType
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSWeekdayOrdinalCalendarUnit |
    NSWeekCalendarUnit |
    NSWeekdayCalendarUnit |
    NSSecondCalendarUnit;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSDate *now = [dateFormatter dateFromString:dateString];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    
    if (myType == 1)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps week]];
    }
    else if (myType == 2)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps year]];
    }
    else if (myType == 3)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps month]];
    }
    else if (myType == 4)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps weekday]];
    }
    else if (myType == 5)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps day]];
    }
    else if (myType == 6)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps hour]];
    }
    else if (myType == 7)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps minute]];
    }
    else if (myType == 8)
    {
        return [NSString stringWithFormat:@"%i",(int)[comps second]];
    }
    
    return 0;
}


/********************************************************************************
 * 方法名称：getThisWeekDay
 * 功能描述：获取指定日期当周的全部日期数组
 * 输入参数：dateString - 指定的日期格式为yyyy-MM-dd
 * 返回数据：
 ********************************************************************************/
+ (NSArray *)getThisWeekDay:(NSString *)dateString
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormatter dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    int weekNum = (int)[comps weekday];
    
    NSDate *myDate = [now dateByAddingTimeInterval: 0-60*60*24*(weekNum-1)];
    
    for (int i = 0; i < 7; i++)
    {
        NSDate *resultDate = [myDate dateByAddingTimeInterval: 60*60*24*i];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:resultDate];
        int dayNum = (int)[comps day];
        NSString *dastr = [dateFormatter stringFromDate:resultDate];
        NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
        [dateDic setObject:[NSString stringWithFormat:@"%i",dayNum] forKey:@"dateMark"];
        [dateDic setObject:dastr forKey:@"dateNum"];
        [dateDic setObject:[NSString stringWithFormat:@"%i",i+1] forKey:@"weekNum"];
        [dateDic setObject:@"1" forKey:@"isThisMonth"];
        [resultArray addObject:dateDic];
    }
    
    return resultArray;
}


/********************************************************************************
 * 方法名称：getThisMonthDay
 * 功能描述：获取指定日期当月的全部日期数组
 * 输入参数：dateString - 指定日期格式yyyy-MM-dd   isMore - 是否需要补满一个正方形的日历
 * 返回数据：
 ********************************************************************************/
+ (NSArray *)getThisMonthDay:(NSString *)dateString isMore:(BOOL)isMore
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [dateFormatter dateFromString:dateString];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit forDate:now];
    int monthLenhth = (int)days.length;
    
    NSString *beforeStr = nil;
    if (dateString.length > 8)
    {
        beforeStr = [dateString substringToIndex:8];
    }
    else
    {
        return nil;
    }
    
    NSString *firstDay = [NSString stringWithFormat:@"%@%i",beforeStr,1];
    NSMutableArray *firstDayArr = [[NSMutableArray alloc] initWithArray:[self getThisWeekDay:firstDay]];
    NSDate *firstDate = [dateFormatter dateFromString:firstDay];
    NSDateComponents *compsfirst = [calendar components:unitFlags fromDate:firstDate];
    int firstDateNum = (int)[compsfirst weekday];
    
    NSMutableArray *firstResultArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < firstDayArr.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[firstDayArr objectAtIndex:i]];
        if (i < firstDateNum-1)
        {
            [dic setObject:@"0" forKey:@"isThisMonth"];
            [firstResultArr addObject:dic];
        }
    }
    
    NSString *lastDay = [NSString stringWithFormat:@"%@%i",beforeStr,monthLenhth];
    NSMutableArray *lastDayArr = [[NSMutableArray alloc] initWithArray:[self getThisWeekDay:lastDay]];
    NSDate *lastDate = [dateFormatter dateFromString:lastDay];
    NSDateComponents *compslast = [calendar components:unitFlags fromDate:lastDate];
    int lastDateNum = (int)[compslast weekday];
    
    NSMutableArray *lastResultArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < lastDayArr.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[lastDayArr objectAtIndex:i]];
        if (i > lastDateNum-1)
        {
            [dic setObject:@"2" forKey:@"isThisMonth"];
            [lastResultArr addObject:dic];
        }
    }
    
    for (int i = 1; i <= monthLenhth; i++)
    {
        if (i < 10)
        {
            NSString *resStr = [NSString stringWithFormat:@"%@0%i",beforeStr,i];
            
            NSDate *now = [dateFormatter dateFromString:resStr];
            NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
            int weekNum = (int)[comps weekday];
            
            NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
            [dateDic setObject:[NSString stringWithFormat:@"%i",i] forKey:@"dateMark"];
            [dateDic setObject:resStr forKey:@"dateNum"];
            [dateDic setObject:@"1" forKey:@"isThisMonth"];
            [dateDic setObject:[NSString stringWithFormat:@"%i",weekNum] forKey:@"weekNum"];
            [resultArray addObject:dateDic];
        }
        else
        {
            NSString *resStr = [NSString stringWithFormat:@"%@%i",beforeStr,i];
            
            NSDate *now = [dateFormatter dateFromString:resStr];
            NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
            int weekNum = (int)[comps weekday];
            
            NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
            [dateDic setObject:[NSString stringWithFormat:@"%i",i] forKey:@"dateMark"];
            [dateDic setObject:resStr forKey:@"dateNum"];
            [dateDic setObject:@"1" forKey:@"isThisMonth"];
            [dateDic setObject:[NSString stringWithFormat:@"%i",weekNum] forKey:@"weekNum"];
            [resultArray addObject:dateDic];
        }
    }
    
    if (!isMore)
    {
        return resultArray;
    }
    
    [firstResultArr addObjectsFromArray:resultArray];
    [firstResultArr addObjectsFromArray:lastResultArr];
    
    return firstResultArr;
}


/********************************************************************************
 * 方法名称：getNowDateFromatAnDate
 * 功能描述：获取国际时间差值
 * 输入参数：anyDate - 当前时间
 * 返回数据：
 ********************************************************************************/
+ (int)getNowDateFromatAnDateMore:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return interval;
}


@end

