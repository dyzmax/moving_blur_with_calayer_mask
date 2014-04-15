//
//  BTAppDelegate.m
//  BlurWithTimerAndMaskTest
//
//  Created by Lukasz Indyk on 4/14/14.
//  Copyright (c) 2014 Lukasz Indyk. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTCodeVC.h"

@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    BTCodeVC *vc = [[BTCodeVC alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
