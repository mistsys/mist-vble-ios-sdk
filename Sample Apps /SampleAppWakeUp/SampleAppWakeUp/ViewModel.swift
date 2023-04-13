//
//  ViewModel.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 27/02/23.
//

import Foundation

protocol ViewModelWakeUpDelegate: AnyObject {
    var isWakeUpRuning: Bool { get }
    func startWakeUp()
    func stopWakeUp()
}

protocol ViewModelMistServiceDelegate: AnyObject {
    func startMistService()
    func stopMistService()
}

typealias ViewModelDelegate = ViewModelWakeUpDelegate & ViewModelMistServiceDelegate


// MARK: - ViewModel

class ViewModel {
    weak var viewDelegate: ViewDelegate?
    
    private let wakeUpService: WakeUpService
    private let mistService: MistService
    
    init(wakeUpService: WakeUpService, mistService: MistService) {
        self.wakeUpService = wakeUpService
        self.mistService = mistService
    }
}

extension ViewModel: WakeUpServiceDelegate {
    
    func didEnterRegion(region: String) {
        debugPrint(">>> didEnterRegion Beacon = \(region)")
        
        let payload = NotificationData(title: "didEnterRegion", subtitle: region, body: "Welcome!! You have enter in the beacon range")
        Notification.schedule(after: 1.0, payload: payload)
        
        if mistService.isStarted == false {
            // Start Mist SDK
            mistService.start()
        
            let sdkPayload = NotificationData(title: "Starting SDK...", subtitle: "", body: "Mist Location Tracking Started !!!")
            Notification.schedule(after: 2.0, payload: sdkPayload)
        }
    }
    
    func didExitRegion(region: String) {
        debugPrint(">>> didExitRegion Beacon = \(region)")
    }
}

// MARK: - Update UI Call
extension ViewModel: MistServiceDelegate {
    
    func didUpdateRelativeLocation(_ location: CGPoint) {
        viewDelegate?.didUpdateRelativeLocation(location)
    }
}

// MARK: - App WakeUp
extension ViewModel: ViewModelWakeUpDelegate {
    
    var isWakeUpRuning: Bool {
        wakeUpService.isWakeUpRuning
    }
    
    func startWakeUp() {
        wakeUpService.start()
    }
    
    func stopWakeUp() {
        wakeUpService.stop()
    }
}

// MARK: - Mist SDK Service Call
extension ViewModel: ViewModelMistServiceDelegate {
        
    func startMistService() {
        mistService.start()
    }
    
    func stopMistService() {
        mistService.stop()
    }
}
