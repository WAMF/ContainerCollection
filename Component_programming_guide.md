# Component Programming Guide

Components are the visual building blocks used to construct a screen using the Container Collection Framework. Every component is a subclass of `UIViewController`, and therefore it should be able to render its own subviews provided that it is given the required data (if any). In fact, every component should be able to be used "as is". The Container Collection Framework uses a recycling system similar to `UITableView` to reuse these view controllers as cells.

Each component is responsible for rendering a visual representation of a ComponentData. A component can also have child components nested within it.

### Creating a new Component

To create a component, create a `UIViewController` as you normally would using your established working practices (test and review your code as you would like), or reuse a view controller you already have. To integrate your view controller into the Container Collection you must extend it to conform to the `ConfigurableComponent` protocol: 

```
public protocol ConfigurableComponent {
    func configure(with data: ComponentData?)
}
```

`ComponentData` is an empty protocol used to take advantage of Swift's type safety. The view controller itself should be responsible for handling the data that it provided with, including any data validation process and the update of the view with the new data. The example app included in this repository shows several examples on how this can be achieved in the following cases:

* View controller with a `UICollectionView` (in both horizontal and vertical flows).
* View controller with a standalone `UIImageView` with a title and subtitle. 
* View controller with a `MKMapView` from `MapKit`.
* View controller with a `SCNView` from `SceneKit` (disabled by default, see [Special considerations](#special-considerations))
* View controller with an embedded `AVPlayerViewController` from `AVKit`.

Of course, these are only examples. Since components are just subclasses of `UIViewController`, they may be built in any way and using any design pattern. They just need to implement a way to handle data given by the Container Collection framework.

### Registering a Component with the framework

In order to use a Component, the container renderer under use must be provided with three pieces of information:
* How to identify the component in the stack of registered components?
* How to build the component from scratch?
* How to configure a given component with some given data?

These three "questions" must be answered by the `ContainerCollectionControllerDelegate` (usually, the view controller containing the container renderer) by means of the `ContainerCollectionControllerDelegate` protocol:

```
public protocol ContainerCollectionControllerDelegate: NSObjectProtocol {
    func reuseIdentifier(data: Any) -> String
    func createController(data: Any, forIndexPath: IndexPath) -> UIViewController
    func update(controller: UIViewController, data: Any, forIndexPath: IndexPath)
}
```

In order to encapsulate this information in a single place we provide the `ComponentFactory` protocol:

```
public protocol ComponentFactory {
    func buildComponent(using data: ComponentData) -> ConfigurableComponent?
    func identifyComponent(using data: ComponentData) -> String
    func validComponent(using data: ComponentData) -> Bool
}
```

Classes conforming to this protocol are referred to as "factories". Ideally, each component should have a single factory, and the corresponding factory is responsible for building and identifying components **with some given data**, and also validating data (which can be as simple or complex as required).

Note that a single component may have several different layouts (for instance, several `*.storyboard` files using the same class). In this case, **the factory** is responsible for providing the corresponding layout, and the `ComponentData` should provide a way to choose a specific layout if more than one is available. The example app in this repository includes an example of this: the `Image.storyboard` includes two different layouts for an image with title, both scenes using the `ImageViewController` class. The `ImageFactory` class provides on of the two layouts depending on the value of the `variant` property in the data.

### Component mapping

The framework provides a protocol that enables mapping factory instances to identifiers: the `ComponentMapper`. Using the mapper, each factory is registered for one or more identifiers, which will make the Container Collection dispatch to that factory if a Component has that component id.

```
public protocol ComponentMapper {
    func factory(for id: String) -> ComponentFactory?
    func register(factory: ComponentFactory, for id: String)
}
```

There is a default implementation `GenericComponentMapper` that gives the simplest implementation of it that will be good for most use cases.

This enables the framework to be completely data driven, that is, it is able to render a stack components using an array of identifiers as the root data. In particular, provided that we have a way to parse a response from our remote server into components and the data required to render them, we can "build" every screen of a mobile app (and thus, change it whenever we want) from a server.

Note that the `ComponentMapper` is not mandatory. In fact, you may not even need it and just build/configure the components in any order that is required by means of the `ContainerCollectionControllerDelegate` conformant class.

### The `Element` class and the `Decomposable` protocol

As it is clear from previous sections, there is a tight relationship between the data (objects conforming to `ComponentData`) and the factory (objects conforming to `ComponentFactory`) of every component. In fact, every function defined in the `ComponentFactory` protocol takes a `ComponentData` instance. In order to easily access to both data and factory for a component, we defined the `Element` object with the following interface:

```
public struct Element {
    public let data: ComponentData
    public let factory: ComponentFactory

    public init(data: ComponentData, factory: ComponentFactory) {
        self.data = data
        self.factory = factory
    }
}
```

This object provides a clear and neat point of access to both the data and the factory. In the example app included in this repository you can find examples on how to use the `Element` struct.

Finally, we provide a protocol to decompose an object into an array of `Element` instances by means of a `ComponentMapper`:

```
public protocol Decomposable {
    func decompose(using mapper: ComponentMapper) -> [Element]
}
```

Just as the `ComponentMapper`, you may not need to implement this protocol in any of your classes.

### Special considerations and limitations

Although any `UIViewController` subclass can be used as a component just by conforming to the `ConfigurableComponent` protocol, there are several special considerations to be taken into account. Most of these are common sense and good practices, but we prefer to explicitly mention them.

* The `ConfigurableComponent` instances (that is, the view controllers) **will be reused** when stacked by the ContainerCollection, in the same way as `UITableViewCell` instances are reused by a `UITableView`. As obvious and silly as it may sound, this means that if a view controller includes logic changing its view (or adding/removing subviews to the hierarchy) while on screen, then it must be reset to a clean initial state **before** it is configured with new data (either the function `configure(with data: ComponentData?)` of the `ConfigurableComponent` protocol or the `update(controller: UIViewController, data: Any, forIndexPath: IndexPath)` function of the `ComponentFactory` protocol are ideal locations for such cleaning code). Otherwise, residual UI elements may appear when the view controller is reused.
* The ContainerCollection renderer will handle the recycling of view controllers and memory management to the best of its ability, including freeing resources when it is deallocated or receives a memory warning. Nevertheless, stacking high memory-consuming view controllers within the ContainerCollection renderer container may have a huge impact on the app performance and increase the memory consumption to a point in which the app is terminated by the operating system. This may happen, for instance, when stacking several instances of controllers including a `MKMapView`, `AVPlayer` or `SCNView`. The example app included in this repository provides several high consuming view controllers to illustrate the memory handling of the framework, but we recommend being mindful when using these in a production app.
* Be mindful of retain cycles. They are bad in any app due to the memory leaks they cause, but ContainerCollection will make retain cycles even worse, since you may be stacking views which will never be deallocated, thus increasing the memory consumption of the app at every step.
* There is a known issue in `MapKit` that causes a view controller including a `MKMapView` outlet (that is, the view being created using storyboards or xib files) **not to deallocate** the map view when the view controller is deallocated. In order to solve this, you should progammatically remove the map view from your view hierarchy in the `deinit` function of the view controller. The `MapViewController` in the example app includes this code as an example. Bear in mind that this will be particularly serious if you stack map views using ContainerCollection.

In addition to the above, there are several limitations when using some particular elements of `UIKit` in ContainerCollection.

* View controllers containing a `UIScrollView` (or a subclass, such as `UICollectionView` or `UITableView`) must have a limited scroll height and must be able to compute its own height, so that the ContainerCollection framework is able to add its view to a stackable cell. Note, in addition, that cells in a `UICollectionView` or `UITableView` won't be reused: all will be rendered at the same time and on memory while the controller is on screen. Take a look at the `ImageGalleryViewController` in the example app included in this repository. Note that only the height is an issue here: you could use a horizontal rail with scrolling and it would work properly (take a look at the `HorizontalRailViewController` in the example app). Despite this limitation, ContainerCollection works perfectly with a limited height `UIScrollView`.
