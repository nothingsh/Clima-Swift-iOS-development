//
//  CopyrightViewController.swift
//  Clima
//
//  Created by Steven Zhang on 1/5/19.
//  Copyright © 2019 Steven Zhang. All rights reserved.
//

import Foundation
import UIKit

class CopyrightViewController: UIViewController {
    @IBAction func backToMainView(_ sender: Any) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var copyrightInfo: UIStackView!
    
    // this view is static
}

