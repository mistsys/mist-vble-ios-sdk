//
//  MistService.swift
//  SampleIndoorLocationReporting
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import Foundation


protocol MistService {
    func start()
    func stop()
}

#if !targetEnvironment(simulator)
import MistSDK

class RealMistService: NSObject, MistService {
    let mistManager: IndoorLocationManager
    
    init(token: String) {
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }
    
    func start() {
        
        // Subscribe other delegate callBack
        mistManager.virtualBeaconsDelegate = self
        mistManager.zonesDelegate = self
        mistManager.mapsListDelegate = self
        //mistManager.clientInformationDelegate = self
        
        // start mist indoor location service
        mistManager.start(with: self)
    }
    
    func stop() {
        // stop mist indoor location service
        mistManager.stop()
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {

    func didUpdate(_ map: MistMap!) {
        debugPrint(">>> didUpdate MistMap.name = \(map.name.description)")
    }

    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        debugPrint(">>> didUpdateRelativeLocation MistPoint = x=\(relativeLocation.x) y=\(relativeLocation.y)")
    }

    func didReceivedOrgInfo(withTokenName tokenName: String!, andOrgID orgID: String!) {
        debugPrint(">>> didReceivedOrgInfo tokenName = \(tokenName.description) orgID = \(orgID.description)")
    }

    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType.rawValue) errorMessage = \(errorMessage.description)")
    }
}

// MARK :- VirtualBeaconsDelegate
extension RealMistService: VirtualBeaconsDelegate {
    
    func didRangeVirtualBeacon(_ mistVirtualBeacon: MistVirtualBeacon!) {
        debugPrint(">>> didRangeVirtualBeacon MistVirtualBeacon.name = \(mistVirtualBeacon.name.description)")
    }
    
    func didUpdateVirtualBeaconList(_ mistVirtualBeacons: [MistVirtualBeacon]!) {
        debugPrint(">>> didUpdateVirtualBeaconList mistVirtualBeacons = \(mistVirtualBeacons.count)")
    }
}

// MARK :- ZonesDelegate
extension RealMistService: ZonesDelegate {
    
    func didEnter(_ mistZone: MistZone!) {
        debugPrint(">>> didEnter MistZone name = \(mistZone.name.description) ID = \(mistZone.zoneID.description)")
    }
    
    func didExitZone(_ mistZone: MistZone!) {
        debugPrint(">>> didExitZone MistZone name = \(mistZone.name.description) ID = \(mistZone.zoneID.description)")
    }
}

// MARK :- MapsListDelegate
extension RealMistService: MapsListDelegate {
    func didReceiveAllMaps(_ maps: [MistMap]!) {
        debugPrint(">>> didReceiveAllMaps maps = \(maps.count)")
    }
}

// MARK :- ClientInformationDelegate
extension RealMistService: ClientInformationDelegate {
    
    func onSuccess(_ clientName: String!) {
        debugPrint(">>> ClientInformationDelegate onSuccess name = \(clientName.description)")
    }
    
    func onError(_ errorType: ErrorType, andMessage errorMessage: String!) {
        debugPrint(">>> ClientInformationDelegate errorMessage = \(errorMessage.description)")
    }
}

#endif
