/********************************************************************************
 * 文件名称：FBKDateFormat.h
 * 内容摘要：时间处理
 * 版本编号：1.0.1
 * 创建日期：2017年11月09日
 ********************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKDateFormat : NSObject

// 将指定日期字符串化
+ (NSString *)getDateString:(NSDate *)date withType:(NSString *)type;

// 将指定的时间转化为时间戳
+ (double)getTimestamp:(NSString *)dateString;

// 获取指定日期前一天／后一天的日期
+ (NSString *)getDateTime:(NSString *)dateString isYestoday:(BOOL)isYestoday;

// 时间比较大小
+ (BOOL)compareDate:(NSString *)dateString withDate:(NSString *)otherDateString;

// 根据数据得到周几
+ (NSString *)getDateWeekString:(int)weekNum;

// 获取指定日期的单属性（年月日时分秒）
+ (NSString *)getDateChar:(NSString *)dateString withDateType:(NSString *)type withCharNum:(int)myType;

// 获取指定日期当周的全部日期数组
+ (NSArray *)getThisWeekDay:(NSString *)dateString;

// 获取指定日期当月的全部日期数组
+ (NSArray *)getThisMonthDay:(NSString *)dateString isMore:(BOOL)isMore;

// 获取国际时间差值
+ (int)getNowDateFromatAnDateMore:(NSDate *)anyDate;

@end
