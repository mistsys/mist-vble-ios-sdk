//
//  MainViewController.swift
//  Mist-vbeacon-zone-notification-dr
//
//  Created by Pooja Gulabchand Mishra on 1/2/20.
//  Copyright © 2020 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var sdkSecretTextField: UITextField!
    @IBOutlet var btnBegin: UIButton!
    
    var sdkToken : String = ""//<Mist SDK Secret Token>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBegin.layer.cornerRadius = 5
        btnBegin.clipsToBounds = true
        sdkSecretTextField.text = sdkToken
    }
    
    @IBAction func onClickBeginAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.clientSecret = sdkToken
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
}
