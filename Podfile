platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.7.4.0'
$MopubVersion = '~> 5.18.0'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
  pod "BDMAdColonyAdapter", $BDMVersion
  pod "BDMAmazonAdapter", $BDMVersion
  pod "BDMCriteoAdapter", $BDMVersion
  pod "BDMFacebookAdapter", $BDMVersion
  pod "BDMMyTargetAdapter", $BDMVersion
  pod "BDMSmaatoAdapter", $BDMVersion
  pod "BDMTapjoyAdapter", $BDMVersion
  pod "BDMVungleAdapter", $BDMVersion
end

def mopub 
  pod 'mopub-ios-sdk', $MopubVersion
end

target 'BidMachineSample' do
  mopub
  bidmachine

end
