//
//  BeaconRegion.swift
//  SampleAppWakeUp
//
//  Created by Rajesh Vishwakarma on 01/03/23.
//

import Foundation
import CoreLocation

extension CLBeaconRegion {
    
    static func create(with name: String, uuid: UUID) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: name)
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyEntryStateOnDisplay = true
        return beaconRegion
    }
}
