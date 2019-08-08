//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import MapKit
import UIKit

struct MapViewData: ComponentData {
    let annotations: [MKPointAnnotation]
    let center: CLLocationCoordinate2D
}

class MapViewController: UIViewController {
    private enum Constant {
        static let annotationReuseIdentifier = "Annotation"
    }

    @IBOutlet var mapView: MKMapView!

    var mapViewData: MapViewData? {
        didSet { refreshView() }
    }

    deinit {
        mapView.showsUserLocation = false
        mapView.layer.removeAllAnimations()
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeFromSuperview()
        mapView = nil
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }

    private func refreshView() {
        guard isViewLoaded, let data = mapViewData else { return }
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotations(data.annotations)
        mapView.centerCoordinate = data.center
        mapView.showAnnotations(data.annotations, animated: false)
        if isEmbedded {
            mapView.isUserInteractionEnabled = false
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.annotationReuseIdentifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constant.annotationReuseIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

/// The following extension is the only piece of code that we need to add to this view controller to work with either
/// the ContainerTableView or the ContainerCollectionView provided by the ContainerCollection framework.
extension MapViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let mapViewData = data as? MapViewData else { return }
        self.mapViewData = mapViewData
    }
}

/// In order to use make Maps usable in ContainerCollection, we disable the user interaction with the map to prevent having
/// several gesture recognizers enabled at the same time. The following extension contains a function to check if the
/// view controller is embedded into a container renderer.

extension MapViewController {
    var isEmbedded: Bool {
        return (parent as? TableContainerViewController) != nil
    }
}
