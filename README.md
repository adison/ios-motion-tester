#Travis CI 測試用專案

測試結果
[![Build Status](https://travis-ci.org/adisonwu/ios-motion-tester.png)](https://travis-ci.
org/adisonwu/ios-motion-tester)




#工具说明
jenkins: CI server, 免费，但是要自己架站  

Traivis: 有收费的 CI server，收费标准与 github 类似，公开专案不收费，私人专案收费  

XCTool: 一套 FB 开发的测试用命令列工具，Travis 以此为基本测试工具

OCMock: 测试框架语言  

Kiwi: 测试框架  

.travis.yml: travis 使用之设定档案，travis 的 xctool 会根据内容进行测试，专案使用了 pods 或其他元件时，记得注意相依性问题  
进阶内容可以参考 xctool 的[说明文件](http://docs.travis-ci.com/user/languages/objective-c/)


#建置步驟

##与 Travis CI 整合
###需求
	.travis.yml 文件，不能有中文，不然 travis 无法解析 ([参考文件](http://docs.travis-ci.com/user/languages/objective-c/))
	github 帐号
	travis 帐号, 如果目标 repo 是私人 repo, 需要 travis pro 帐号
此外，使用 travis 时，必须对应用建立共享 scheme, 并且显式加入相关的依赖套件至 scheme
[In order to your run your tests within a continuous integration environment, you must create Shared Schemes for your application target and ensure that all dependencies (such as CocoaPods) are added explicitly to the Scheme.](http://stackoverflow.com/questions/19607894/how-to-get-travis-ci-to-build-and-test-xcode-projects-hosted-on-github)  
上面这段我一开始也不是很了..
不过总之就是开启 scheme 管理页面，把 target/test 最右边的  shared 打勾

####travis.yml 
区块中只有单一指令时，直接输入即可
如果有多重指令，指令开头要加上 "- "（注意空格）
如果指令真的太多，可以考慮指定 shell script 檔案  
```before_script: travis/before_script.sh```   
[travis.yml 測試區](http://lint.travis-ci.org/)

	
###整合 kiwi
在 Podfile 中整合 kiwi, target 应该是 scheme 中的测试目标名称，有用 - 破折号时请注意，pod 可能解析时会有问题（待确认）
target :DemoTests, :exclusive => true do
  pod 'Kiwi'
end
[kiwi文件, step 2 不用看，过时了](https://github.com/kiwi-bdd/Kiwi/wiki/Getting-Started-with-Kiwi-2.0)
	

##使用 jenkins
主要参考 [使用jenkins CI](http://www.uml.org.cn/jchgj/201311111.asp)  
首先要安装 jenkins, 然后直接安装外挂 xcode, git, github, cocoapods 等  
安装完要重新启动  

新增工作时，本地端 git 的位置格式是 file:////Users/username/Documents/projects/project-name  
如果不是 master, 要顺便调整其他设定

报告只需要打目录，也就是 test-reports 即可

这时建置的话，会发生以下问题，原因是 keychain/Code Sign 设定尚未完成
The following build commands failed:
	Check dependencies




#参考文件
[构建iOS持续集成平台(必读)](http://www.uml.org.cn/jchgj/201311111.asp)  
[jenkins plugin 列表](https://wiki.jenkins-ci.org/display/JENKINS/Plugins)
[为 iOS 建立 Travis CI](http://objccn.io/issue-6-5/)
[使用jenkins CI](http://www.uml.org.cn/jchgj/201311111.asp)
[XCTool 說明文件](https://github.com/facebook/xctool#continuous-integration)