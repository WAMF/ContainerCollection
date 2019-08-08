//  Copyright © 2019 We Are Mobile First.


/// This protocol defines an immutable component model, it's up to the concrete
/// implementations to add type safety, this system should just pass data through
/// What pieces of data each individual component supports is up to them.
/// It's also up to the components themselves to control their own rendering of the data,

public protocol ComponentData {}

/// Something that can be "configured/populated" with data
///
/// - parameter data: The data the comopnent needs to be configured.
public protocol ConfigurableComponent {
    func configure(with data: ComponentData?)
}

/// A Parent component that can have nested child components for a given model
public protocol ParentComponent {
    var childComponent: ConfigurableComponent? { get }
}

public typealias NestedComponent = ParentComponent & ConfigurableComponent

/// Something that can provide an instance of a component given the input data (the input data may contain data
/// that will be used to decide what varient of a component that will be returned (templateID for example)
/// the "identifier" will be used to reuse components, so must idenifiy the exact component and variant
public enum ComponentTypes: String {
    case invalid
    case valid
}

/// A factory is responsible for creating new component instances for a given data,
/// or returning nil if is not supported by the factory.
public protocol ComponentFactory {
    ///  Returns a new component instance for given data. Returns nil if the component is invalid or could not be built.
    func buildComponent(using data: ComponentData) -> ConfigurableComponent?

    /// To be allow reuse the components they need to be uniquely identified.
    func identifyComponent(using data: ComponentData) -> String

    /// To check wether a component is supported or not.
    func validComponent(using data: ComponentData) -> Bool
}

/// Protocol defining the public API of a Component registry
///
/// A component mapper manages a series of registered `ComponentFactory and ` implementations,
/// That are used to create components for Container Collection powered views. To integrate
/// a component with the framework - implement a a Component Mapper registry.
/// The GenericComponentMapper can be used as a map of providers to identifiers (strings).
public protocol ComponentMapper {
    ///  Returns a compnent factory given a component id. Returns nil if the factory has not been previously registered.
    /// - parameter id: The identifier of the component. As an example: "CarouselComponent"
    func factory(for id: String) -> ComponentFactory?
    
    /// To map the component factory with its identifier.
    func register(factory: ComponentFactory, for id: String)
}

/// Generic implementation of the ComponentMapper protocol
open class GenericComponentMapper: ComponentMapper {
    private var map: [String: ComponentFactory] = [:]

    public init() {}

    public func factory(for id: String) -> ComponentFactory? {
        return map[id]
    }

    public func register(factory: ComponentFactory, for id: String) {
        map[id] = factory
    }
}

/// Defines a thing that can be decomposed into elements that are simply data
/// with an implementation factory.
public struct Element {
    public let data: ComponentData
    public let factory: ComponentFactory

    public init(data: ComponentData, factory: ComponentFactory) {
        self.data = data
        self.factory = factory
    }
}

public protocol Decomposable {
    func decompose(using mapper: ComponentMapper) -> [Element]
}
