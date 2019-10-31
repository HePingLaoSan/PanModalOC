//
//  AppDelegate.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/23.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanModalPresentationDelegateImp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) PanModalPresentationDelegateImp *imp;

@end

