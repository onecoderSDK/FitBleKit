/********************************************************************************
 * 文件名称：SandbagView.h
 * 内容摘要：新拳击沙袋信息
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "ShowTools.h"

@protocol SandbagViewDelegate <NSObject>
- (void)sendSandbag:(FBKFightSandbag *)mySandbag;
@end

@interface SandbagView : UIView

@property(assign,nonatomic)id <SandbagViewDelegate> delegate;

@property (strong, nonatomic) FBKFightSandbag *sandbag;

@end
