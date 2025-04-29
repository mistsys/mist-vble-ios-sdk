//
//  ViewModel.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import Foundation
import UIKit

// MARK: - Delegate Used to Update View
protocol ViewDelegate: AnyObject {
    func didMistServiceStarted()
    func didLoadMistMap(with image: UIImage)
    func didUpdateMistLocation(with point: CGPoint)
    func failed(with error: String?)
}

//MARK: -  ViewModel Exposed Methods
protocol ViewModelWakeUpDelegate: AnyObject {
    var isWakeUpEnabled: Bool { get }
    var isWakeUpRuning: Bool { get }
    func startWakeUp()
    func stopWakeUp()
}

protocol ViewModelMistServiceDelegate: AnyObject {
    var  isMistServiceRuning: Bool { get }
    var  mapPPMValue: Double { get }
    func startMistService()
    func stopMistService()
}

typealias ViewModelDelegate = ViewModelWakeUpDelegate & ViewModelMistServiceDelegate


// MARK: - View
class ViewModel {
    weak var delegate: ViewDelegate?
    
    private let mistService: MistService?
    private let wakeUpService: WakeUpService?
    private let downloader: Downloadable
        
    init(mistService: MistService, wakeUpService: WakeUpService, downloader: Downloadable = MapDownloader()) {
        self.mistService = mistService
        self.wakeUpService = wakeUpService
        self.downloader = downloader
    }
}

extension ViewModel: ViewModelWakeUpDelegate {
    
    var isWakeUpEnabled: Bool {
        wakeUpService?.isWakeUpEnabled ?? false
    }
    
    var isWakeUpRuning: Bool {
        wakeUpService?.isWakeUpRuning ?? false
    }
    
    func startWakeUp() {
        wakeUpService?.start()
    }
    
    func stopWakeUp() {
        wakeUpService?.stop()
    }
}

extension ViewModel: ViewModelMistServiceDelegate {
    var  isMistServiceRuning: Bool {
        mistService?.isStarted ?? false
    }
    
    var mapPPMValue: Double {
        mistService?.mapPpmValue ?? 0
    }
    
    func startMistService() {
        guard !MistSDK.SDK.token.isEmpty else {
            debugPrint("Token is missing !!!")
            return
        }
        mistService?.start()
    }
    
    func stopMistService() {
        mistService?.stop()
    }
}

// MARK: - MistServiceDelegate

extension ViewModel: MistServiceDelegate {
    
    func didUpdateMap(_ map: URL) {
        // Download Map Image and Load the Map
        downloader.download(url: map) { image, error in
            if let image = image {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didLoadMistMap(with: image)
                }
            }
        }
    }
    
    func didUpdateLocation(_ location: CGPoint) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didUpdateMistLocation(with: location)
        }
    }
    
    func didFailed(with error: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.failed(with: error)
        }
    }
}

// MARK: - WakeUpServiceDelegate

extension ViewModel: WakeUpServiceDelegate {
    
    func didEnterRegion(region: String) {
        debugPrint(">>> didEnterRegion Beacon = \(region)")
        
        let payload = NotificationData(title: "Hello!!!", subtitle: region, body: "Welcome!! You have enter in the Beacon range")
        Notification.schedule(after: 1.0, payload: payload)
        
        if mistService?.isStarted == false {
            // Start Mist SDK
            mistService?.start()
            delegate?.didMistServiceStarted()
            
            let sdkPayload = NotificationData(title: "Mist Service Started!", subtitle: "", body: "Mist Location Tracking Runing...")
            Notification.schedule(after: 2.0, payload: sdkPayload)
        }
    }
    
    func didExitRegion(region: String) {
        debugPrint(">>> didExitRegion Beacon = \(region)")
    }
}
