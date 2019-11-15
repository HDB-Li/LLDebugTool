Pod::Spec.new do |s|
  s.name                = "LLDebugTool"
  s.version             = "1.3.6"
  s.summary             = "LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations."
  s.homepage            = "https://github.com/HDB-Li/LLDebugTool"
  s.license             = "MIT"
  s.author              = { "HDB-Li" => "llworkinggroup1992@gmail.com" }
  s.social_media_url    = "https://github.com/HDB-Li"
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/HDB-Li/LLDebugTool.git", :tag => s.version }
  s.requires_arc        = true
  s.public_header_files = "LLDebugTool/LLDebug.h"
  s.source_files	    = "LLDebugTool/LLDebug.h"

  s.subspec 'Network' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Network/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Network/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration", "CoreTelephony"
    ss.dependency                 "LLDebugTool/Storage"
 end

  s.subspec 'Log' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Log/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Log/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Storage"
  end
  
  s.subspec 'Crash' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Crash/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Crash/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Storage"
  end

  s.subspec 'AppInfo' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/AppInfo/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/AppInfo/**/*.{h,m}"
    ss.frameworks               = "SystemConfiguration"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Sandbox' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Sandbox/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Sandbox/**/*.{h,m}"
    ss.frameworks               = "QuickLook"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Screenshot' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Screenshot/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Screenshot/**/*.{h,m}"
    ss.frameworks               = "Photos"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Hierarchy' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Hierarchy/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Hierarchy/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Magnifier' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Magnifier/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Magnifier/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Ruler' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Ruler/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Ruler/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'WidgetBorder' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/WidgetBorder/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/WidgetBorder/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  s.subspec 'Html' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Component/Html/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Html/**/*.{h,m}"
    ss.frameworks               = "WebKit"
    ss.dependency                 "LLDebugTool/Core"
  end
  
  # Primary
  s.subspec 'Storage' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Storage/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Storage/**/*.{h,m}"
    ss.dependency                 "LLDebugTool/Core"
    ss.dependency                 "FMDB", "~> 2.0"
  end
  
  # Primary
  s.subspec 'Core' do |ss|
    ss.public_header_files      = "LLDebugTool/DebugTool/*.h", "LLDebugTool/Core/Others/**/*.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
end
