/********************************************************************************
 * 文件名称：HeartZoneView.h
 * 内容摘要：区间信息
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "HeartZoneView.h"
#import "AppDelegate.h"

@implementation HeartZoneView{
    NSMutableArray *m_setArray;
    NSMutableArray *m_dataArray;
    UIScrollView *m_showScroll;
}

#pragma mark - ******************************* System *************************************
/*-****************************************************************************************
 * Method: viewDidLoad
 * Description: View start here
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)drawRect:(CGRect)rect {
    for (UIView *myView in self.subviews) {
        [myView removeFromSuperview];
    }
    
    m_dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.zoneArray.count; i++) {
        FBKArmBandPrivate *myPara = [self.zoneArray objectAtIndex:i];
        
        FBKArmBandPrivate *newPara = [[FBKArmBandPrivate alloc] init];
        newPara.heartZone1 = myPara.heartZone1;
        newPara.heartZone2 = myPara.heartZone2;
        newPara.showTime = myPara.showTime;
        
        [m_dataArray addObject:newPara];
    }
    
    UIButton *backgroundButton = [[UIButton alloc] init];
    backgroundButton.frame = rect;
    backgroundButton.backgroundColor = [UIColor blackColor];
    backgroundButton.alpha = 0.7;
    [self addSubview:backgroundButton];
    
    UIView *dataView = [[UIView alloc] init];
    dataView.frame = CGRectMake((rect.size.width-300.0)/2, (rect.size.height-560.0)/2, 300.0, 560.0);
    dataView.backgroundColor = [UIColor whiteColor];
    dataView.layer.cornerRadius = 10.0;
    dataView.layer.borderColor = [UIColor clearColor].CGColor;
    dataView.layer.borderWidth = 0;
    dataView.layer.masksToBounds = YES;
    [self addSubview:dataView];
    
    m_showScroll = [[UIScrollView alloc] init];
    m_showScroll.frame = CGRectMake(0.0, 20.0, 300.0, 480.0);
    m_showScroll.backgroundColor = [UIColor clearColor];
    m_showScroll.contentSize = CGSizeMake(0, 1200);
    [dataView addSubview:m_showScroll];
    
    m_setArray = [NSMutableArray arrayWithObjects:
                  @"显示模式1 - 区间一", @"显示模式1 - 区间二", @"显示模式1 - 展示时间(分钟)",
                  @"显示模式2 - 区间一", @"显示模式2 - 区间二", @"显示模式2 - 展示时间(分钟)",
                  @"显示模式3 - 区间一", @"显示模式3 - 区间二", @"显示模式3 - 展示时间(分钟)",
                  @"显示模式4 - 区间一", @"显示模式4 - 区间二", @"显示模式4 - 展示时间(分钟)",
                  @"显示模式5 - 区间一", @"显示模式5 - 区间二", @"显示模式5 - 展示时间(分钟)",
                  nil];
    [self refreshDataUi];
    
    UIView *downLine = [[UIView alloc] init];
    downLine.frame = CGRectMake(0.0, 509.0, 300.0, 1.0);;
    downLine.backgroundColor = [UIColor lightGrayColor];
    [dataView addSubview:downLine];
    
    UIView *upLine = [[UIView alloc] init];
    upLine.frame = CGRectMake(150.0, 509.0, 1.0, 50.0);;
    upLine.backgroundColor = [UIColor lightGrayColor];
    [dataView addSubview:upLine];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake(0.0, 510.0, 150.0, 50.0);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:cancelButton];
    
    UIButton *sendButton = [[UIButton alloc] init];
    sendButton.frame = CGRectMake(150.0, 510.0, 150.0, 50.0);
    sendButton.backgroundColor = [UIColor clearColor];
    [sendButton setTitle:@"保存" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [sendButton addTarget:self action:@selector(sendValue) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:sendButton];
}

- (void)refreshDataUi {
    for (UIView *myView in m_showScroll.subviews) {
        [myView removeFromSuperview];
    }
    
    double witchWidth = 80.0;
    for (int i = 0; i < m_setArray.count; i++) {
        int showRow = i / 3;
        int showIndex = i % 3;
        int showNo = 0;
        FBKArmBandPrivate *myPara = [m_dataArray objectAtIndex:showRow];
        if (showIndex == 0){
            showNo = myPara.heartZone1;
        }
        else if (showIndex == 1){
            showNo = myPara.heartZone2;
        }
        else if (showIndex == 2){
            showNo = myPara.showTime;
        }
        
        UIView *valueView = [[UIView alloc] init];
        valueView.frame = CGRectMake(0, witchWidth*i, 300.0, witchWidth);
        valueView.backgroundColor = [UIColor whiteColor];
        [m_showScroll addSubview:valueView];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.frame = CGRectMake(20.0, 0.0, 300.0-40, 20.0);
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.text = [m_setArray objectAtIndex:i];
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.textColor = [UIColor blackColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [valueView addSubview:nameLab];
        
        UIButton *valueButton = [[UIButton alloc] init];
        valueButton.tag = 900+i;
        valueButton.frame = CGRectMake(20.0, 20.0, 300.0-40, 40.0);
        valueButton.backgroundColor = [UIColor clearColor];
        valueButton.layer.cornerRadius = 4.0;
        valueButton.layer.borderColor = [UIColor grayColor].CGColor;
        valueButton.layer.borderWidth = 1;
        valueButton.layer.masksToBounds = YES;
        [valueButton addTarget:self action:@selector(editValue:) forControlEvents:UIControlEventTouchUpInside];
        [valueView addSubview:valueButton];
        
        UILabel *valueLab = [[UILabel alloc] init];
        valueLab.frame = CGRectMake(30.0, 20.0, 300.0-60, 40.0);
        valueLab.backgroundColor = [UIColor clearColor];
        valueLab.font = [UIFont systemFontOfSize:16];
        valueLab.textColor = [UIColor blackColor];
        valueLab.textAlignment = NSTextAlignmentLeft;
        valueLab.text = [NSString stringWithFormat:@"%i",showNo];
        [valueView addSubview:valueLab];
    }
}


/*-****************************************************************************************
* Method: editValue
* Description: editValue
* Parameter:
* Return Data:
******************************************************************************************/
- (void)editValue:(UIButton *)sender {
    AppDelegate *myApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int myTag = (int)sender.tag-900;
    NSString *titleString = [m_setArray objectAtIndex:myTag];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        int showRow = myTag / 3;
        int showIndex = myTag % 3;
        FBKArmBandPrivate *myPara = [self->m_dataArray objectAtIndex:showRow];
        if (showIndex == 0){
            myPara.heartZone1 = [inputField.text intValue];
        }
        else if (showIndex == 1){
            myPara.heartZone2 = [inputField.text intValue];
        }
        else if (showIndex == 2){
            myPara.showTime = [inputField.text intValue];
        }
        [self refreshDataUi];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [myApp.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


/*-****************************************************************************************
* Method: hiddenView
* Description: hiddenView
* Parameter:
* Return Data:
******************************************************************************************/
- (void)hiddenView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}


/*-****************************************************************************************
* Method: sendValue
* Description: sendValue
* Parameter:
* Return Data:
******************************************************************************************/
- (void)sendValue {
    [self hiddenView];
    [self.delegate heartZoneData:m_dataArray];
}


/*-****************************************************************************************
* Method: showRangeAlert
* Description: showRangeAlert
* Parameter:
* Return Data:
******************************************************************************************/
- (void)showRangeAlert {
    AppDelegate *myApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Punching bag sensitivity range 5~150" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [myApp.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end
