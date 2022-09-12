//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Ahmed Fayeq on 19/06/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    let gradiantLayer : CAGradientLayer = {
        let gradiant = CAGradientLayer()
        gradiant.colors = [
            UIColor.systemBlue.cgColor,
            UIColor(red: 0.545, green: 0.888, blue: 1, alpha: 1.0).cgColor,
            
        ]
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradiantLayer.frame = view.bounds
        view.layer.addSublayer(gradiantLayer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
}
