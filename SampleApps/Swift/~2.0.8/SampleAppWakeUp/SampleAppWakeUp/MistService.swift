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

import MistSDK

class RealMistService: NSObject, MistService {
    weak var delegate: MistServiceDelegate?
    var isStarted: Bool = false
    
    private let mistManager: IndoorLocationManager

    init(token: String) {
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }
    
    func start() {
        mistManager.startWithIndoorLocationDelegate(self)
        isStarted = true
    }
    
    func stop() {
        mistManager.stop()
        isStarted = false
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didUpdateMap(_ map: MistMap!) {
        debugPrint(">>> didUpdate MistMap.name = \(map.name.description)")
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        let location = CGPoint(x: relativeLocation.x, y: relativeLocation.y)
        debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y)")
        delegate?.didUpdateRelativeLocation(location)
    }
    
    func didErrorOccurWithType(_ errorType: Error, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType) errorMessage = \(String(describing: errorMessage))")
    }
}
