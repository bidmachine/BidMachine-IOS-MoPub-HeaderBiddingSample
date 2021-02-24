platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

def bidmachine
  pod "BidMachine", "1.6.4"
  pod "BidMachine/Adapters"
end

def mopub 
  pod 'mopub-ios-sdk', '5.15.0'
end

target 'BidMachineSample' do
  mopub
  bidmachine

end
