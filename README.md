![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)

# BidMachine IOS MoPub HeaderBidding Sample
> **_WARNING:_**  This project contains a [ adapter submodule](https://github.com/bidmachine/BidMachine-IOS-MoPub-Adapter). Use ```git clone --recursive git@github.com:bidmachine/BidMachine-IOS-MoPub-HeaderBiddingSample.git``` to use all project files

- [Getting Started](#user-content-getting-started)
- [Initialize sdk](#user-content-initialize-sdk)
- [Banner implementation](#user-content-banner-implementation)
- [MREC implementation](#user-content-mrec-implementation)
- [Interstitial implementation](#user-content-interstitial-implementation)
- [Rewarded implementation](#user-content-rewarded-implementation)
- [Native ad implementation](#user-content-native-ad-implementation)

## Getting Started

##### Add following lines into your project Podfile

```ruby

target 'Target' do
   project 'Project.xcodeproj'
   pod 'MoPub-BidMachine-Adapters', '~> 1.7.3.0'
end
```

> **_NOTE:_** If you want to use BidMachine Header Bidding, please, also add following lines

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'MoPub-BidMachine-Adapters', '~> 1.7.3.0'
  pod "BDMAdColonyAdapter", "~> 1.7.3.0"
  pod "BDMAmazonAdapter", "~> 1.7.3.0"
  pod "BDMAppRollAdapter", "~> 1.7.3.0"
  pod "BDMCriteoAdapter", "~> 1.7.3.0"
  pod "BDMFacebookAdapter", "~> 1.7.3.0"
  pod "BDMMyTargetAdapter", "~> 1.7.3.0"
  pod "BDMSmaatoAdapter", "~> 1.7.3.0"
  pod "BDMTapjoyAdapter", "~> 1.7.3.0"
  pod "BDMVungleAdapter", "~> 1.7.3.0"
  pod "BDMPangleAdapter", "~> 1.7.3.0"
end
```

### Initialize sdk

> **_WARNING:_** Before initialize Mopub sdk you should start BM sdk. 
>  All parameters for BM sdk must be set before starting. Parameters from lineItems (mopub server params) are not used in pre bid integration

> **_NOTE:_** **storeURL** and **storeId** - are required parameters

``` objc
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

##### Yours implementation of initialization should look like this:

```objc
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

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

##### In the example below, the way to set all parameters

> **_NOTE:_** **storeId** and **storeURL** are required. The other parameters are optional.

```objc

    BDMSdkConfiguration *config = [BDMSdkConfiguration new];

    config.baseURL = [NSURL URLWithString:@"https://baseURL"];
    config.testMode = YES;
    config.targeting = BDMTargeting.new;
    config.targeting.userId = @"userId";
    config.targeting.gender = kBDMUserGenderFemale;
    config.targeting.yearOfBirth = @(1990);
    config.targeting.keywords = @"keywords";
    config.targeting.blockedCategories = @[@"bcat1", @"bcat2"];
    config.targeting.blockedAdvertisers = @[@"badv1", @"badv2"];
    config.targeting.blockedApps = @[@"bapp1", @"bapp2"];
    config.targeting.country = @"country";
    config.targeting.city = @"city";
    config.targeting.zip = @"zip";
    config.targeting.storeURL =  [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";
    config.targeting.paid = YES;
    config.targeting.storeCategory = @"storeCat";
    config.targeting.storeSubcategory = @[@"subcat1", @"subcat2"];
    config.targeting.frameworkName = BDMNativeFramework;
    config.targeting.deviceLocation = [[CLLocation alloc] initWithLatitude:1 longitude:2];
    
    BDMSdk.sharedSdk.publisherInfo = [BDMPublisherInfo new];
    BDMSdk.sharedSdk.publisherInfo.publisherId = @"pubId";
    BDMSdk.sharedSdk.publisherInfo.publisherName = @"pubName";
    BDMSdk.sharedSdk.publisherInfo.publisherDomain = @"pubdomain";
    BDMSdk.sharedSdk.publisherInfo.publisherCategories = @[@"pubcat1", @"pubcat2"];
    
    BDMSdk.sharedSdk.restrictions.coppa = YES;
    BDMSdk.sharedSdk.restrictions.subjectToGDPR = YES;
    BDMSdk.sharedSdk.restrictions.hasConsent = YES;
    BDMSdk.sharedSdk.restrictions.consentString = @"consentString";
    BDMSdk.sharedSdk.restrictions.USPrivacyString = @"usPrivacy";
    
    BDMSdk.sharedSdk.enableLogging = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

##### If you are using Header Bidding networks, then you need to set their parameters as follows

All network required fields and values types are described in BidMachine doc. ([WIKI](https://wiki.appodeal.com/display/BID/BidMachine+iOS+SDK+Documentation#BidMachineiOSSDKDocumentation-AdNetworksConfigurationsParameters)). If ad network has initialisation parameters, it should be added in root of mediation config object. Ad network ad unit specific paramters should be added in root of ad unit object.

```objc

    BDMSdkConfiguration *config = [BDMSdkConfiguration new];

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

    config.networkConfigurations = @[[BDMAdNetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
        builder.appendName(@"criteo");
        builder.appendNetworkClass(NSClassFromString(@"BDMCriteoAdNetwork"));
        builder.appendParams(@{@"publisher_id": @"XXX"});
        builder.appendAdUnit(BDMAdUnitFormatBanner320x50, @{ @"ad_unit_id": @"XXX" }, nil);
    }]];

    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

### Banner implementation

First you need to create a request and execute it to get the **local extras** and **keywords**

```objc

    self.request = [BDMBannerRequest new];
    self.request.adSize = BDMBannerAdSize320x50;
    [self.request performWithDelegate:self];

```

After polling the request, you need to get the **local extras** and **keywords**. You also need to save the request in BDMRequestStorage.

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save current request and use it in mopub auction
    [BDMRequestStorage.shared saveRequest:request];
    // Get server rounding price and other fields
    NSDictionary *extras = request.info.customParams;
    // Extras can be transformer into keywords for line item matching
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

```

Then you can create an ad mopub object and add settings to it via **local extras** and **keywords**

```objc

- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    CGSize adViewSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kMPPresetMaxAdSize90Height : kMPPresetMaxAdSize50Height;
    // Remove previous banner from superview if needed
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:@UNIT_ID];
    self.bannerView.frame = (CGRect){.size = adViewSize};
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.delegate = self;
    [self.bannerView setLocalExtras:extras];
    [self.bannerView setKeywords:keywords];
    [self.bannerView loadAdWithMaxAdSize:adViewSize];
}

```

### MREC implementation

First you need to create a request and execute it to get the **local extras** and **keywords**

```objc

    self.request = [BDMBannerRequest new];
    self.request.adSize = BDMBannerAdSize300x250;
    [self.request performWithDelegate:self];

```

After polling the request, you need to get the **local extras** and **keywords**. You also need to save the request in BDMRequestStorage.

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save current request and use it in mopub auction
    [BDMRequestStorage.shared saveRequest:request];
    // Get server rounding price and other fields
    NSDictionary *extras = request.info.customParams;
    // Extras can be transformer into keywords for line item matching
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

```

Then you can create an ad mopub object and add settings to it via **local extras** and **keywords**

```objc

- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    CGSize adViewSize = kMPPresetMaxAdSize250Height;
    // Remove previous banner from superview if needed
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:@UNIT_ID];
    self.bannerView.frame = (CGRect){.size = adViewSize};
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.delegate = self;
    [self.bannerView setLocalExtras:extras];
    [self.bannerView setKeywords:keywords];
    [self.bannerView loadAdWithMaxAdSize:adViewSize];
}

```

### Interstitial implementation

First you need to create a request and execute it to get the **local extras** and **keywords**

```objc

    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to get the **local extras** and **keywords**. You also need to save the request in BDMRequestStorage.

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save current request and use it in mopub auction
    [BDMRequestStorage.shared saveRequest:request];
    // Get server rounding price and other fields
    NSDictionary *extras = request.info.customParams;
    // Extras can be transformer into keywords for line item matching
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

```

Then you can create an ad mopub object and add settings to it via **local extras** and **keywords**

```objc
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@UNIT_ID];
    [self.interstitial setDelegate:self];
    [self.interstitial setLocalExtras:extras];
    [self.interstitial setKeywords:keywords];
    
    [self.interstitial loadAd];
}

```

### Rewarded implementation

First you need to create a request and execute it to get the **local extras** and **keywords**

```objc
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to get the **local extras** and **keywords**. You also need to save the request in BDMRequestStorage.

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save current request and use it in mopub auction
    [BDMRequestStorage.shared saveRequest:request];
    // Get server rounding price and other fields
    NSDictionary *extras = request.info.customParams;
    // Extras can be transformer into keywords for line item matching
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

```

Then you can create an ad mopub object and add settings to it via **local extras** and **keywords**

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

```

### Native ad implementation

First you need to create a request and execute it to get the **local extras** and **keywords**

```objc

    self.request = [BDMNativeAdRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to get the **local extras** and **keywords**. You also need to save the request in BDMRequestStorage.

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save current request and use it in mopub auction
    [BDMRequestStorage.shared saveRequest:request];
    // Get server rounding price and other fields
    NSDictionary *extras = request.info.customParams;
    // Extras can be transformer into keywords for line item matching
    BDMExternalAdapterKeywordsTransformer *transformer = [BDMExternalAdapterKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

```

Then you can create an ad mopub object and add settings to it via **local extras** and **keywords**

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

```
