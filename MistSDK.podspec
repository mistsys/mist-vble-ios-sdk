Pod::Spec.new do |s|
    s.name                  = "MistSDK"
    s.version               = "4.0.0"
    s.summary               = "Mist Indoor Location SDK for iOS"
    s.homepage              = "https://github.com/mistsys/mist-vble-ios-sdk"
    s.license               = { :type => 'Copyright', :file => 'LICENSE' }
    s.author                = { "Mist Systems" => "sdksupport@mist.com" }
    s.source                = { :git => "https://github.com/mistsys/mist-vble-ios-sdk.git", :tag => '4.0.0' }
    s.vendored_frameworks   = "Sources/*.xcframework"
    s.swift_version         = '5.7'
    s.ios.deployment_target = '14.0'
    s.requires_arc          = true
end
