/********************************************************************************
 * 文件名称：SandbagView.h
 * 内容摘要：新拳击沙袋信息
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "SandbagView.h"
#import "AppDelegate.h"

@implementation SandbagView {
    NSMutableArray *m_setArray;
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
    
    UIButton *backgroundButton = [[UIButton alloc] init];
    backgroundButton.frame = rect;
    backgroundButton.backgroundColor = [UIColor blackColor];
    backgroundButton.alpha = 0.7;
    [self addSubview:backgroundButton];
    
    UIView *dataView = [[UIView alloc] init];
    dataView.frame = CGRectMake((rect.size.width-300.0)/2, (rect.size.height-570.0)/2, 300.0, 570.0);
    dataView.backgroundColor = [UIColor whiteColor];
    dataView.layer.cornerRadius = 10.0;
    dataView.layer.borderColor = [UIColor clearColor].CGColor;
    dataView.layer.borderWidth = 0;
    dataView.layer.masksToBounds = YES;
    [self addSubview:dataView];
    
    double witchWidth = 70.0;
    m_setArray = [NSMutableArray arrayWithObjects:@"Punching bag a(mm)", @"Punching bag b(mm)", @"Punching bag c(mm)", @"Punching bag weight(kg)", @"Punching bag type", @"Power sensitivity (5~150)", @"Frequency sensitivity (1~20)", nil];
    for (int i = 0; i < m_setArray.count; i++) {
        UIView *valueView = [[UIView alloc] init];
        valueView.frame = CGRectMake(0, 20.0+witchWidth*i, 300.0, witchWidth);
        valueView.backgroundColor = [UIColor whiteColor];
        [dataView addSubview:valueView];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.frame = CGRectMake(20.0, 0.0, 300.0-40, 20.0);
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.text = [m_setArray objectAtIndex:i];
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.textColor = [UIColor blackColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [valueView addSubview:nameLab];
        
        UIButton *valueButton = [[UIButton alloc] init];
        valueButton.tag = 500+i;
        valueButton.frame = CGRectMake(20.0, 20.0, 300.0-40, 30.0);
        valueButton.backgroundColor = [UIColor clearColor];
        valueButton.layer.cornerRadius = 4.0;
        valueButton.layer.borderColor = [UIColor grayColor].CGColor;
        valueButton.layer.borderWidth = 1;
        valueButton.layer.masksToBounds = YES;
        [valueButton addTarget:self action:@selector(editValue:) forControlEvents:UIControlEventTouchUpInside];
        [valueView addSubview:valueButton];
        
        UILabel *valueLab = [[UILabel alloc] init];
        valueLab.frame = CGRectMake(30.0, 20.0, 300.0-60, 30.0);
        valueLab.backgroundColor = [UIColor clearColor];
        valueLab.font = [UIFont systemFontOfSize:16];
        valueLab.textColor = [UIColor blackColor];
        valueLab.textAlignment = NSTextAlignmentLeft;
        [valueView addSubview:valueLab];
        
        if (i == 0) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.sandbagLength];
        }
        else if (i == 1) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.sandbagWidth];
        }
        else if (i == 2) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.sandbagHight];
        }
        else if (i == 3) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.sandbagWeight];
        }
        else if (i == 4) {
            if (self.sandbag.sandbagType == 0) {
                valueLab.text = @"Hang";
            }
            else {
                valueLab.text = @"Stand";
            }
        }
        else if (i == 5) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.powerSensitivity];
        }
        else if (i == 6) {
            valueLab.text = [NSString stringWithFormat:@"%i",self.sandbag.rateSensitivity];
        }
    }
    
    UIView *downLine = [[UIView alloc] init];
    downLine.frame = CGRectMake(0.0, 519.0, 300.0, 1.0);;
    downLine.backgroundColor = [UIColor lightGrayColor];
    [dataView addSubview:downLine];
    
    UIView *upLine = [[UIView alloc] init];
    upLine.frame = CGRectMake(150.0, 519.0, 1.0, 50.0);;
    upLine.backgroundColor = [UIColor lightGrayColor];
    [dataView addSubview:upLine];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake(0.0, 520.0, 150.0, 50.0);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:cancelButton];
    
    UIButton *sendButton = [[UIButton alloc] init];
    sendButton.frame = CGRectMake(150.0, 520.0, 150.0, 50.0);
    sendButton.backgroundColor = [UIColor clearColor];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [sendButton addTarget:self action:@selector(sendValue) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:sendButton];
    
}


/*-****************************************************************************************
* Method: editValue
* Description: editValue
* Parameter:
* Return Data:
******************************************************************************************/
- (void)editValue:(UIButton *)sender {
    AppDelegate *myApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int myTag = (int)sender.tag-500;
    NSString *titleString = [m_setArray objectAtIndex:myTag];
    
    if (myTag == 4) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *lineAction = [UIAlertAction actionWithTitle:@"Hang" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sandbag.sandbagType = 0;
            [self setNeedsDisplay];
        }];
        UIAlertAction *upAction = [UIAlertAction actionWithTitle:@"Stand" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sandbag.sandbagType = 1;
            [self setNeedsDisplay];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:lineAction];
        [alertController addAction:upAction];
        [alertController addAction:cancelAction];
        [myApp.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        if (myTag == 0) {
            self.sandbag.sandbagLength = [inputField.text intValue];
        }
        else if (myTag == 1) {
            self.sandbag.sandbagWidth = [inputField.text intValue];
        }
        else if (myTag == 2) {
            self.sandbag.sandbagHight = [inputField.text intValue];
        }
        else if (myTag == 3) {
            self.sandbag.sandbagWeight = [inputField.text intValue];
        }
        else if (myTag == 5) {
            int valueNo = [inputField.text intValue];
            if (valueNo < 5 || valueNo > 150) {
                [self showRangeAlert:0];
                return;
            }
            self.sandbag.powerSensitivity = valueNo;
        }
        else if (myTag ==6) {
            int valueNo = [inputField.text intValue];
            if (valueNo < 1 || valueNo > 20) {
                [self showRangeAlert:1];
                return;
            }
            self.sandbag.rateSensitivity = valueNo;
        }
        [self setNeedsDisplay];
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
    [self.delegate sendSandbag:self.sandbag];
}


/*-****************************************************************************************
* Method: showRangeAlert
* Description: showRangeAlert
* Parameter:
* Return Data:
******************************************************************************************/
- (void)showRangeAlert:(int)type {
    AppDelegate *myApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *alertString = @"Power sensitivity range 5~150";
    if (type == 1) {
        alertString = @"Frequency sensitivity range 1~20";
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [myApp.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end
