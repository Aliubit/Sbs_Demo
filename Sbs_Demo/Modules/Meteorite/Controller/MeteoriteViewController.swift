//
//  ViewController.swift
//  Sbs_Demo
//
//  Created by Ali on 15/02/22.
//

import UIKit
import MapKit

// MARK: - ViewController MeteoriteViewController

class MeteoriteViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView : MKMapView!
    var filterBtn : UIButton!
    var dataSource = [MapItem]()
    let handler = MeteoriteManager()
    
    // MARK: -  Properties
    var filterModel : FilterModel?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handler.setDelegate(delegate: self)
        setupUI()
        callMeteoriteAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UI Functions
    
    func setupUI() {
        initializeMapView()
        setupRightBarButton()
    }
    
    func initializeMapView() {
        self.mapView.visibleMapRect = .world
        self.mapView.delegate = self
        
        mapView.register(
            MapItemAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func setupRightBarButton() {
        
        filterBtn = UIButton(type: .roundedRect)
        filterBtn.titleLabel?.font = UIFont(name: Constants.defaultFont, size: 16)
        filterBtn.setTitle("Filter", for: .normal)
        filterBtn.setTitleColor(.darkText, for: .normal)
        filterBtn.addTarget(self, action: #selector(filterBtnAction(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItems = [barButtonItem]
    }
    
    func populateMapView() {

        mapView.removeAnnotations(mapView.annotations)
        
        guard self.dataSource.count > 0 else {return}
        
        for annotation in self.dataSource {
            mapView.addAnnotation(annotation)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // MARK: - Helper Functions
    
    func callMeteoriteAPI() {
        self.view.activityStartAnimating(activityColor: .gray, backgroundColor: .clear)
        handler.getMeteoriteDataFromServer()
    }
    
    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.filter.rawValue:
            let filterVC = segue.destination as! FilterViewController
            filterVC.model = sender as? FilterModel ?? FilterModel()
            filterVC.delegate = self
            break
        case SegueIdentifiers.meteoriteDetail.rawValue:
            let detailVC = segue.destination as! MeteoriteDetailViewController
            detailVC.viewModel = sender as? MapItem
            break
        default:
            break
        }
    }
    
    //MARK: - IBActions
    @objc func filterBtnAction(_ sender:UIButton!) {
        self.performSegue(withIdentifier: SegueIdentifiers.filter.rawValue, sender: filterModel as Any)
    }
}

// MARK: - Implementation of  MKMapViewDelegate

extension MeteoriteViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ClusterAnnotationView else {
            if let annotation = view.annotation {
                mapView.deselectAnnotation(view.annotation!, animated: false)
                performSegue(withIdentifier: SegueIdentifiers.meteoriteDetail.rawValue, sender: annotation as Any)
            }
            return
        }
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
    }
}

// MARK: - Implementation of  MeteoriteManagerDelegate
extension MeteoriteViewController : MeteoriteManagerDelegate {
    func didReceiveData(dataSource: [MapItem]) {
        self.view.activityStopAnimating()
        self.dataSource = dataSource
        self.populateMapView()
    }
    
    func failToGetDataWithError(error: String) {
        self.view.activityStopAnimating()
        self.showAlert(title: Messages.defaultTitle, message: error)
    }
    
    func failToGetLocation(error: String) {
        self.showAlert(title: Messages.defaultTitle, message: error)
    }
}

// MARK: - Implementation of  FilterDelegate

extension MeteoriteViewController : FilterDelegate {
    func didUpdateFilter(model: FilterModel) {
        self.filterModel = model
        handler.getMeteoriteDataFromLocalDB(model: model)
    }
}
