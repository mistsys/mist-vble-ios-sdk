//
//  ViewController.swift
//  SampleIndoorLocationReporting
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: ViewModel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = ViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel?.start()
    }

}

