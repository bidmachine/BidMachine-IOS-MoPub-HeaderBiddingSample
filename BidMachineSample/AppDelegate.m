//
//  AppDelegate.m
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"

#define NATIVE_APP_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"
#define FULLSCREEN_APP_ID     "1832ce06de91424f8f81f9f5c77f7efd"
#define BANNER_APP_ID         "1832ce06de91424f8f81f9f5c77f7efd"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     __weak typeof(self) weakSelf = self;
     [self startBidMachine:^{
         [weakSelf startMoPub];
     }];
    
    return YES;
}

/// Start BidMachine session, should be called before MoPub initialisation
- (void)startBidMachine:(void(^)(void))completion {
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:completion];
}

///  Start MoPub SDK
- (void)startMoPub {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:@FULLSCREEN_APP_ID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    // Note that BidMachineAdapter should be added as additional network as BidMachineAdapterConfiguration
    sdkConfig.additionalNetworks = @[ NSClassFromString(@"BidMachineAdapterConfiguration") ];

    [MoPub.sharedInstance initializeSdkWithConfiguration:sdkConfig
                                              completion:^{
                                                  NSLog(@"SDK initialization complete");
                                              }];
}

@end
