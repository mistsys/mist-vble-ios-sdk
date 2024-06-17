//
//  MistService.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation
import MistSDK

protocol MistService {
    func start()
    func stop()
}

protocol MistServiceDelegate: AnyObject {
    func didUpdateMap(_ map: URL)
    func didUpdateLocation(_ location: CGPoint)
    func didFailed(with error: String?)
}

class RealMistService: MistService {
    private let mistManager: IndoorLocationManager
    private var currentMap: MistMap?

    weak var delegate: MistServiceDelegate?
    
    init(token: String, delegate: MistServiceDelegate) {
        self.delegate = delegate
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }
    
    func start() {
        mistManager.startWithIndoorLocationDelegate(self)
    }
    
    func stop() {
        mistManager.stop()
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didUpdateMap(_ map: MistMap!) {
        currentMap = map
        guard let mapURL = URL(string: map.url) else { return }
        delegate?.didUpdateMap(mapURL)
        debugPrint(">>> didUpdate MistMap mapName=\(map.name.description)")
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        guard let map = currentMap else { return }
        let location = CGPoint(x: relativeLocation.x * map.ppm, y: relativeLocation.y * map.ppm)
        debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y)")
        delegate?.didUpdateLocation(location)
    }
    
    func didReceivedOrgInfoWithTokenName(_ tokenName: String!, andOrgID orgID: String!) {
        debugPrint(">>> didReceivedOrgInfo tokenName = \(tokenName.description) orgID = \(orgID.description)")
    }
    
    func didErrorOccurWithType(_ errorType: Error, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType) errorMessage = \(String(describing: errorMessage))")
        delegate?.didFailed(with: errorMessage)
    }
}
