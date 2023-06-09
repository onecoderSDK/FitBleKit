/********************************************************************************
 * 文件名称：HeartZoneView.h
 * 内容摘要：区间信息
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "ShowTools.h"

@protocol HeartZoneDelegate <NSObject>
- (void)heartZoneData:(NSMutableArray *)paraArray;
@end


@interface HeartZoneView : UIView

@property(assign,nonatomic)id <HeartZoneDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *zoneArray;

@end
