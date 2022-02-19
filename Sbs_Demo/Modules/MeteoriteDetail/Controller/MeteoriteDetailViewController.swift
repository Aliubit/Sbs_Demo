//
//  MeteoriteDetailViewController.swift
//  Sbs_Demo
//
//  Created by Ali on 19/02/22.
//

import UIKit
import MapKit

// MARK: - View Controller - MeteoriteDetailViewController

class MeteoriteDetailViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var mapView : MKMapView!
    
    // MARK: - Properties
    var viewModel : MapItem!
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI functions
    
    func setupUI() {
        guard let viewModel = viewModel else {
            print("Class is not instantiated Properly")
            return
        }
        MeteoriteDetailManager().getAddressfromCoordinates(lat: viewModel.coordinate.latitude, lon: viewModel.coordinate.longitude,id: viewModel.id , completion: {(address,error) in
            if let error = error {
                self.showAlert(title: Messages.defaultTitle, message: error)
            }
            else if let address = address {
                self.addressLabel.text = address
            }
        })
        self.dateLabel.text = viewModel.date.toString()
        self.mapView.addAnnotation(viewModel)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
    }
    
}
