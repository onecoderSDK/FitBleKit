/********************************************************************************
 * 文件名称：FBKApiKettleBell.h
 * 内容摘要：壶铃API
 * 版本编号：1.0.1
 * 创建日期：2018年04月02日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiKettleBellDelegate <NSObject>

// 硬件版本号
- (void)kettleBellVersion:(NSString *)version andDevice:(id)bleDevice;

// 大数据
- (void)kettleBellDetailData:(NSDictionary *)dataDic andDevice:(id)bleDevice;

@end


@interface FBKApiKettleBell : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiKettleBellDelegate> delegate;

// 设置时间
- (void)setKettleBellTime;

// 获取所有历史数据
- (void)getKettleBellTotalHistory;

@end
