# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

source 'https://github.com/Mapxus/mapxusSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'LLDebugToolDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for LLDebugToolDemo
  pod 'MapxusMapSDK', '6.8.0'
  pod 'MapxusComponentKit', '6.8.0'
  
  # Request
  pod 'FMDB','~> 2.0',:inhibit_warnings => true

  # Only for demo
  pod 'AFNetworking'

  target 'LLDebugToolDemoTests' do
    inherit! :search_paths
    # Pods for testing
    
    # Request
    pod 'FMDB'
    
    # Only for demo
    pod 'AFNetworking'
    
  end

  target 'LLDebugToolDemoUITests' do
    inherit! :search_paths
    # Pods for testing
    
    # Request
    pod 'FMDB'
    
    # Only for demo
    pod 'AFNetworking'
    
  end

end
