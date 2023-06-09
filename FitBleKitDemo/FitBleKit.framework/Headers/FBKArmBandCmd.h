/*-***********************************************************************************
* File Name: FBKArmBandCmd.h
* Function : Arm Band Cmd
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2020.05.07
*************************************************************************************/
#import <Foundation/Foundation.h>
#import "FBKArmBandPara.h"

@interface FBKArmBandCmd : NSObject

- (NSData *)getAgeNumber;

- (NSData *)setAgeNumber:(int)ageNumber;

- (NSData *)setShock:(int)shockNumber;

- (NSData *)getShock;

- (NSData *)closeShock;

- (NSData *)setMaxInterval:(int)maxNumber;

- (NSData *)getMaxInterval;

- (NSData *)setLightSwitch:(BOOL)isOpen;

- (NSData *)getLightSwitch;

- (NSData *)getSettingInfo;

- (NSData *)setColorShock:(BOOL)isOpen;

- (NSData *)colorInterval:(int)intervalNumber;

- (NSData *)clearRecord;

- (NSData *)getMacAddressData;

- (NSData *)getVersion;

- (NSData *)enterOTAMode;

- (NSData *)dataFrequency:(int)frequency;

// 智云医康定制指令
- (NSData *)setPrivateFiveZone:(NSArray *)zoneArray;

- (NSData *)openPrivateShow;

- (NSData *)closePrivateShow;

@end
