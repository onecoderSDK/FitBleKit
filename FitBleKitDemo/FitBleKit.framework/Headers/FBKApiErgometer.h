/********************************************************************************
 * 文件名称：FBKApiErgometer.h
 * 内容摘要：拉力计 API
 * 版本编号：1.0.1
 * 创建日期：2023年02月28日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiERGDelegate <NSObject>
- (void)realTimeErg:(NSDictionary *)ergMap andDevice:(id)bleDevice;
@end

@interface FBKApiErgometer : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKApiERGDelegate> delegate;

@end
