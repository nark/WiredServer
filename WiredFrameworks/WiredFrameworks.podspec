#
#  Be sure to run `pod spec lint WiredFrameworks.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "WiredFrameworks"
  s.version      = "0.0.2"
  s.summary      = "WiredFrameworks is a set of libraries and frameworks for Mac OS X and iOS."
  s.description  = <<-DESC
WiredFrameworks is a set of libraries and frameworks for Mac OS X and iOS.
DESC
  
  s.homepage     = "http://wired.read-write.fr"
  s.license      = "BSD"
  s.author       = { "Rafaël Warnault" => "rw@read-write.fr" }
  
  s.osx.deployment_target = "10.10"
  
  s.source      = { :git => "https://github.com/nark/WiredFrameworks.git", :commit => "d997c2e8b7480ee437b86db19d523915f088e61f", :tag => "0.0.2" }
  
  s.subspec 'ChatHistory-default' do |sspc|
      
  end
  
  s.subspec 'libwired-osx' do |sspc|
      sspc.dependency "OpenSSL-Universal"
      sspc.source_files = "libwired/libwired/**/*.{h,m,c,mm}"
  end
  
  s.subspec 'WiredFoundation' do |sspc|
      sspc.source_files = "WiredFoundation/**/*.{h,m,c,mm}"
  end
  
  s.subspec 'WiredAppKit' do |sspc|
      sspc.dependency "WiredFoundation"
      sspc.source_files = "WiredAppKit/**/*.{h,m,c,mm}"
  end
  
  s.subspec 'WiredNetworking' do |sspc|
      sspc.dependency "OpenSSL-Universal"
      sspc.dependency "libwired-osx"
      sspc.dependency "WiredFoundation"
      sspc.source_files = "WiredNetworking/**/*.{h,m,c,mm}"
  end


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # s.source_files  = "Classes", "Classes/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
