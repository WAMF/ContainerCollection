fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### deploy_pod
```
fastlane deploy_pod
```
Updates the podspec file to match the version of the Xcode project (iOS framework), and pushes to GitHub repository.

Tags the current release in the GitHub repository.

Deploys the podspec file to Trunk

----

## iOS
### ios run_uiTests
```
fastlane ios run_uiTests
```
Builds and runs iOS UITests on the example app.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
