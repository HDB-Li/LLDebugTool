Pod::Spec.new do |s|
  s.name             = 'LLDebugTool'
  s.version          = '1.3.9'
  s.summary          = 'LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations.'
  s.homepage         = 'https://github.com/HDB-Li/LLDebugTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HDB-Li' => 'llworkinggroup1992@gmail.com' }
  s.source           = { :git => 'https://github.com/HDB-Li/LLDebugTool.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/HDB-Li'
  s.platform         = :ios, "8.0"
  s.requires_arc     = true
  s.source_files     = "LLDebugTool/Classes/LLDebug.h"
  
  s.subspec 'Entry' do |ss|
   ss.public_header_files      = "LLDebugTool/Classes/Component/Entry/**/*.h"
   ss.source_files             = "LLDebugTool/Classes/Component/Entry/**/*.{h,m}"
   ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_ENTRY=1'}
   ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Feature' do |ss|
     ss.public_header_files      = "LLDebugTool/Classes/Component/Feature/**/*.h"
     ss.source_files             = "LLDebugTool/Classes/Component/Feature/**/*.{h,m}"
     ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_FEATURE=1'}
     ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Setting' do |ss|
     ss.public_header_files      = "LLDebugTool/Classes/Component/Setting/**/*.h"
     ss.source_files             = "LLDebugTool/Classes/Component/Setting/**/*.{h,m}"
     ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SETTING=1'}
     ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Network' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Network/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Network/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration", "CoreTelephony"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_NETWORK=1'}
    ss.dependency                 "LLDebugTool/Storage"
 end

  s.subspec 'Log' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Log/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Log/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_LOG=1'}
    ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Crash' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Crash/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Crash/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_CRASH=1'}
    ss.dependency                 "LLDebugTool/Storage"
  end

  s.subspec 'AppInfo' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/AppInfo/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/AppInfo/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_APP_INFO=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Sandbox' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Sandbox/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Sandbox/**/*.{h,m}"
    ss.frameworks               = "QuickLook", "WebKit", "AVKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SANDBOX=1'}
    ss.dependency                 "LLDebugTool/Core"
    ss.dependency                 "SSZipArchive"
  end
  
  s.subspec 'Screenshot' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Screenshot/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Screenshot/**/*.{h,m}"
    ss.frameworks               = "Photos"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SCREENSHOT=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Hierarchy' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Hierarchy/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Hierarchy/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_HIERARCHY=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Magnifier' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Magnifier/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Magnifier/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_MAGNIFIER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Ruler' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Ruler/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Ruler/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_RULER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'WidgetBorder' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/WidgetBorder/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/WidgetBorder/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_WIDGET_BORDER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Html' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Html/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Html/**/*.{h,m}"
    ss.frameworks               = "WebKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_HTML=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Location' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/Location/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/Location/**/*.{h,m}"
    ss.frameworks               = "CoreLocation", "MapKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_LOCATION=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'ShortCut' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Component/ShortCut/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Component/ShortCut/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SHORT_CUT=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  # Primary
  s.subspec 'Storage' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Storage/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Storage/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_STORAGE=1'}
    ss.dependency                 "LLDebugTool/Core"
    ss.dependency                 "FMDB", "~> 2.0"
  end
  
  # Primary
  s.subspec 'Core' do |ss|
    ss.public_header_files      = "LLDebugTool/Classes/Core/**/*.h"
    ss.source_files             = "LLDebugTool/Classes/Core/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Assets/**/*.{xib,storyboard,bundle}"
    ss.frameworks               = "Foundation", "UIKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_CORE=1'}
  end
  
end
