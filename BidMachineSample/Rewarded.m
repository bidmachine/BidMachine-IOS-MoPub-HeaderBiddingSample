//
//  Rewarded.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

#define UNIT_ID         "b94009cbb6b7441eb097142f1cb5e642"

@interface Rewarded ()<BDMRequestDelegate, MPRewardedAdsDelegate>

@property (nonatomic, strong) BDMRewardedRequest *request;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [MPRewardedAds presentRewardedAdForAdUnitID:@UNIT_ID fromViewController:self withReward:nil];
}

#pragma mark - MoPub

/// Invoke MPRewardedVideo load ad method
/// pass keywords for matching with MoPub line items ad units
/// and starts MoPub mediation
/// @param keywords keywords BidMachine adapter defined keywords
/// for matching line item
/// @param extras extras BidMachine adapter defined extrass
/// for matching pending request with recieved line item
- (void)loadMoPubAdWithKeywords:(NSString *)keywords extras:(NSDictionary *)extras {
    [MPRewardedAds setDelegate:self forAdUnitId:@UNIT_ID];
    [MPRewardedAds loadRewardedAdWithAdUnitID:@UNIT_ID
                                     keywords:keywords
                             userDataKeywords:nil
                                   customerId:nil
                            mediationSettings:nil
                                  localExtras:extras];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BDMFetcher.shared fetchParamsFromRequest:request];
    // Extras can be transformer into keywords for line item matching
    // by use BDMExternalAdapterKeywordsTransformer
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
}

- (void)requestDidExpire:(BDMRequest *)request {}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidReceiveAd");
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewarded:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)rewardedAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidExpired");
}

- (void)rewardedAdDidFailToShowForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewardedAdDidFailToShowForAdUnitID: %@", [error localizedDescription]);
}

- (void)rewardedAdWillPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdWillPresentForAdUnitID");
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdDidPresentForAdUnitID");
}

- (void)rewardedAdWillDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdWillDismissForAdUnitID");
}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdDidDismissForAdUnitID");
}

- (void)rewardedAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdDidReceiveTapEventForAdUnitID");
}

- (void)rewardedAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdWillLeaveApplicationForAdUnitID");
}

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    NSLog(@"Reward received with currency %@ , amount %lf", reward.currencyType, [reward.amount doubleValue]);
}

- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData {
    NSLog(@"didTrackImpressionWithAdUnitID");
}
@end
