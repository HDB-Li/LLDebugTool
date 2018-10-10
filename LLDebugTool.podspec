Pod::Spec.new do |s|
  s.name                = "LLDebugTool"
  s.version             = "1.2.1"
  s.summary             = "LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations."
  s.homepage            = "https://github.com/HDB-Li/LLDebugTool"
  s.license             = "MIT"
  s.author              = { "HDB-Li" => "llworkinggroup1992@gmail.com" }
  s.social_media_url    = "https://github.com/HDB-Li"
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/HDB-Li/LLDebugTool.git", :tag => s.version }
  s.requires_arc        = true
  s.public_header_files = "LLDebugTool/**/*.h"
  s.source_files	    = "LLDebugTool/**/*.{h,m}"
  s.resources		    = "LLDebugTool/**/*.{xib,storyboard,bundle}"
#  s.dependency            "FMDB"

  s.subspec 'Network' do |ss|
    ss.source_files             = "LLDebugTool/Components/Network/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Network/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/Network/**/*.h"
    ss.dependency                 "LLDebugTool/StorageManager"
  end

  s.subspec 'Log' do |ss|
    ss.source_files             = "LLDebugTool/Components/Log/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Log/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/Log/**/*.h"
    ss.dependency                 "LLDebugTool/StorageManager"
  end

  s.subspec 'Crash' do |ss|
    ss.source_files             = "LLDebugTool/Components/Crash/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Crash/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/Crash/**/*.h"
    ss.dependency                 "LLDebugTool/StorageManager"
  end

  s.subspec 'AppInfo' do |ss|
    ss.source_files             = "LLDebugTool/Components/AppInfo/**/*.{h,m}"
#    ss.resources                = "LLDebugTool/Components/AppInfo/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/AppInfo/**/*.h"
    ss.dependency                 "LLDebugTool/General"
  end

  s.subspec 'Sandbox' do |ss|
    ss.source_files             = "LLDebugTool/Components/Sandbox/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/Sandbox/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/Sandbox/**/*.h"
    ss.dependency                 "LLDebugTool/General"
  end

  s.subspec 'Screenshot' do |ss|
    ss.source_files             = "LLDebugTool/Components/Screenshot/**/*.{h,m}"
#    ss.resources                = "LLDebugTool/Components/Screenshot/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/Screenshot/**/*.h"
    ss.dependency                 "LLDebugTool/General"
  end

  s.subspec 'StorageManager' do |ss|
    ss.source_files             = "LLDebugTool/Components/StorageManager/**/*.{h,m}"
#    ss.resources               = "LLDebugTool/Components/StorageManager/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Components/StorageManager/**/*.h"
    ss.dependency                 "FMDB"
    ss.dependency                 "LLDebugTool/General"
  end

  s.subspec 'General' do |ss|
    ss.source_files             = "LLDebugTool/Config/*.{h,m}" , "LLDebugTool/Components/General/**/*.{h,m}"
    ss.resources                = "LLDebugTool/Components/General/**/*.{xib,storyboard,bundle}"
    ss.public_header_files      = "LLDebugTool/Config/*.h" , "LLDebugTool/Components/General/**/*.h"
  end

end
