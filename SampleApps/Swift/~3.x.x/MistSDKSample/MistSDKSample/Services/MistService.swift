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
    func didFailedToUpdateMap(with error: String?)
}


class RealMistService: MistService {
    weak var delegate: MistServiceDelegate?

    private let mistManager = IndoorLocationManager.shared
    private let sdkConfig: Mist.Configuration
    private var currentMap: Mist.Map?

    init(token: String, delegate: MistServiceDelegate) {
        self.delegate = delegate
        self.sdkConfig = .default(sdkToken: token, enableLog: true)
    }
    
    func start() {
        mistManager.start(with: sdkConfig, delegate: self)
    }
    
    func stop() {
        mistManager.stop()
    }
}

// MARK: - MistIndoorLocationDelegate (New Integartion Flow)

extension RealMistService: MistIndoorLocationDelegate {
    
    func didReceive(event: Mist.Event) {
        switch event {
        case .onReceivedClientInfo(let client):
            debugPrint(">>> onReceivedClientInfo UUID => \(client.deviceId ?? "-")")
            
        case .onReceivedAllMaps(let maps):
            debugPrint(">>> onReceivedAllMaps \(maps.count)")
            
        case .onMapUpdate(let map):
            guard let url = map.url, let mapUrl = URL(string: url) else { return }
            currentMap = map
            delegate?.didUpdateMap(mapUrl)
            debugPrint(">>> onMapUpdate \(map.name ?? "-")")
            
        case .onUpdateVirtualBeaconList(let vBeacons):
            debugPrint(">>> onUpdateVirtualBeaconList \(vBeacons.count)")
            
        case .onRelativeLocationUpdate(let relativeLocation):
            guard let map = currentMap, let ppm = map.ppm else { return }
            let location = CGPoint(x: relativeLocation.x * ppm, y: relativeLocation.y * ppm)
            debugPrint(">>> didUpdateRelativeLocation x = \(location.x) y = \(location.y) lat = \(relativeLocation.lat), lon = \(relativeLocation.lon)")
            delegate?.didUpdateLocation(location)
            
        // ZONE - Notification
        case .onEnterZone(let zone):
            debugPrint(">>> didEnterZone \(zone.name!)")
        case .onExitZone(let zone):
            debugPrint(">>> didExitZone \(zone.name!)")
            
        // VirtualBeacon - Notification
        case .onRangeVirtualBeacon(let vBeacon):
            debugPrint(">>> didRangeVirtualBeacon \(vBeacon.name!)")
            
        case .onError(let error):
            debugPrint(">>> didErrorOccur = \(error.localizedDescription)")
            
        default: 
            break
        }
    }
}
