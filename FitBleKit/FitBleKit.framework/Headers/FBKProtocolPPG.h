/*-****************************************************************************************
* Copyright: Technology Co., Ltd 
* File Name: FBKProtocolPPG.h
* Function : PPG Ble Protocol
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2021.07.09
 ******************************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKPPGCmd.h"

typedef enum {
    PPGDFUProgress = 0,
    PPGDFUResult = 1,
} PPGResultNumber;

@interface FBKProtocolPPG : FBKProtocolBase

@end
