//
//  MapHelperExtensions.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

// MARK: - UIGraphicsImageRenderer Extension

extension UIGraphicsImageRenderer {
    static func image(for annotations: [MKAnnotation], in rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let totalCount = annotations.count
        let elementCount = annotations.elementCount
        let redCount = elementCount.redCount
        let greenCount = elementCount.greenCount
        let countText = "\(totalCount)"
        
        return renderer.image { _ in
            UIColor.yellow.setFill()
            UIBezierPath(ovalIn: rect).fill()
            
            UIColor.green.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(greenCount)) / CGFloat(totalCount),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()
            
            
            UIColor.red.setFill()
            let piePath2 = UIBezierPath()
            piePath2.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(redCount)) / CGFloat(totalCount),
                           clockwise: true)
            piePath2.addLine(to: CGPoint(x: 20, y: 20))
            piePath2.close()
            piePath2.fill()
            
            
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            countText.drawForCluster(in: rect)
        }
    }
}

// MARK: - Generic count Property

struct ElementColorCount {
    var greenCount = 0, redCount = 0
    init(gc : Int, rc : Int) {
        greenCount = gc
        redCount = rc
    }
}


// MARK: - Generic sequence extension

extension Sequence where Element == MKAnnotation {
    
    
    var elementCount : ElementColorCount {
        get {
            var gc = 0, rc = 0
            for item in self {
                if let mapItem = item as? MapItem {
                    if mapItem.itemType == .green {gc += 1}
                    else if mapItem.itemType == .red {rc += 1}
                }
            }
            return ElementColorCount(gc: gc, rc: rc)
        }
    }
}

// MARK: - String Extension

extension String {
    func drawForCluster(in rect: CGRect) {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let textSize = self.size(withAttributes: attributes)
        let textRect = CGRect(x: (rect.width / 2) - (textSize.width / 2),
                              y: (rect.height / 2) - (textSize.height / 2),
                              width: textSize.width,
                              height: textSize.height)
        
        self.draw(in: textRect, withAttributes: attributes)
    }
    
    func toDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withFullDate
        return dateFormatter.date(from:self)!
    }
}

// MARK: - Date Extension

extension Date {

    func toString(withFormat format: String = "EEEE , d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}

// MARK: - CoreData context key Extension

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

// MARK: - UIView Extension

extension UIView{

    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)

        self.addSubview(backgroundView)
    }

    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

// MARK: - CLPlacemark Extension

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
