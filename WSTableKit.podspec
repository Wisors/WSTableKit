Pod::Spec.new do |s|
    s.name         = 'WSTableKit'
    s.version      = '0.9.0'
    s.license      = 'MIT'
    s.author       = { "Alex Nikishin" => "wisdoomer@gmail.com" }
    s.summary      = 'Simple table framework.'
    s.homepage     = 'https://github.com/Wisors/WSTableKit'
    s.source       = { :git => 'https://github.com/Wisors/WSTableKit.git', :tag => s.version }
    s.source_files = 'WSTableKit/*.{h,m}'
    s.requires_arc = true
    s.ios.deployment_target = '7.0'
end