/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ChooseTabView.h
* Function : Choose Tab
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.03.11
******************************************************************************************/

#import <UIKit/UIKit.h>

@protocol ChooseTabViewDelegate <NSObject>
- (void)chooseTabIndex:(int)index withView:(id)view;
@end

@interface ChooseTabView : UIView

@property(assign,nonatomic)id<ChooseTabViewDelegate> delegate;

@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) int chooseNo;

@end
