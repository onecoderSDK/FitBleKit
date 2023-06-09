/*-****************************************************************************************
* Copyright: Technology Co., Ltd 
* File Name: FBKPPGDFUDelegate.h
* Function : PPG Api
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2021.07.09
 ******************************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKManagerController.h"
#import "FBKEnumList.h"


@protocol FBKApiPPGDFUDelegate <NSObject>

- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

- (void)bleConnectError:(id)error andDevice:(id)bleDevice;

- (void)ppgDfuProgress:(int)progress andDevice:(id)bleDevice;

- (void)ppgDfuResult:(BOOL)status andDevice:(id)bleDevice;

@end



@interface FBKApiPPGDFU : NSObject<FBKManagerControllerDelegate>

@property(assign,nonatomic)id <FBKApiPPGDFUDelegate> delegate;

@property (assign,nonatomic) BleDeviceType deviceType;

@property (strong,nonatomic) NSString *deviceId;

@property (strong,nonatomic) FBKManagerController *managerController;

@property (assign,nonatomic) BOOL isConnected;

- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType;

- (void)disconnectBleApi;

- (void)startPPGOTAForPath:(NSString *)filePath;

- (NSString *)readDeviceName;

@end
