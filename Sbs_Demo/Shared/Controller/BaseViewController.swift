//
//  BaseViewController.swift
//  Sbs_Demo
//
//  Created by Ali on 16/02/22.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Base functions
    
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                break
            case .cancel,.destructive:
                break
            default :
                break
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
