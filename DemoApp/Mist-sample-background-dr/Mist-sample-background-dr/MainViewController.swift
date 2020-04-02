//
//  MainViewController.swift
//  Mist-sample-background-dr
//
//  Created by Pooja Gulabchand Mishra on 12/18/19.
//  Copyright © 2019 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var buttonBegin: UIButton!
    @IBOutlet var sdkSecretTokenTxtField: UITextField!
    var sdkToken : String = ""//"<Mist SDK Token>"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBegin.layer.cornerRadius = 5
        buttonBegin.clipsToBounds = true
        sdkSecretTokenTxtField?.text = sdkToken
    }
    
    @IBAction func actionBeginButtonClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        guard let sdkToken = sdkSecretTokenTxtField.text, !sdkToken.isEmpty else {return}
        vc?.sdkSecret = sdkToken
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
}
