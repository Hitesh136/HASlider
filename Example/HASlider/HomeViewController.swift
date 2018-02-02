//
//  HomeViewController.swift
//  HASlider_Example
//
//  Created by Hitesh Agarwal on 02/02/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnHorizontalSlider: UIButton!
    @IBOutlet weak var btnVericalSlider: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnHorizontalSlider.layer.cornerRadius = 5
        btnHorizontalSlider.layer.borderColor = UIColor.black.cgColor
        btnHorizontalSlider.layer.borderWidth = 2.0
        
        btnVericalSlider.layer.cornerRadius = 5
        btnVericalSlider.layer.borderColor = UIColor.black.cgColor
        btnVericalSlider.layer.borderWidth = 2.0
    }

    @IBAction func actionHorizontalSlider(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let horizontalVC = sb.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navigationController?.pushViewController(horizontalVC, animated: true)
        }
    }
    
    @IBAction func actionVerticalSlider(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let horizontalVC = sb.instantiateViewController(withIdentifier: "VerticalSliderViewController") as? VerticalSliderViewController {
            self.navigationController?.pushViewController(horizontalVC, animated: true)
        }
    }
}
