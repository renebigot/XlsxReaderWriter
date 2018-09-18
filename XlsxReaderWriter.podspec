Pod::Spec.new do |s|
  s.name               = "XlsxReaderWriter"
  s.version            = "2.4.0"
  s.summary            = "XlsxReaderWriter is an Objective-C library for iPhone / iPad and Mac. It parses and writes Excel OpenXml files (XLSX)."
  s.homepage           = "https://github.com/charlymr/XlsxReaderWriter"
  s.license            = "MIT"
  s.author             = "René Bigot"
  s.social_media_url   = "https://www.linkedin.com/in/renebigot"
  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.9'
  s.source             = { :git => "https://github.com/charlymr/XlsxReaderWriter.git", :tag => s.version.to_s }
  s.source_files       = "XlsxReaderWriter/*.{h,m}"
  
  s.frameworks     	   = "Foundation"
  s.ios.frameworks     = "UIKit"
  s.osx.frameworks     = "Cocoa"
  
  s.requires_arc       = true

  s.dependency "SSZipArchive", "~> 2.1"

end

