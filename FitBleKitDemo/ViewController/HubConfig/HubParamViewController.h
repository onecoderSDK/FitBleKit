/********************************************************************************
 * 文件名称：HubParamViewController.h
 * 内容摘要：hub 参数设置
 * 版本编号：1.0.1
 * 创建日期：2018年07月05日
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol HubParamDelegate <NSObject>

- (void)hubParamResult:(NSDictionary *)setInfo isSet:(BOOL)isSetMark;

@end


@interface HubParamViewController : BaseViewController

@property(assign,nonatomic) id <HubParamDelegate> delegate;
@property(assign,nonatomic) BOOL isSetParam;
@property(strong,nonatomic) NSDictionary *hubInfo;

@end
