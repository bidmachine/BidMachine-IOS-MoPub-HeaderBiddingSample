![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)

# BidMachine IOS MoPub HeaderBidding Sample
> **_WARNING:_**  This project contains a [ adapter submodule](https://github.com/bidmachine/BidMachine-IOS-MoPub-Adapter). Use ```git clone --recursive git@github.com:bidmachine/BidMachine-IOS-MoPub-HeaderBiddingSample.git``` to use all project files

- [Getting Started](#user-content-getting-started)
- [BidMachine adapter](#user-content-bidmachine-adapter)
  - [Initialize sdk](#user-content-initialize-sdk)
  - [Banner implementation](#user-content-banner-implementation)
  - [Interstitial implementation](#user-content-interstitial-implementation)
  - [Rewarded implementation](#user-content-rewarded-implementation)
  - [Native ad implementation](#user-content-native-ad-implementation)

## Getting Started

Add following lines into your project Podfile

```ruby
target 'Target' do
   project 'Project.xcodeproj'
  pod 'MoPub-BidMachine-Adapters', '~> 1.6.4'
end
```

> **_NOTE:_** If you want to use BidMachine Header Bidding, please, also add following lines

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'MoPub-BidMachine-Adapters', '~> 1.6.4'
  pod "BidMachine/Adapters"
end
```
## BidMachine adapter

### Initialize sdk

Before initialize Mopub sdk mopub should start BM sdk

``` objc
BDMSdkConfiguration *config = [BDMSdkConfiguration new];
config.testMode = YES;
[BDMSdk.sharedSdk startSessionWithSellerID:SELLER_ID configuration:config completion:nil];
```
Yours implementation of initialization should look like this:

```objc
 BDMSdkConfiguration *config = [BDMSdkConfiguration new];
 config.testMode = YES;
 [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:^{
                                      MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:@FULLSCREEN_APP_ID];
                                      sdkConfig.loggingLevel = MPBLogLevelDebug;
                                      sdkConfig.additionalNetworks = @[ BidMachineAdapterConfiguration.class ];

                                      [MoPub.sharedInstance initializeSdkWithConfiguration:sdkConfig
                                                                 completion:^{
                                                                          NSLog(@"SDK initialization complete");
                                                                        }];
                                    }];
```

### Banner implementation

Make request

```objc
self.request = [BDMBannerRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc

- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    CGSize adViewSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kMPPresetMaxAdSize90Height : kMPPresetMaxAdSize50Height;
    // Remove previous banner from superview if needed
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:@UNIT_ID];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.delegate = self;
    [self.bannerView setLocalExtras:extras];
    [self.bannerView setKeywords:keywords];
    [self.bannerView loadAdWithMaxAdSize:adViewSize];
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

```

### Interstitial implementation

Make request

```objc
self.request = [BDMInterstitialRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@UNIT_ID];
    [self.interstitial setDelegate:self];
    [self.interstitial setLocalExtras:extras];
    [self.interstitial setKeywords:keywords];
    
    [self.interstitial loadAd];
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

```

### Rewarded implementation

Make request

```objc
self.request = [BDMRewardedRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc
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

```

### Native ad implementation

Make request

```objc
self.request = [BDMNativeAdRequest new];
[self.request performWithDelegate:self];

```

Load ad object

```objc
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    self.nativeAdRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:@UNIT_ID rendererConfigurations:@[self.rendererConfiguration]];
    MPNativeAdRequestTargeting *targeting = MPNativeAdRequestTargeting.targeting;
    targeting.localExtras = extras;
    
    __weak typeof(self) weakSelf = self;
    [self.nativeAdRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (!error) {
            weakSelf.nativeAd = response;
            NSLog(@"Native ad did load");
        } else {
            NSLog(@"Native ad fail to load with error: %@", error.localizedDescription);
        }
    }];
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
```
