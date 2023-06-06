/********************************************************************************
 * 文件名称：FBKBleFunction.h
 * 内容摘要：Ble Function
 * 版本编号：1.0.1
 * 创建日期：2021年04月22日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

typedef enum {
    FunctionTypeOld = 0,   // 旧协议存储心率
    FunctionTypeNew = 1,   // 新协议存储心率
    FunctionTypeECG = 2,   // ECG
    FunctionTypeOther = 3, // 未知设备
} BleFunctionType;


@interface FBKFunction : NSObject
@property(assign, nonatomic) BleFunctionType functionType;
@property(assign, nonatomic) BOOL isHR;
@property(assign, nonatomic) BOOL isHRV;
@property(assign, nonatomic) BOOL isECG;
@property(assign, nonatomic) BOOL haveRecord;
@end


@protocol FBKBleFunctionDelegate <NSObject>
- (void)deviceFunction:(FBKFunction *)function andDevice:(id)bleDevice;
@end


@interface FBKBleFunction : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKBleFunctionDelegate> delegate;

@property(assign,nonatomic) double checkTime;

@end
