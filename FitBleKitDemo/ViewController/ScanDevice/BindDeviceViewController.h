/********************************************************************************
 * 文件名称：BindDeviceViewController.h
 * 内容摘要：蓝牙选择列表
 * 版本编号：1.0.1
 * 创建日期：2017年03月02日
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "DeviceClass.h"
#import "BaseViewController.h"

@protocol DeviceIdDelegate <NSObject>

- (void)getDeviceId:(NSArray *)deviceList;

@end

@interface BindDeviceViewController : BaseViewController

@property(assign,nonatomic) id <DeviceIdDelegate> delegate;
@property(assign,nonatomic) BleDeviceType scanDeviceType;

@end
