#
#  Be sure to run `pod spec lint DSQRCodeScan.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DSQRCodeScan"
  s.version      = "1.0.1"
  s.summary      = "DSQRCodeScan."
  s.description  = <<-DESC
                    二维码扫描和从图片中解析二维码
                   DESC

  s.homepage     = "http://linfeng1009.gitcafe.io"  

  s.license      = "MIT"
  s.author       = { "DaShen" => "1057105719@qq.com" }
  
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source = { :git => "https://github.com/ludaye123/DSQRCodeScan.git", :tag => "1.0.1" }

  s.source_files  = "QRCodeScaningDemo/QRCodeScaningDemo", "QRCodeScaningDemo/QRCodeScaningDemo/QRCodeScan/**/*.{h,m}"

  s.resource_bundles = {
    'DSQRCodeScan' => 'QRCodeScan.bundle'
  }

   s.frameworks = 'Foundation', 'UIKit','CoreImage','ImageIO'
   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
