//
//  MainViewController.swift
//  Mist-indoor-location-dr
//
//  Created by Pooja Gulabchand Mishra on 1/6/20.
//  Copyright © 2020 Pooja Gulabchand Mishra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var sdkTokenTextField: UITextField!
    @IBOutlet var btnBegin: UIButton!
    
    var testing: Bool = true
    var sdkTokensecret = ""//"<MistSDK secret Token>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBegin.clipsToBounds = true
        btnBegin.layer.cornerRadius = 5
        
        if testing{
            sdkTokenTextField.text = sdkTokensecret
        }
    }

   
    @IBAction func onClickedBegin(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        guard let userInput = sdkTokenTextField.text , userInput.isEmpty != true  else { return }
        vc?.sdkSecret = userInput
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    

}
