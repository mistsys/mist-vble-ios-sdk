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
        
        messageLabel.text = MistSDK.WakeUp.notMonitoringMessage
        
        wakeUpButton.isSelected = false
        wakeUpButton.setTitle("Start WakeUp Service", for: .normal)
        wakeUpButton.setTitle("Stop WakeUp Service", for: .selected)
        updateStatus()
    }
    
    private func configureViewModel() {
        let wakeUpService = RealWakeupService()
        let mistService = RealMistService(orgId: MistSDK.SDK.orgId, token: MistSDK.SDK.token)
        let viewModel = ViewModel(wakeUpService: wakeUpService, mistService: mistService)
        viewModel.viewDelegate = self
        wakeUpService.delegate = viewModel
        mistService.delegate = viewModel
        self.viewModel = viewModel
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
        messageLabel.text = wakeUpButton.isSelected ? MistSDK.WakeUp.monitoringMessage : MistSDK.WakeUp.notMonitoringMessage
    }
}

extension ViewController: ViewDelegate {
        
    func didUpdateRelativeLocation(_ location: CGPoint) {
        debugPrint(">>> didUpdateRelativeLocation = x=\(location.x) y=\(location.y)")
    }
}
