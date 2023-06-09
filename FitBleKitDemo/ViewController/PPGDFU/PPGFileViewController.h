/*-****************************************************************************************
* Copyright: Technology Co., Ltd
* File Name: PPGFileViewController.h
* Function : PPG DFU File
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.07.12
 ******************************************************************************************/

#import "BaseViewController.h"

@protocol FileViewDelegate <NSObject>
- (void)postFile:(NSString *)fileName;
@end

@interface PPGFileViewController : BaseViewController

@property(assign,nonatomic) id <FileViewDelegate> delegate;

@end
