//
//  MainViewController.swift
//  DemoApp
//
//  Created by Ajay Gantayet on 6/22/18.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var sdkToken: String = "<ENTER MIST SDK TOKEN>"
    
    @IBOutlet var button: UIButton!

    override func viewDidLoad() {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }

    @IBAction func onDoneButtonClicked(_: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        nextViewController.sdkSecret = sdkToken
        present(nextViewController, animated: true, completion: nil)
    }
}
