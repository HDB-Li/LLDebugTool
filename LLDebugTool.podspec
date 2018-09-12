Pod::Spec.new do |s|
  s.name                = "LLDebugTool"
  s.version             = "1.1.7-Beta"
  s.summary             = "LLDebugTool is a debugging tool for developers and testers that can help you analyze and manipulate data in non-xcode situations."
  s.homepage            = "https://github.com/HDB-Li/LLDebugTool"
  s.license             = "MIT"
  s.author              = { "HDB-Li" => "llworkinggroup@gmail.com" }
  s.social_media_url    = "https://github.com/HDB-Li"
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/HDB-Li/LLDebugTool.git", :tag => s.version }
  s.requires_arc        = true
  s.source_files	= "LLDebugTool/**/*.{h,m,swift}"
  s.resources		= "LLDebugTool/**/*.{xib,storyboard,bundle}"
  s.dependency            "FMDB"
  s.pod_target_xcconfig = { 'SWIFT_SUPPRESS_WARNINGS' => 'YES' }
  s.swift_version	= '4.0'
end
