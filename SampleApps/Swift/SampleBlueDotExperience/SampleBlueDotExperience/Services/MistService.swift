//
//  MistService.swift
//  SampleBlueDotExperience
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation
import MistSDK

protocol MistService {
    var  isStarted: Bool { get }
    var  mapPpmValue: Double { get }
    func start()
    func stop()}

protocol MistServiceDelegate: AnyObject {
    func didUpdateMap(_ map: URL)
    func didUpdateLocation(_ location: CGPoint)
    func didFailed(with error: String?)
}

class RealMistService: NSObject, MistService {
    weak var delegate: MistServiceDelegate?
    
    private let mistManager = IndoorLocationManager.shared
    private var currentMap: Mist.Map?
    var isStarted: Bool = false
    private let sdkConfig: Mist.Configuration
    
    var mapPpmValue: Double {
        currentMap?.ppm ?? 0
    }
    
    init(orgId: String, token: String) {
        //self.sdkConfig = Mist.Configuration.init(orgId: orgId, sdkToken: token, logLevel: .verbose, enableLog: false)
        self.sdkConfig = .default(orgId: orgId, sdkToken: token)
    }

    
    func start() {
        mistManager.start(with: sdkConfig, delegate: self)
    }
    
    func stop() {
        mistManager.stop()
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {
    
    func didReceive(event: Mist.Event) {
        switch event {
            
        case .onReceivedClientInfo(let client):
            debugPrint(">>> onReceivedClientInfo UUID => \(client.deviceId ?? "-") orgID = \(client.orgId ?? "-")")
            
        case .onMapUpdate(let map):
            guard let url = map.url, let mapUrl = URL(string: url) else { return }
            currentMap = map
            delegate?.didUpdateMap(mapUrl)
            debugPrint(">>> onMapUpdate \(map.name ?? "-")")
            
        case .onRelativeLocationUpdate(let relativeLocation):
            guard let map = currentMap, let ppm = map.ppm else { return }
            let location = CGPoint(x: relativeLocation.x * ppm, y: relativeLocation.y * ppm)
            debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y) lat = \(relativeLocation.lat), lon = \(relativeLocation.lon)")
            delegate?.didUpdateLocation(location)
            
        case .onError(let error):
            debugPrint(">>> didErrorOccur = \(error.localizedDescription)")
            
        default:
            break
        }
    }
}
