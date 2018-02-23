source 'https://github.com/CocoaPods/Specs'


def thridparty
    pod 'SSZipArchive', '~> 2.1'
    pod 'XMLDictionary', '~> 1.4'
end

target 'XlsxReaderWriter' do
    platform :ios, '8.0'
	use_frameworks!
    thridparty
end

target 'XlsxReaderWriterTests' do
    platform :ios, '8.0'
	use_frameworks!
    thridparty
end

target 'XlsxReaderWriter Mac' do
    platform :osx, '10.9'
    thridparty
    use_frameworks!
end
