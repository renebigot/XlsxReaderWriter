Pod::Spec.new do |s|
  s.name               = "XlsxReaderWriter"
  s.version            = "1.0.6"
  s.summary            = "XlsxReaderWriter is an Objective-C library for iPhone / iPad. It parses and writes Excel OpenXml files (XLSX)."
  s.homepage           = "https://github.com/renebigot/XlsxReaderWriter"
  s.license            = "MIT"
  s.author             = "René Bigot"
  s.social_media_url   = "https://twitter.com/renebigot"
  s.platform           = :ios, "7.0"
  s.source             = { :git => "https://github.com/renebigot/XlsxReaderWriter.git" }
  s.source_files       = "XlsxReaderWriter/*.{h,m}"
  s.exclude_files      = "ThirdParties"
  s.frameworks         = "Foundation", "UIKit"
  s.requires_arc       = true

  s.dependency "SSZipArchive", "~> 0.3"
  s.dependency "XMLDictionary", "~> 1.4"
end
