//
//  MainViewController.swift
//  DemoApp
//
//  Created by Ajay Gantayet on 6/22/18.
//

import Foundation
import UIKit

class MainViewController: UIViewController{
    @IBOutlet weak var mainTextField: UITextField!
    let kSettings = "com.mist.new.mistsdk_credentials"
    var currentKey:String?
    var isTesting : Bool = true
    
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        
        if(isTesting){
            currentKey = "P7sAHsHucjlFrFrKJC6qjd7rS0tO6TWg"
            mainTextField.text = currentKey
        }
        
        if let myLoadedString = UserDefaults.standard.string(forKey: kSettings) {
            currentKey = myLoadedString;
            mainTextField.text = myLoadedString
        }
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    @IBAction func onDoneButtonClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        
        guard let userInput = mainTextField.text, !userInput.isEmpty else {return}
        UserDefaults.standard.set(userInput, forKey: kSettings)
        nextViewController.clientSecret = userInput
        
        self.present(nextViewController, animated:true, completion:nil)
    }
}
