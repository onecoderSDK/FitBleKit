/********************************************************************************
 * 文件名称：FBKApiBikeComputer.h
 * 内容摘要：码表API
 * 版本编号：1.0.1
 * 创建日期：2018年02月02日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

typedef enum{
    BikeComputerDeleteFit = 0,    // 删除fit文件
    BikeComputerDeleteFitHistory, // 删除fit文件对应的历史
    BikeComputerDeleteFitTotal,   // 删除前面两项
}BikeComputerDeleteType;


@protocol FBKApiBikeComputerDelegate <NSObject>

// 硬件版本号
- (void)getDeviceVersion:(NSString *)version andDevice:(id)bleDevice;

// 文件名字列表
- (void)getNameList:(NSArray *)nameList andDevice:(id)bleDevice;

// 文件数据
- (void)getFitFileData:(id)dataInfo andDevice:(id)bleDevice;

@end


@interface FBKApiBikeComputer : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiBikeComputerDelegate> delegate;

// 设置时间
- (void)setUtc;

// 获取fit文件名列表
- (void)getFitNameList;

// 获取fit文件
- (void)getFitFile:(NSString *)fitFileName;

// 删除fit文件
- (void)deleteFitFile:(NSString *)fitFileName andDeleteType:(BikeComputerDeleteType)type;

// 设置码表时区
- (void)setFitTimeZone:(int)timeZone;

@end

