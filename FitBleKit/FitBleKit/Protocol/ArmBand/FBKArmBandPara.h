/*-***********************************************************************************
* File Name: FBKArmBandPara.h
* Function : Arm Band Para
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2022.10.28
*************************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKArmBandPara : NSObject

@end


@interface FBKArmBandPrivate : NSObject

@property (assign, nonatomic) int heartZone1; // 区间1

@property (assign, nonatomic) int heartZone2; // 区间2

@property (assign, nonatomic) int showTime; // 展示时间，单位分钟

@end
