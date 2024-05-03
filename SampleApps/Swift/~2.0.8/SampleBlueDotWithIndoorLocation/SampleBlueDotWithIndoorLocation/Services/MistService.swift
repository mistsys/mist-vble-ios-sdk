//
//  MistService.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 16/03/23.
//

import Foundation
import MistSDK

protocol MistService {
    var  isStarted: Bool { get }
    var  mapPpmValue: Double { get }
    func start()
    func stop()
}

protocol MistServiceDelegate: AnyObject {
    func didUpdateMap(_ map: URL)
    func didUpdateLocation(_ location: CGPoint)
}

class RealMistService: NSObject, MistService {
    weak var delegate: MistServiceDelegate?
    var isStarted: Bool = false
    var currentMap: MistMap?
    
    var mapPpmValue: Double {
        currentMap?.ppm ?? 0
    }
    
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
        currentMap = map
        guard let mapURL = URL(string: map.url) else { return }
        delegate?.didUpdateMap(mapURL)
        debugPrint(">>> didUpdate MistMap mapName=\(map.name.description)")
    }
    
    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        guard let map = currentMap else { return }
        debugPrint(">>> didUpdateRelativeLocation Original x = \(relativeLocation.x) y = \(relativeLocation.y)")
        debugPrint(">>> didUpdateRelativeLocation PPM Value = \(map.ppm)")
        let location = CGPoint(x: relativeLocation.x * map.ppm, y: relativeLocation.y * map.ppm)
        debugPrint(">>> didUpdateRelativeLocation with PPM x = \(location.x) y = \(location.y)")
        delegate?.didUpdateLocation(location)
    }
    
    func didErrorOccurWithType(_ errorType: Error, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType) errorMessage = \(String(describing: errorMessage))")
    }
}
