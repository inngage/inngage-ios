Pod::Spec.new do |s|
  s.name = 'Inngage'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'Inngage library'
  s.homepage = 'https://inngage.readme.io/docs/tutorial-de-integracao-ios'
  s.authors = { 'Augusto Reis' => 'reis-augusto@hotmail.com' }
  s.source = { :git => 'https://github.com/inngage/inngage-ios.git', :tag => s.version }

  s.ios.deployment_target  = '11.0'
  s.default_subspec = 'Core'
  s.requires_arc = true

  s.subspec 'Shared' do |sp|
    sp.frameworks = "Foundation", "UIKit", "WebKit"
    sp.source_files = 'InngageIos/Shared/**/*.{h,m}'
    sp.resources = ['InngageIos/**/*.xib']
  end

  s.subspec 'Core' do |sp|
    sp.frameworks = "Foundation", "UIKit", "WebKit"
    sp.source_files = 'InngageIos/Core/**/*.{h,m}'
    sp.resources = ['InngageIos/**/*.xib']
    sp.dependency 'Inngage/Shared'
  end

  s.subspec 'NotificationExtension' do |sp|
    sp.frameworks = 'Foundation', 'UIKit'
    sp.weak_frameworks  = 'UserNotifications', 'UserNotificationsUI'
    sp.source_files = 'InngageIos/NotificationExtension/**/*.{h,m}'
    sp.dependency 'Inngage/Shared'
    sp.dependency 'Inngage/Core'
  end

end

