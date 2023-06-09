/********************************************************************************
 * 文件名称：FBKFightClass.h
 * 内容摘要：新拳击蓝牙参数类
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKFightClass : NSObject

@end


@interface FBKFightSandbag : NSObject

@property (assign, nonatomic) int sandbagLength; // 单位(mm)

@property (assign, nonatomic) int sandbagWidth; // 单位(mm)

@property (assign, nonatomic) int sandbagHight; // 单位(mm)

@property (assign, nonatomic) int sandbagWeight; // 单位(kg)

@property (assign, nonatomic) int sandbagType; // 沙袋类型（吊式或立式）

@property (assign, nonatomic) int powerSensitivity; // 灵敏度(灵敏度5~150，推荐值13)

@property (assign, nonatomic) int rateSensitivity; // 灵敏度(灵敏度1~20，推荐值8)

@end


@interface FBKFightInfo : NSObject

@property (assign, nonatomic) int protocolVersion;

@property (assign, nonatomic) int fightNumbers;

@property (assign, nonatomic) int fightFrequency;

@property (assign, nonatomic) BOOL isEnoughBattery;

@property (assign, nonatomic) int strengthIndex;

@end
