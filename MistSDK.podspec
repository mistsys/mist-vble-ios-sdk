Pod::Spec.new do |s|
    s.name         = "MistSDK"
    s.version      = "2.0.8-beta.1"
    s.summary      = "MistSDK: MistSDK Framework"
    s.description  = "Mist SDK"
    s.homepage     = "https://github.com/mistsys/mist-vble-ios-sdk"
    s.license = { :type => 'Copyright', :text => 'Copyright 2023 by Mist Systems Inc. All rights reserved.' }
    s.author             = { "Mist Systems" => "sdksupport@mist.com" }
    s.source       = { :git => "https://github.com/mistsys/mist-vble-ios-sdk.git", :tag => "#{s.version}" }
    s.vendored_frameworks = "Sources/*.xcframework"
    s.swift_version = "5.7"
    s.platform = :ios, "14.0"
    s.ios.deployment_target  = '14.0'
    s.requires_arc = true
end
