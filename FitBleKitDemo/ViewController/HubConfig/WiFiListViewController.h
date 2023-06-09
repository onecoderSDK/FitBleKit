/********************************************************************************
 * 文件名称：WiFiListViewController.h
 * 内容摘要：WiFi 列表
 * 版本编号：1.0.1
 * 创建日期：2018年07月05日
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WiFiListDelegate <NSObject>

- (void)chooseWiFiStaInfo:(NSDictionary *)staInfo;

@end


@interface WiFiListViewController : BaseViewController

@property(assign,nonatomic) id <WiFiListDelegate> delegate;
@property(strong,nonatomic) NSArray *scanWifiList;

@end
