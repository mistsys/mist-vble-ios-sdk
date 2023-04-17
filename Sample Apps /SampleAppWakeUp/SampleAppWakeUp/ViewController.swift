//
//  ViewController.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import UIKit
import CoreLocation

protocol ViewDelegate: AnyObject {
    func didUpdateRelativeLocation(_ location: CGPoint)
}

class ViewController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var wakeUpButton: UIButton!
        
    var viewModel: ViewModelWakeUpDelegate?
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messageLabel.text = Mist.WakeUp.notMonitoringMessage
        
        wakeUpButton.isSelected = false
        wakeUpButton.setTitle("Start WakeUp Service", for: .normal)
        wakeUpButton.setTitle("Stop WakeUp Service", for: .selected)
        updateStatus()
    }
    
    private func configureViewModel() {
        #if !targetEnvironment(simulator)
        let wakeUpService = RealWakeupService()
        let mistService = RealMistService(token: Mist.SDK.token)
        let viewModel = ViewModel(wakeUpService: wakeUpService, mistService: mistService)
        viewModel.viewDelegate = self
        wakeUpService.delegate = viewModel
        mistService.delegate = viewModel
        self.viewModel = viewModel
        #endif
    }

    @IBAction func toggleWakeUpStatus() {
        guard let viewModel = viewModel else { return }
                
        if viewModel.isWakeUpRuning {
            viewModel.stopWakeUp()
        } else {
            viewModel.startWakeUp()
        }
    
        updateStatus()
    }
    
    func updateStatus() {
        guard let viewModel = viewModel else { return }
        wakeUpButton.isSelected = viewModel.isWakeUpRuning
        messageLabel.text = wakeUpButton.isSelected ? Mist.WakeUp.monitoringMessage : Mist.WakeUp.notMonitoringMessage
    }
}

extension ViewController: ViewDelegate {
        
    func didUpdateRelativeLocation(_ location: CGPoint) {
        debugPrint(">>> didUpdateRelativeLocation = x=\(location.x) y=\(location.y)")
    }
}
