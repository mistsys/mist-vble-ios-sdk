//
//  mainViewController.swift
//  MistSDK_demo_dr
//
//  Created by Pooja Gulabchand Mishra on 11/27/19.
//  Copyright © 2019 Pooja Gulabchand Mishra. All rights reserved.
//

import Foundation
import UIKit

class mainViewController: UIViewController {
    
    @IBOutlet  var beginButton: UIButton!
    var sdkToken : String = "<Mist SDK secret Token>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginButton.layer.cornerRadius = 5
        beginButton.clipsToBounds = true
    }
    
    @IBAction func beginButtonClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.sdkSecret = sdkToken
        self.present(vc!, animated: true, completion: nil)
    }
    
}
