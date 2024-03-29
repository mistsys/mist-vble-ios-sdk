//
//  MistService.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 27/02/23.
//

import Foundation


protocol MistService {
    var isStarted: Bool { get }
    func start()
    func stop()
}

protocol MistServiceDelegate: AnyObject {
    func didUpdateRelativeLocation(_ location: CGPoint)
}

#if !targetEnvironment(simulator)

import MistSDK

class RealMistService: NSObject, MistService {
    weak var delegate: MistServiceDelegate?
    var isStarted: Bool = false
    
    private let mistManager: IndoorLocationManager

    init(token: String) {
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }
    
    func start() {
        mistManager.start(with: self)
        isStarted = true
    }
    
    func stop() {
        mistManager.stop()
        isStarted = false
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didUpdate(_ map: MistMap!) {
        debugPrint(">>> didUpdate MistMap.name = \(map.name.description)")
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        let location = CGPoint(x: relativeLocation.x, y: relativeLocation.y)
        debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y)")
        delegate?.didUpdateRelativeLocation(location)
    }
    
    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType.rawValue) errorMessage = \(errorMessage.description)")
    }
}

#endif
