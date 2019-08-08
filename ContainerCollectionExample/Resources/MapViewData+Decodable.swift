//  Copyright © 2019 We Are Mobile First.

import MapKit

struct MapAnnotation: Decodable {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
}

extension MapViewData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case annotations, center
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let annotations = try values.decode([MapAnnotation].self, forKey: .annotations)
        self.annotations = annotations.map {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = $0.coordinate
            pointAnnotation.title = $0.title
            pointAnnotation.subtitle = $0.subtitle
            return pointAnnotation
        }
        center = try values.decode(CLLocationCoordinate2D.self, forKey: .center)
    }
}

extension MapViewData {
    static var fallback: MapViewData {
        return MapViewData(annotations: [], center: CLLocationCoordinate2D())
    }
}

extension CLLocationCoordinate2D: Decodable {
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }

    public init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
}
