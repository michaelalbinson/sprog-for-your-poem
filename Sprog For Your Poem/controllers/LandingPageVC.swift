//
//  ViewController.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2021-07-10.
//

import UIKit

class LandingPageVC: UIViewController {
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainLabel.text = "Neat!"
    }
}

