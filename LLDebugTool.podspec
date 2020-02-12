Pod::Spec.new do |s|
  s.name                = "LLDebugTool"
  s.version             = "1.3.8"
  s.summary             = "LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations."
  s.homepage            = "https://github.com/HDB-Li/LLDebugTool"
  s.license             = "MIT"
  s.author              = { "HDB-Li" => "llworkinggroup1992@gmail.com" }
  s.social_media_url    = "https://github.com/HDB-Li"
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/HDB-Li/LLDebugTool.git", :tag => s.version }
  s.requires_arc        = true

  s.subspec 'Network' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Network/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Network/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration", "CoreTelephony"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_NETWORK=1'}
    ss.dependency                 "LLDebugTool/Storage"
 end

  s.subspec 'Log' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Log/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Log/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_LOG=1'}
    ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Crash' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Crash/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Crash/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_CRASH=1'}
    ss.dependency                 "LLDebugTool/Storage"
  end

  s.subspec 'AppInfo' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/AppInfo/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/AppInfo/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_APP_INFO=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Sandbox' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Sandbox/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Sandbox/**/*.{h,m}"
    ss.frameworks               = "QuickLook", "WebKit", "AVKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SANDBOX=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Screenshot' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Screenshot/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Screenshot/**/*.{h,m}"
    ss.frameworks               = "Photos"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SCREENSHOT=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Hierarchy' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Hierarchy/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Hierarchy/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_HIERARCHY=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Magnifier' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Magnifier/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Magnifier/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_MAGNIFIER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Ruler' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Ruler/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Ruler/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_RULER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'WidgetBorder' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/WidgetBorder/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/WidgetBorder/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_WIDGET_BORDER=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Html' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Html/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Html/**/*.{h,m}"
    ss.frameworks               = "WebKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_HTML=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Location' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Location/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/Location/**/*.{h,m}"
    ss.frameworks               = "CoreLocation", "MapKit"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_LOCATION=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'ShortCut' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/ShortCut/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Component/ShortCut/**/*.{h,m}"
    ss.pod_target_xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LLDEBUGTOOL_SHORT_CUT=1'}
    ss.dependency                 "LLDebugTool/Core"
  end
  
  # Primary
  s.subspec 'Storage' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Storage/**/*.h"
    ss.source_files             = "LLDebugTool/Core/Storage/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
    ss.dependency                 "FMDB", "~> 2.0"
  end
  
  # Primary
  s.subspec 'Core' do |ss|
    ss.public_header_files      = "LLDebugTool/LLDebug.h", "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Others/**/*.h"
    ss.source_files             = "LLDebugTool/LLDebug.h", "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
end
