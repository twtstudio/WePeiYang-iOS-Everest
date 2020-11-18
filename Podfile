# Uncomment the next line to define a global platform for your project
post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end

#platform :ios, '10.0'
use_frameworks!

def shared_pods
  pod 'ObjectMapper', '3.3.0'
  pod 'Alamofire', '4.7.3'
  pod 'SwiftLint', '0.27.0'
  pod 'KeychainAccess', '3.1.2'
  pod 'QQ_MTA'
end

#'3.2.0'

target 'WePeiYang' do
  # Pods for WePeiYang
  shared_pods
  
#pod 'DynamicBlurView', '2.0.2'
  pod 'SnapKit', '4.0.1'
  pod 'SDWebImage', '4.4.2'
  pod 'Charts', '3.6.0'
  pod 'MJRefresh', '3.1.15.7'
  pod 'JBChartView', '3.0.13'
  pod 'WMPageController', '2.3.0'
  pod 'IGIdenticon', '0.7'
  pod 'SwiftMessages', '8.0.2'
  pod 'PopupDialog', '1.1.1'
  pod 'Floaty', '4.2.0'
  pod 'SKPhotoBrowser', '6.1.0'
 # pod 'lottie-ios'
end

  
target 'WePeiYangWidget' do
  shared_pods
end
