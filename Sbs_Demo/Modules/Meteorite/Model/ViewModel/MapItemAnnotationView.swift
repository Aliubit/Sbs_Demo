//
//  MapItemAnnotationView.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import MapKit

// MARK: - Class MapItemAnnotationView

final class MapItemAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let mapItem = annotation as? MapItem else { return }
            
            clusteringIdentifier = Constants.mapViewClusteringId
            image = mapItem.image
        }
    }
}
