#
#  Be sure to run `pod spec lint UIModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "UIModule"
  s.version      = "0.0.1"
  s.summary      = "UI模块"

  s.description      =  'UI模块的简单封装' #详细介绍
  s.homepage     = "https://github.com/sandradd/UIModule"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' } #开源协议

  s.source           = { :git => 'https://github.com/sandradd/UIModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>' #多媒体介绍地址(项目演示地址)

  s.ios.deployment_target = '9.0'           #支持的平台及版本
  #  s.source_files = 'UIModule/**/*'

  # s.subspec 'Public' do |ss|
  # ss.source_files = 'UIModule/Public/*.{h,m}'
  # end
  s.subspec 'Base' do |ss|
  ss.source_files = 'UIModule/Develop/Base/*.{h,m}'
  end
  s.subspec 'Api' do |ss|
  ss.source_files = 'UIModule/Develop/Api/*.{h,m}'
  end
  s.subspec 'Mode' do |ss|
  ss.source_files = 'UIModule/Develop/Mode/*.{h,m}'
  ss.dependency 'UIModule/Base'
  end
  s.subspec 'View' do |ss|
  ss.source_files = 'UIModule/Develop/View/*.{h,m}'
  ss.dependency 'UIModule/Base'
  ss.dependency 'UIModule/Api'
  ss.dependency 'UIModule/Mode'
  end
  s.subspec 'Controller' do |ss|
  ss.source_files = 'UIModule/Develop/Controller/*.{h,m}'
    # ss.dependency 'UIModule/Public'
  ss.dependency 'UIModule/Base'
  ss.dependency 'UIModule/Api'
  ss.dependency 'UIModule/Mode'
  ss.dependency 'UIModule/View'
  end
  # s.resource_bundles = {                   #资源文件地址
  # 'UIModule' => ['UIModule/Assets/*.png']
  # }

  #公开头文件地址
  #  s.public_header_files = 'Pod/Classes/**/*.h'
  #所需的framework，多个用逗号隔开
  s.frameworks = 'UIKit', 'Foundation'
  #依赖关系，该项目所依赖的其他库，如果有多个需要填写多个s.dependency
  s.dependency 'Masonry'
  s.dependency 'AFNetworking'
  s.dependency 'FSCalendar', '~> 2.8.0'
  s.dependency 'SPPageMenu', '~> 2.5.3'
  s.dependency 'MBProgressHUD'
  s.dependency 'MJExtension'



  
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "sandradd" => "email@address.com" }
  # Or just: spec.author    = "sandradd"
  # spec.authors            = { "sandradd" => "email@address.com" }
  # spec.social_media_url   = "https://twitter.com/sandradd"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  #spec.source       = { :git => "https://github.com/sandradd/UIModule.git", :commit => "73b091069d21e4d85688284225a7ebfa09a18e86" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
