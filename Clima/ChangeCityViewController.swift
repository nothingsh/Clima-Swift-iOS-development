//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Steven Zhang on 1/3/19.
//  Copyright © 2019 Steven Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateCityInMain {
    func changeCity(_ city: String)
}

class ChangeCityViewController: UIViewController, UISearchBarDelegate {
    var delegate: UpdateCityInMain?
    
    @IBAction func backToMainView(_ sender: Any) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let city = searchBar.text{
            if delegate == nil {
                print("the delegate is useless!")
            }
            delegate?.changeCity(city)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
