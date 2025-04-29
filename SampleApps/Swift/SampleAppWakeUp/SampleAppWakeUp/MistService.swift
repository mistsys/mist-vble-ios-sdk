//
//  MistService.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 27/02/23.
//

import Foundation
import MistSDK

protocol MistService {
    var isStarted: Bool { get }
    func start()
    func stop()
}

protocol MistServiceDelegate: AnyObject {
    func didUpdateRelativeLocation(_ location: CGPoint)
}

class RealMistService: NSObject, MistService {
    weak var delegate: MistServiceDelegate?
    var isStarted: Bool = false
    private let mistManager = IndoorLocationManager.shared
    private let sdkConfig: Mist.Configuration
    
    init(orgId: String, token: String) {
        //self.sdkConfig = Mist.Configuration.init(orgId: orgId, sdkToken: token, logLevel: .verbose, enableLog: false)
        self.sdkConfig = .default(orgId: orgId, sdkToken: token)
    }
    
    func start() {
        mistManager.start(with: sdkConfig, delegate: self)
        isStarted = true
    }
    
    func stop() {
        mistManager.stop()
        isStarted = false
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didReceive(event: Mist.Event) {
        switch event {
        case .onMapUpdate(let map):
            debugPrint(">>> onMapUpdate \(map.name ?? "-")")
            
        case .onRelativeLocationUpdate(let relativeLocation):
            let location = CGPoint(x: relativeLocation.x, y: relativeLocation.y)
            debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y)")
            delegate?.didUpdateRelativeLocation(location)
            
        case .onError(let error):
            debugPrint(">>> didErrorOccur = \(error.localizedDescription)")
            
        default:
            break
        }
    }
}
