/********************************************************************************
 * 文件名称：FBKDeviceUserInfo.h
 * 内容摘要：用户基本信息结构
 * 版本编号：1.0.1
 * 创建日期：2017年11月02日
 ********************************************************************************/

#import <Foundation/Foundation.h>

// 用户基本信息
@interface FBKDeviceUserInfo : NSObject

@property (strong,nonatomic) NSString *weight;   // 体重（kg）
@property (strong,nonatomic) NSString *height;   // 身高（cm）
@property (strong,nonatomic) NSString *age;      // 年龄（岁）
@property (strong,nonatomic) NSString *gender;   // 性别
@property (strong,nonatomic) NSString *walkGoal; // 目标步数

@end


// 用户睡眠信息
@interface FBKDeviceSleepInfo : NSObject

@property (strong,nonatomic) NSString *normalStart;  // 平时开始睡觉时间（格式：HH:mm）
@property (strong,nonatomic) NSString *normalEnd;    // 平时醒来时间（格式：HH:mm）
@property (strong,nonatomic) NSString *weekdayStart; // 周末开始睡觉时间（格式：HH:mm）
@property (strong,nonatomic) NSString *weekdaylEnd;  // 周末醒来时间（格式：HH:mm）

@end


// 用户限制信息
@interface FBKDeviceLimit : NSObject

@property (strong,nonatomic) NSString *limitSteps;    // 每分钟的步数限制
@property (strong,nonatomic) NSString *limitMinutes;  // 限制的总分钟数
@property (strong,nonatomic) NSString *timeInterval;  // 活跃时间的时间间隔
@property (strong,nonatomic) NSString *stepStandard;  // 活跃时间的步数判定标准

@end


// 用户定时间隔提醒信息
@interface FBKDeviceIntervalInfo : NSObject

@property (strong,nonatomic) NSString *amTime;       // 上午开始时间（格式：HH:mm）
@property (strong,nonatomic) NSString *pmTime;       // 下午开始时间（格式：HH:mm）
@property (strong,nonatomic) NSString *intervalTime; // 间隔时间（min）
@property (strong,nonatomic) NSString *switchStatus; // 开关 （0:关   1:开）

@end


// 用户消息提醒信息
@interface FBKDeviceNoticeInfo : NSObject

@property (strong,nonatomic) NSString *missedCall;   //（0:关   1:开）
@property (strong,nonatomic) NSString *mail;         //（0:关   1:开）
@property (strong,nonatomic) NSString *shortMessage; //（0:关   1:开）
@property (strong,nonatomic) NSString *weChat;       //（0:关   1:开）
@property (strong,nonatomic) NSString *qq;           //（0:关   1:开）
@property (strong,nonatomic) NSString *skype;        //（0:关   1:开）
@property (strong,nonatomic) NSString *whatsAPP;     //（0:关   1:开）
@property (strong,nonatomic) NSString *faceBook;     //（0:关   1:开）
@property (strong,nonatomic) NSString *others;       //（0:关   1:开）

@end


// 用户闹钟提醒信息
@interface FBKDeviceAlarmInfo : NSObject

@property (strong,nonatomic) NSString *alarmId;      // 闹钟ID（0～7）
@property (strong,nonatomic) NSString *alarmName;    // 闹钟名称
@property (strong,nonatomic) NSString *alarmTime;    // 闹钟时间
@property (strong,nonatomic) NSArray  *repeatTime;   // 闹钟重复时间
@property (strong,nonatomic) NSString *switchStatus; // 闹钟开关 （0:关   1:开）

@end


// 用户秤信息
@interface FBKDeviceScaleInfo : NSObject

@property (strong,nonatomic) NSString *scaleUserId; // 用户ID
@property (strong,nonatomic) NSString *scaleAge;    // 用户年龄
@property (strong,nonatomic) NSString *scaleHeight; // 用户身高
@property (strong,nonatomic) NSString *scaleGender; // 用户性别

@end


// 心率区间颜色
@interface FBKDeviceHRColor : NSObject

@property (strong,nonatomic) NSString *ColorOne;    // 60以下
@property (strong,nonatomic) NSString *ColorTwo;    // 60-70
@property (strong,nonatomic) NSString *ColorThree;  // 70-80
@property (strong,nonatomic) NSString *ColorFour;   // 80-90
@property (strong,nonatomic) NSString *ColorFive;   // 90-100

@end


// 加速度数据
@interface FBKParaAcceleration : NSObject

@property (assign,nonatomic) int timeStamp;
@property (assign,nonatomic) int xAxis;
@property (assign,nonatomic) int yAxis;
@property (assign,nonatomic) int zAxis;

@end

