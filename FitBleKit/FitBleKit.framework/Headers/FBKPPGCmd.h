/*-****************************************************************************************
* Copyright: Technology Co., Ltd 
* File Name: FBKPPGCmd.h
* Function : PPG Ble Command
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2021.07.09
 ******************************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    PPGDFUFilePath = 0,
    PPGStartDFU = 1,
} PPGCmdNumber;

@interface FBKPPGCmd : NSObject

- (NSData *)ppgEnterOtaMode;

- (NSData *)ppgDFUComplete;

- (NSArray *)ppgDFUForFilePath:(NSString *)filePath withMTU:(int)MTU;

@end
