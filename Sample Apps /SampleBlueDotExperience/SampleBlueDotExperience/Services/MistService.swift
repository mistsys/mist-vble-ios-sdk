//
//  MistService.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation

protocol MistService {
    func start()
    func stop()
}

protocol MistServiceDelegate: AnyObject {
    func didUpdateMap(_ map: URL)
    func didUpdateLocation(_ location: CGPoint)
    func didFailedToUpdateMap(with error: String?)
}

#if !targetEnvironment(simulator)

import MistSDK

class RealMistService: NSObject, MistService {
    private let mistManager: IndoorLocationManager
    private var currentMap: MistMap?

    weak var delegate: MistServiceDelegate?
    
    init(token: String, delegate: MistServiceDelegate) {
        self.delegate = delegate
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }
    
    func start() {
        mistManager.start(with: self)
    }
    
    func stop() {
        mistManager.stop()
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didUpdate(_ map: MistMap!) {
        currentMap = map
        guard let mapPath = map.url, let mapURL = URL(string: mapPath) else { return }
        delegate?.didUpdateMap(mapURL)
        debugPrint(">>> didUpdate MistMap mapName=\(map.name.description)")
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        guard let map = currentMap else { return }
        let location = CGPoint(x: relativeLocation.x * map.ppm, y: relativeLocation.y * map.ppm)
        debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y)")
        delegate?.didUpdateLocation(location)
    }
    
    func didReceivedOrgInfo(withTokenName tokenName: String!, andOrgID orgID: String!) {
        debugPrint(">>> didReceivedOrgInfo tokenName = \(tokenName.description) orgID = \(orgID.description)")
    }
    
    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType.rawValue) errorMessage = \(errorMessage.description)")
        delegate?.didFailedToUpdateMap(with: errorMessage)
    }
}

#endif
