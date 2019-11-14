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
  s.public_header_files = "LLDebugTool/LLDebug.h", "LLDebugTool/DebugTool/*.h"
  s.source_files	    = "LLDebugTool/**/*.{h,m}"
  s.resources		    = "LLDebugTool/**/*.{xib,storyboard,bundle}"
  s.frameworks          = "Foundation", "UIKit", "Photos", "SystemConfiguration", "CoreTelephony", "QuickLook", "WebKit"
  s.dependency            "FMDB", "~> 2.0"

  s.subspec 'Network' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Network/LLNetwork.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Network/**/*.{h,m}", "LLDebugTool/Core/Storage/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Network/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Storage/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
   ss.dependency                 "FMDB", "~> 2.0"
 end

  s.subspec 'Log' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Log/LLLog.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Log/**/*.{h,m}", "LLDebugTool/Core/Storage/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Log/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Storage/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
    ss.dependency                 "FMDB", "~> 2.0"
  end
  
  s.subspec 'Crash' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Crash/LLCrash.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Crash/**/*.{h,m}", "LLDebugTool/Core/Storage/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Crash/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Storage/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
    ss.dependency                 "FMDB", "~> 2.0"
  end

  s.subspec 'AppInfo' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/AppInfo/LLAppInfo.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/AppInfo/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/AppInfo/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'Sandbox' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Sandbox/LLSandbox.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Sandbox/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Sandbox/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'Screenshot' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Screenshot/LLScreenshot.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Screenshot/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Screenshot/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'Hierarchy' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Hierarchy/LLHierarchy.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Hierarchy/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Hierarchy/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'Magnifier' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Magnifier/LLMagnifier.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Magnifier/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Magnifier/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'Ruler' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/Ruler/LLRuler.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/Ruler/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Ruler/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
  s.subspec 'WidgetBorder' do |ss|
    ss.public_header_files      = "LLDebugTool/Core/Component/WidgetBorder/LLWidgetBorder.h"
    ss.source_files             = "LLDebugTool/DebugTool/*.{h,m}", "LLDebugTool/Core/Component/WidgetBorder/**/*.{h,m}", "LLDebugTool/Core/Others/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/WidgetBorder/**/*.{xib,storyboard,bundle}", "LLDebugTool/Core/Others/**/*.{xib,storyboard,bundle}"
  end
  
end
