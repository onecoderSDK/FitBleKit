/********************************************************************************
 * 文件名称：FBKBoxingSet.h
 * 内容摘要：拳击器设置类
 * 版本编号：1.0.1
 * 创建日期：2020年02月16日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    AxisTypeAX = 0,
    AxisTypeAY = 1,
    AxisTypeAZ = 2,
    AxisTypeGX = 3,
    AxisTypeGY = 4,
    AxisTypeGZ = 5,
} BoxingAxisType;

@interface FBKBoxingSet : NSObject

@property (assign,nonatomic) BoxingAxisType axisType;

@property (assign,nonatomic) BOOL isReserve;

@property (assign,nonatomic) long int lowZone;

@property (assign,nonatomic) long int hightZone;

@end


@interface FBKBoxingAxis : NSObject

@property (assign,nonatomic) double accelerationX;

@property (assign,nonatomic) double accelerationY;

@property (assign,nonatomic) double accelerationZ;

@property (assign,nonatomic) double angularX;

@property (assign,nonatomic) double angularY;

@property (assign,nonatomic) double angularZ;

@end
