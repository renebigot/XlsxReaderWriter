# CHANGELOG
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased
- As of this version, the minimum system requirement are iOS 8.0, macOS 10.9 
- Added Travis for automatic testing
- Merged [Liquidsoul fork](https://github.com/Liquidsoul/XlsxReaderWriter) as he fixed Testing 
- Merged [brvignesh PullRequest #94](https://github.com/renebigot/XlsxReaderWriter/pull/94)
- Merged [bryant1410 PullRequest #77](https://github.com/renebigot/XlsxReaderWriter/pull/77)

## 2.3.3 - 2018-02-12
- Updated Specs to use the latest version of SSZipArchive  '~> 2.1'
- Fixed some ocumentation warnings
- Fixed a Null pointer exception case in BRAContentTypes

## 2.3.2 - 2017-11-06
- Fixed conditional for Cocoapods Lint (MacOS  vs. iOS)
- Changed podspec to point outside Cocoapods main repo (As I don't have rigth to push for the public Pod)
    See: [Issue #88 - original renebigot/XlsxReaderWriter](https://github.com/renebigot/XlsxReaderWriter/issues/88)
- Updated readme to explain how to use this repo
- Fixed Bug preventing SSZipArchive to extract folder
- Fixed cocoapods and added FrameWorks support (for Xcode 9+ and Swift 4)

