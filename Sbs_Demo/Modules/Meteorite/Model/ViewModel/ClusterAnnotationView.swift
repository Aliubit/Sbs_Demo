//
//  ClusterAnnotationView.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import UIKit
import MapKit

// MARK: - Class ClusterAnnotationView

final class ClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            displayPriority = .defaultHigh
            let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
            image = UIGraphicsImageRenderer.image(for: cluster.memberAnnotations, in: rect)
            
        }
    }
}
