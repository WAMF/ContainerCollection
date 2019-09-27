# Container Collection framework

![CocoaPods compatible](https://img.shields.io/cocoapods/v/ContainerCollection.svg?style=flat)
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![License](https://img.shields.io/github/license/WAMF/ContainerCollection)
![Platform](https://img.shields.io/cocoapods/p/ContainerCollection)
![Language: Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg)
![Language: Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg)

Container Collection is a Swift library that enables data-driven rendering of native components in a mobile app.

Container Collection emphasizes a one-way data flow from immutable models to immutable components that describe how views should be configured. It does the heavy lifting of building a view hierarchy from this description.

It works on both `iOS` and `tvOS`, and can be installed using either `CocoaPods`, `Carthage` or manual installation.

## Container Collection Views

Container Collection gives a great deal of flexibility in building layouts by making use of cells of native `UICollectionView` and `UITableView` as the container for each of the building blocks we call **Components**. A component is the smallest unit of data you want to present on screen. For example, in a photos app, a component might be a single image, an image including a caption, or even an entire gallery. 

The Container collection presents components onscreen using the `ContainerView` which is a subclass of `UIView` that's added as a subview in a cell. The `ContainerView` is the host view for the Components which are instances of `UIViewController` added as a child view controllers of the parent view controller that holds the Collection.

The container collection builds the content of the screen dynamycally stacking the items (*Components*) vertically. Each component must define its size and can't be _infinite_.


## Components

The building blocks used to render a screen are called **Components**. Components can be reused and rearranged in any way and render any model. They each define a rectangle on the screen in which anything can be rendered, making it easy to quickly iterate on UI and creating modular building blocks that reduce the need for code duplication.

To learn more about components, check out the [Component programming guide](Component_programming_guide.md).

## Requirements

| Version | Needs                                                            |
|:--------|:-----------------------------------------------------------------|
| 1.0     | Xcode 10.0+<br>Swift 4.2+<br>iOS 10.0+ / tvOS 10.0+  |

The framework is written using **Swift 5.0**, but there is really no code specific to that Swift version. Therefore, it should work with projects using Swift 4.2.

## Installation

You can choose to install the Container Collection framework either manually, or through a dependency manager.

### Manually

Clone this repo (for example, add it as a submodule).
Drag the project ContainerCollection.xcproj into Xcode as a subproject of your app project.
Link with ContainerCollection by adding it in "Linked Frameworks and Libaries", under the "General" tab in your app's project settings.

### Using CocoaPods

To use CocoaPods, first make sure you have installed it and updated it to the latest version by following their instructions on `cocoapods.org`.

Add ContainerCollection to your Podfile:

```
pod 'ContainerCollection'
```

Update your pods:
```
$ pod update
```

### Using Carthage

*To use Carthage, first make sure you have installed it and updated it to the latest version by following their instructions on [their repo](https://github.com/Carthage/Carthage)*

First, add `ContainerCollection` to your `Cartfile`:

```
github "WAMF/ContainerCollection" ~> 1.0
```

Then, run Carthage:

```
$ carthage update
```

## Code styling guide

We follow the [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide), with just one slight modification in the [Function Declarations](https://github.com/raywenderlich/swift-style-guide#function-declarations) section. For multiparameter functions we admit both the form in Ray Wenderlich's style guide and the following:
```
func reticulateSplines(spline: [Double], 
                       adjustmentFactor: Double,
                       translateConstant: Int, comment: String) -> Bool {
  // reticulate code goes here
}
```

This change is applied to the [Function Calls](https://github.com/raywenderlich/swift-style-guide#function-calls) section too.

Also, there's no need to split the function declaration (or function call) if it's less than 120 characters in length.

## Getting started

To enable you to quickly get started using the Container Collection, we've created  a getting started guide that will give you a [step-by-step tutorial](Getting_started_guide.md) to help get your first views up and running.

## Example app

We include an iOS example app in this repository. This example app implements several view controllers, which can be used either standalone or stacked using ContainerCollection. Data to populate the view controllers is generated randomly from a given (small) set of data included in the app bundle. View controllers included in the example app are:

* View controller with a `UICollectionView` (in both horizontal and vertical flows).
* View controller with a standalone `UIImageView` with a title and subtitle, in two different layouts.
* View controller with a `MKMapView` from `MapKit`.
* View controller with a `SCNView` from `SceneKit` (disabled by default in the stack, you can enable it via the ResourcesManager initializer call in the MainMenuViewController class)
* View controller with an embedded `AVPlayerViewController` from `AVKit`.

When selecting the stack of view controllers, you will be prompted for the number of view controllers you wish to stack. Default is 20, but any number between 1 and 10000 is allowed. Bear in mind, however, that the data set is limited. Also, for large numbers the system will trigger "Memory Warnings" to the app, which will then deallocate unnecessary resources from the stack (thus causing a minor freeze at that point). Performance with 10000 elements has been tested in the following devices:

* iPod Touch
* iPhone 6, 6s, X and Xs

## Known issues and incompatibilities

Framework is compatible with iOS/tvOS 10 or above, but using it in iOS/tvOS 11 or higher for a better performance is strongly recommended.

## Contribute

In order to contribute to the ContainerCollection framework, first read our [Contribution guidelines](contribution_guidelines.md).
