//
//  AlertFunc.m
//  used only above IOS 5.0 SDK
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_AlertFunc.h"

UIAlertView *SimpleAlert(UIAlertViewStyle style, NSString *title, NSString *message, NSInteger tag, id delegate, NSString *cancel, NSString *ok)
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    alert.alertViewStyle = style;
    alert.tag = tag;
	[alert show];
    return alert;
}

UIAlertView *ActivityIndicatiorAlert(NSString *message, NSInteger tag, id delegate)
{
	//output a login msg
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
    
    alert.tag = tag;
    
	[alert show];
	
	//Adjust the indicator so it is up a few pixels from the bottom of the alert
	int x = alert.bounds.size.width/2;
	int y = alert.bounds.size.height-50;
	
    if (x == 0 || y == -50) return nil;
	
    __autoreleasing	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	indicator.center = CGPointMake(x, y);
	[indicator startAnimating];
	[alert addSubview:indicator];
    
	return alert;
}

UIAlertView *AlertSetString(NSString *title, NSString *cancel, NSString *ok, NSString *set, NSInteger tag, id delegate, SEL selector){
	__strong UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"\r\r" delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    
    alert.tag = tag;
    
	[alert show];
	
	int x = alert.bounds.size.width;
	int y = alert.bounds.size.height;
	
	if (x == 0 || y == 0){
        alert = nil;
        return nil;
    }
    
	UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(x*0.04, y-110, x*0.91, 25)];
	myTextField.text = set;
    
	[myTextField addTarget:delegate action:selector forControlEvents:UIControlEventEditingDidEndOnExit];
	//[alert setTransform:myTransform];
	myTextField.tag= 100;
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:myTextField];
	return alert;
}

UIDatePicker *SetDate(UIView *view, NSInteger tag, id delegate, UIInterfaceOrientation orientation)
{
	NSString *title = UIDeviceOrientationIsLandscape(orientation)?@"\n\n\n\n\n\n\n\n\n":@"\n\n\n\n\n\n\n\n\n\n\n";
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:delegate
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    sheet.tag = tag;
	
	[sheet showInView:view];
	
    __autoreleasing	UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:sheet.bounds];
	datePicker.tag = 101;
	[sheet addSubview:datePicker];
	
    return datePicker;
}
