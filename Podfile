# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

def shared_pods
  pod 'ObjectMapper', '3.3.0'
  pod 'Alamofire', '4.7.3'
  pod 'SwiftLint'
end

#'3.2.0'

target 'WePeiYang' do
  # Pods for WePeiYang
  shared_pods
  
  #  pod 'DynamicBlurView', '2.0.2'
  pod 'SnapKit', '4.0.1'
  pod 'SDWebImage', '4.4.2'
  pod 'Charts', '3.0.2'
  pod 'MJRefresh', '3.1.15.7'
  pod 'JBChartView', '3.0.13'
  pod 'WMPageController', '2.3.0'
  pod 'IGIdenticon', '0.5.0'
  pod 'SwiftMessages', '4.1.0'
  pod 'PopupDialog', '0.7.1'
  
end

  
target 'WePeiYangWidget' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Charts' then
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end
end
