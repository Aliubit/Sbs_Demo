//
//  FilterViewController.swift
//  Sbs_Demo
//
//  Created by Ali on 18/02/22.
//

import UIKit

// MARK: - Protocol FilterDelegate

protocol FilterDelegate : NSObjectProtocol{
    func didUpdateFilter(model : FilterModel)
}

// MARK: - ViewController FilterViewController

class FilterViewController: BaseViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var radiusLabel : UILabel!
    @IBOutlet weak var radiusSlider : UISlider!
    @IBOutlet weak var startDate : UIDatePicker!
    @IBOutlet weak var endDate : UIDatePicker!
    
    // MARK: - Properties
    
    var model : FilterModel!
    weak var delegate : FilterDelegate?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if model == nil {
            model = FilterModel()
        }
        setupUI()
    }
    
    func dismiss() {
        self.delegate?.didUpdateFilter(model: self.model)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI Functions
    
    func setupUI() {
        radiusSlider.maximumValue = Constants.filterMax
        radiusSlider.minimumValue = Constants.filterMin
        
        if let radius = model.radius {
            radiusSlider.value = Float(radius)
            setRadiusLabel(withMeters: radius)
        }
        else {
            radiusSlider.value = radiusSlider.maximumValue
            setRadiusLabel(withMeters: Double(radiusSlider.value))
        }
        if let start = model.startDate {
            startDate.date = start
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateFormat
            startDate.date = dateFormatter.date(from: Constants.minimumStartDate) ?? Date()
        }
        if let end = model.endDate {
            endDate.date = end
        }
        else {
            endDate.date = Date()
        }
        
        endDate.minimumDate = startDate.date
        endDate.maximumDate = Date()
        startDate.maximumDate = endDate.date
    }
    
    func setRadiusLabel(withMeters radius : Double) {
        self.radiusLabel.text = Constants.radiusText + String(format: "%d", Int(radius.rounded(.up)))
    }
    
    // MARK: - IBActions
    
    @IBAction func onReset() {
        self.model = FilterModel()
        self.dismiss()
    }
    
    @IBAction func onApply() {
        self.model = FilterModel(radius: Double(self.radiusSlider.value), startDate: startDate.date, endDate: endDate.date)
        self.dismiss()
    }
    
    @IBAction func sliderValueChanged() {
        setRadiusLabel(withMeters: Double(radiusSlider.value))
    }
    
    @IBAction func startDateChanged() {
        endDate.minimumDate = startDate.date
    }
    
    @IBAction func endDateChanged() {
        startDate.maximumDate = endDate.date
    }
    
}
