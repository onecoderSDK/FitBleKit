/********************************************************************************
 * 文件名称：FBKApiRunning.h
 * 内容摘要：Run API
 * 版本编号：1.0.1
 * 创建日期：2021年05月25日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"


@protocol FBKApiRunDelegate <NSObject>
- (void)realTimeRunning:(NSDictionary *)runMap andDevice:(id)bleDevice;
@end


@interface FBKApiRunning : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKApiRunDelegate> delegate;

@end
