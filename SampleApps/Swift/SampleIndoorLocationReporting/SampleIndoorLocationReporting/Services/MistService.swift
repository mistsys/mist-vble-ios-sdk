//
//  MistService.swift
//  SampleIndoorLocationReporting
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation
import MistSDK

protocol MistService {
    func start()
    func stop()
}

class RealMistService: NSObject, MistService {
    private let mistManager = IndoorLocationManager.shared
    private let sdkConfig: Mist.Configuration
    
    init(orgId: String, token: String) {
        self.sdkConfig = .default(orgId: orgId, sdkToken: token)
    }
    
    func start() {
        // start mist indoor location service
        mistManager.start(with: sdkConfig, delegate: self)
    }
    
    func stop() {
        // stop mist indoor location service
        mistManager.stop()
    }
}

extension RealMistService: IndoorLocationDelegate {
    
    func didReceive(event: Mist.Event) {
        switch event {
            
        case .onReceivedClientInfo(let client):
            debugPrint(">>> onReceivedClientInfo UUID => \(client.deviceId ?? "-")")
            
        case .onReceivedAllMaps(let maps):
            debugPrint(">>> onReceivedAllMaps \(maps.count)")
            
        case .onMapUpdate(let map):
            debugPrint(">>> onMapUpdate \(map.name ?? "-")")
            
        case .onRelativeLocationUpdate(let relativeLocation):
            debugPrint(">>> didUpdateRelativeLocation x = \(relativeLocation.x) y = \(relativeLocation.y) lat = \(relativeLocation.lat), lon = \(relativeLocation.lon)")
            
        // ZONES
        case .onEnterZone(let zone):
            debugPrint(">>> didEnterZone \(zone.name!)")
        case .onExitZone(let zone):
            debugPrint(">>> didExitZone \(zone.name!)")
            
        // VirtualBeacons
        case .onRangeVirtualBeacon(let vBeacon):
            debugPrint(">>> didRangeVirtualBeacon \(vBeacon.name!)")
            
        case .onUpdateVirtualBeaconList(let vBeacons):
            debugPrint(">>> onUpdateVirtualBeaconList \(vBeacons.count)")
                        
        case .onError(let error):
            debugPrint(">>> didErrorOccur = \(error.localizedDescription)")
            
        default:
            break
        }
    }
}
