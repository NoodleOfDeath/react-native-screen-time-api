Pod::Spec.new do |s|
  s.name         = "ReactNativeScreenTimeAPI"
  s.version      = "0.0.1-prelease"
  s.summary      = "React Native Screen Time API for Android and iOS"

  s.homepage     = "https://github.com/noodleofdeath/react-native-screen-time-api"

  s.license      = "MIT"
  s.authors      = "Thom Morgan"
  s.platform     = :ios, "16.0"

  s.source       = { :git => "https://github.com/noodleofdeath/react-native-screen-time-api.git" }

  s.source_files  = "ios/ReactNativeScreenTimeAPI/*.{h,m,swift}"

  s.dependency 'React-Core'
end
