//
//  AlertComponent.h
//  DynamicsDemo
//
//  Created by muhammad abed el razek on 6/28/14.
//  Copyright (c) 2014 aboelbisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertComponent : NSObject

- (id)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitles:(NSArray *)buttonTitles andTargetView:(UIView *)targetView;

- (void)showAlertViewWithSelectionHandler:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))handler;


@end
