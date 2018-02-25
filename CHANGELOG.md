# CHANGELOG
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 2.4.0-Beta - Unreleased
- Version 2.4 is introducing an important dependency changes
	- The Library XMLDictionary is [Deprecated](https://github.com/nicklockwood/XMLDictionary), for this reason the code
          has been integrated and refactored to avoid Name collision
	- WARNING: XMLDictionary is no longer a dependency of this project, if you depend on it, import it by another mean or 
- Carthage integration
- Refactored Import to be more module friendly (and moved header import to implmeention as much as possible)


## 2.3.4 - 2018-02-25
- As of this version, the minimum system requirement are iOS 8.0, macOS 10.9 
- Added Travis for automatic testing
- Merged [Liquidsoul fork](https://github.com/Liquidsoul/XlsxReaderWriter) as he fixed Testing 
- Merged [brvignesh PullRequest #94](https://github.com/renebigot/XlsxReaderWriter/pull/94)
- Merged [bryant1410 PullRequest #77](https://github.com/renebigot/XlsxReaderWriter/pull/77)
- Added Support for Xcode 9.3 and future proof build (it was failing due to new compiler recommended settings by Apple)

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

